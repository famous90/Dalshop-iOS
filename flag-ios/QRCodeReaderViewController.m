//
//  QRCodeReaderViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 19..
//
//
#define NOT_MATCH_ALERT_TAG 0
#define MATCH_ALERT_TAG     1

#import "AppDelegate.h"
#import "QRCodeReaderViewController.h"
#import "ItemListViewController.h"

#import "Item.h"
#import "FlagDataController.h"
#import "Shop.h"
#import "ShopDataController.h"

#import "Util.h"
#import "ViewUtil.h"
#import "DataUtil.h"
#import "URLParameters.h"

#import "FlagClient.h"
#import "GTLFlagengine.h"
#import "GoogleAnalytics.h"

@interface QRCodeReaderViewController ()

@property (nonatomic) BOOL  isReading;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer    *previewViewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSString *codeValue;

- (BOOL)startReading;
- (void)stopReadingWithCheckBoolean:(NSNumber *)boolean;
//- (void)notCorrentCodeString;
- (void)loadBeepSound;
- (void)didRedeemRewardItem;

@end

@implementation QRCodeReaderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.item.name;
    _captureSession = nil;
    
    if ([self startReading]) {
        [_stopButton setHidden:NO];
        [_statusLabel setText:@"코드를 스캔해주세요"];
    }
    _isReading = YES;
    
    
    // GA
    [self setScreenName:GAI_SCREEN_NAME_QRCODE_READER_VIEW];
    //    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:GAI_SCREEN_NAME_QRCODE_READER_VIEW];
    //    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUser:[DelegateUtil getUser]];
    [ViewUtil setAppDelegatePresentingViewControllerWithViewController:self];
}


#pragma mark -
#pragma mark - IBAction
//- (IBAction)stopButtonTapped:(id)sender
//{
//    if (_isReading){
//        [self stopReadingWithCheckBoolean:[NSNumber]];
//        [_stopButton setHidden:YES];
//    }
//    
//    _isReading = !_isReading;
//}

#pragma mark - Implementation
- (BOOL)startReading
{
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode, nil]];
    
    _previewViewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_previewViewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_previewViewLayer setFrame:_previewView.layer.bounds];
    [_previewView.layer addSublayer:_previewViewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        if (_audioPlayer) {
            [_audioPlayer play];
        }
        
        if ([self.item isEqualToCodeString:[metadataObj stringValue]]) {
            
            [_statusLabel performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(stopReadingWithCheckBoolean:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:NO];
            _isReading = NO;
            
            NSLog(@"correct code read");

        }else{
            
            NSLog(@"incorrect code read");
            [_statusLabel performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(stopReadingWithCheckBoolean:) withObject:[NSNumber numberWithBool:NO] waitUntilDone:NO];
        }
    }
}

- (void)stopReadingWithCheckBoolean:(NSNumber *)boolean
{
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_previewViewLayer removeFromSuperlayer];
    
    UIAlertView *alert;
    
    // correct item scan
    if ([boolean boolValue]) {
        
        [self findShopOfScanItem];
        
    // not match item scanning
    }else{
        
        // GA
        [GAUtil sendGADataWithUIAction:@"scan_fail" label:@"inside_view" value:nil];
        
        
        alert = [[UIAlertView alloc] initWithTitle:@"match" message:@"일치하는 상품이 아닙니다" delegate:self cancelButtonTitle:nil otherButtonTitles:@"재시도", nil];
        alert.tag = NOT_MATCH_ALERT_TAG;
        
    }
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

