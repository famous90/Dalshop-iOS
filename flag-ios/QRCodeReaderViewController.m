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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:GAI_SCREEN_NAME_QRCODE_READER_VIEW];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.theItem.name;
    _captureSession = nil;
    
    if ([self startReading]) {
        [_stopButton setHidden:NO];
        [_statusLabel setText:@"Scanning for QR Code"];
    }
    _isReading = YES;
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
        
        if ([self.theItem isEqualToCodeString:[metadataObj stringValue]]) {
            
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
    if ([boolean boolValue]) {
        
        // GAI event
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action" action:@"scan_success" label:@"inside_view" value:nil] build]];
        
        alert = [[UIAlertView alloc] initWithTitle:@"match" message:@"상품이 확인되었습니다\n리워드가 적립되었습니다" delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        alert.tag = MATCH_ALERT_TAG;
        
    }else{
        
        // GAI event
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action" action:@"scan_fail" label:@"inside_view" value:nil] build]];
        
        alert = [[UIAlertView alloc] initWithTitle:@"match" message:@"일치하는 상품이 아닙니다" delegate:self cancelButtonTitle:nil otherButtonTitles:@"재시도", nil];
        alert.tag = NOT_MATCH_ALERT_TAG;
        
    }
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
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
    // 현재 아이템 리워드 얻음
    [self.itemListViewController changeItemRewardToRewardedWithItemId:self.theItem.itemId];
}

#pragma mark - alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == MATCH_ALERT_TAG) {
        
        [self didRedeemRewardItem];
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