- (void)findShopOfScanItem
{
    NSNumber *hqShopId = self.item.shopId;
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CLLocation *currentLocation = delegate.savedLocation;
    
    FlagDataController *flagData = [DataUtil getFlagListAroundLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
    NSArray *branchShopIds = [flagData shopIdListInFlagList];
    
    URLParameters *urlParams = [self urlToGetHQShopIdsWithBranchShopIds:branchShopIds];
    
    [FlagClient getDataResultWithURL:[urlParams getURLForRequest] methodName:[urlParams getMethodName] completion:^(NSDictionary *results){
        
        if (results) {
            
            // GA
            [GAUtil sendGADataWithUIAction:@"scan_success" label:@"inside_view" value:nil];
            
            
            [self checkItemScanIsRightWithData:results comparingShopId:hqShopId];
            
        }else{
            [self showWrongScanError];
        }
    }];
}

- (URLParameters *)urlToGetHQShopIdsWithBranchShopIds:(NSArray *)shopIds
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"shop_list"];
    for(NSNumber *shopId in shopIds){
        [urlParam addParameterWithKey:@"ids" withParameter:shopId];
    }
    [urlParam addParameterWithUserId:self.user.userId];
    
    return urlParam;
}

- (void)checkItemScanIsRightWithData:(NSDictionary *)results comparingShopId:(NSNumber *)hqShopId
{
    ShopDataController *shopData = [[ShopDataController alloc] init];
    NSArray *data = [results objectForKey:@"shops"];
    for(id object in data){
        Shop *theShop = [[Shop alloc] initWithData:object];
        [shopData addObjectWithObject:theShop];
    }
    NSArray *hqShopIds = [shopData getHQShopIds];
    
    for(NSNumber *shopId in hqShopIds){
        if ([shopId integerValue] == [hqShopId integerValue]) {
            // find
//            [self didRedeemRewardItem];
            [self showRightScanAlert];
            return;
        }
    }
    
    // not find
    [self showWrongScanError];
}

- (void)loadBeepSound
{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        NSLog(@"Could not play beep file");
        NSLog(@"%@", [error localizedDescription]);
    }else{
        [_audioPlayer prepareToPlay];
    }
}

- (void)didRedeemRewardItem
{
    NSDate *startDate = [NSDate date];
    
    // 현재 아이템 리워드 얻음
    GTLServiceFlagengine *service = [FlagClient flagengineService];
    
    GTLFlagengineReward *object = [GTLFlagengineReward alloc];
    [object setReward:[NSNumber numberWithInteger:self.item.reward]];
    [object setTargetId:self.item.itemId];
    [object setTargetName:self.item.name];
    [object setType:[NSNumber numberWithInt:REWARD_ITEM]];
    [object setUserId:self.user.userId];
    
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForRewardsInsertWithObject:object];
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error){
        
        if (error == nil) {
            
            [GAUtil sendGADataLoadTimeWithInterval:[[NSDate date] timeIntervalSinceDate:startDate] actionName:@"get_scan_reward" label:nil];
            [DataUtil saveRewardObjectWithObjectId:self.item.itemId type:REWARD_SCAN];
            self.itemListViewController.afterItemScan = YES;
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"아이템 스캔" message:@"리워드 적립 중 에러가 발생했습니다\n죄송하지만 다시 스캔해주세요" delegate:self cancelButtonTitle:nil otherButtonTitles:@"재시도", nil];
            [alert setTag:NOT_MATCH_ALERT_TAG];
            [alert show];
            
            NSLog(@"error occur %@ %@", error, [error localizedDescription]);
        }
    }];
    
}

#pragma mark - alert delegate
- (void)showWrongScanError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"아이템 스캔" message:@"스캔 상품이 올바르지 않네요\n다시 확인 후 스캔해주세요~" delegate:self cancelButtonTitle:nil otherButtonTitles:@"재시도", nil];
    alert.tag = NOT_MATCH_ALERT_TAG;
    
    [alert show];
}

- (void)showRightScanAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"아이템 스캔" message:@"s(~o~)/\n성공적으로 스캔했습니다\n다른 아이템도 스캔해보세요" delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
    alert.tag = MATCH_ALERT_TAG;
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == MATCH_ALERT_TAG) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if(alertView.tag == NOT_MATCH_ALERT_TAG){
     
        if ([self startReading]) {
            [_stopButton setHidden:NO];
            [_statusLabel setText:@"Scanning for QR Code"];
        }
        _isReading = YES;
    }
}
@end
