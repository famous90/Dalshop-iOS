//
//  MyInfoViewController.m
//  flag-ios
//
//  Created by Hwang Gyuyoung on 2014. 5. 8..
//
//
#define MINIMUM_BIRTH_YEAR  1900
#define DEFAULT_BIRTH_YEAR_INDEX  87

#import "MyInfoViewController.h"

#import "User.h"

#import "Util.h"
#import "AbstractActionSheetPicker.h"
#import "ActionSheetStringPicker.h"
#import "URLParameters.h"

#import "FlagClient.h"
#import "GTLFlagengine.h"
#import "GoogleAnalytics.h"

@interface MyInfoViewController ()
- (void)occupationWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)birthYearWasSelected:(NSNumber *)selectedIndex element:(id)element;
@end

@implementation MyInfoViewController{
    BOOL isMan;
    BOOL isWoman;
    
    NSInteger birthYearIndex;
    NSMutableArray *birthYearData;
    
    NSInteger occupationIndex;
    NSArray *occupationData;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.user = [[User alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeLocation];
    [self setContenView];
    [self getUserInfo];

}

- (void)initializeLocation
{
    currentLocation = [[CLLocation alloc] init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    [locationManager startUpdatingLocation];
}

- (void)setContenView
{
    self.title = @"나의 정보";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.lineImageView1.backgroundColor = UIColorFromRGB(BASE_COLOR);
    self.lineImageView2.backgroundColor = UIColorFromRGB(BASE_COLOR);
    self.lineImageView3.backgroundColor = UIColorFromRGB(BASE_COLOR);
    self.lineImageView4.backgroundColor = UIColorFromRGB(BASE_COLOR);
    
    [self.manButton setImage:[UIImage imageNamed:@"button_man"] forState:UIControlStateNormal];
    [self.manButton setImage:[UIImage imageNamed:@"button_man_selected"] forState:UIControlStateSelected];
    
    [self.womanButton setImage:[UIImage imageNamed:@"button_woman"] forState:UIControlStateNormal];
    [self.womanButton setImage:[UIImage imageNamed:@"button_woman_selected"] forState:UIControlStateSelected];
    
    [self.birthYearButton setTitleColor:UIColorFromRGB(BASE_COLOR) forState:UIControlStateNormal];
    
    [self.occupationButton setTitleColor:UIColorFromRGB(BASE_COLOR) forState:UIControlStateNormal];
    
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton setBackgroundColor:UIColorFromRGB(BASE_COLOR)];
    
    // picker data source
    occupationData = [Util getListFromPropertyListFile:@"occupation"];
    [self setBirthYearData];
}

- (void)setBirthYearData
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit fromDate:now];
    NSInteger year = [components year];
    birthYearData = [[NSMutableArray alloc] init];
    for (int i=MINIMUM_BIRTH_YEAR; i<=year; i++) {
        [birthYearData addObject:[[NSNumber numberWithInt:i] stringValue]];
    }
}

- (void)getUserInfo
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"user_info"];
    [urlParam addParameterWithUserId:self.user.userId];
    NSURL *url = [urlParam getURLForRequest];
    
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        
        NSDictionary *result = [FlagClient getURLResultWithURL:url];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if (result) {
                [self setUserInfoWithData:result];
            }else{
                [self setUserInfoByDefault];
            }
            
        }];
    }];
}

- (void)setUserInfoWithData:(id)data
{
    isMan = [[data valueForKey:@"sex"] boolValue];
    isWoman = !isMan;
    
    NSString *birthStr = [data valueForKey:@"birth"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *birth = [formatter numberFromString:birthStr];
    birthYearIndex = [birth integerValue] - MINIMUM_BIRTH_YEAR;

    occupationIndex = [[data valueForKey:@"job"] integerValue];
    
    CGFloat lat = [[data valueForKey:@"lat"] floatValue];
    CGFloat lon = [[data valueForKey:@"lon"] floatValue];
    currentLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    
    [self setContentConfigureWithUserInfo];
}

- (void)setContentConfigureWithUserInfo
{
    [self setManAndWomanButton];
    [self.birthYearButton setTitle:[NSString stringWithFormat:@"%ld년생", (long)(birthYearIndex+MINIMUM_BIRTH_YEAR)] forState:UIControlStateNormal];
    [self.occupationButton setTitle:[occupationData objectAtIndex:occupationIndex] forState:UIControlStateNormal];
}

- (void)setUserInfoByDefault
{
    isMan = YES;
    isWoman = !isMan;
    birthYearIndex = DEFAULT_BIRTH_YEAR_INDEX;
    occupationIndex = 0;
    
    [self setManAndWomanButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Implementation
- (void)setManAndWomanButton
{
    [self.manButton setSelected:isMan];
    [self.womanButton setSelected:isWoman];
}

#pragma mark - 
#pragma mark IBAction
- (IBAction)manButtonTapped:(id)sender
{
    if (!isMan && !isWoman) {
        isMan = YES;
    }else{
        isMan = !isMan;
        isWoman = !isWoman;
    }
    
    [self setManAndWomanButton];
}

- (IBAction)womanButtonTapped:(id)sender
{
    if (!isMan && !isWoman) {
        isWoman = YES;
    }else{
        isMan = !isMan;
        isWoman = !isWoman;
    }
    
    [self setManAndWomanButton];
}

- (IBAction)birthYearButtonTapped:(id)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@"출생년도선택" rows:birthYearData initialSelection:birthYearIndex target:self successAction:@selector(birthYearWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

- (IBAction)birthYearPickerButtonTapped:(UIBarButtonItem *)sender
{
    [self birthYearButtonTapped:sender];

}

- (void)birthYearWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    birthYearIndex = [selectedIndex integerValue];
    [self.birthYearButton setTitle:[NSString stringWithFormat:@"%ld년생", birthYearIndex + MINIMUM_BIRTH_YEAR] forState:UIControlStateNormal];
}

- (IBAction)occupationButtonTapped:(id)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@"직업선택" rows:occupationData initialSelection:occupationIndex target:self successAction:@selector(occupationWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

- (IBAction)occupationPickerButtonTapped:(UIBarButtonItem *)sender
{
    [self occupationButtonTapped:sender];
}

- (void)occupationWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    occupationIndex = [selectedIndex integerValue];
    NSString *occupation = [occupationData objectAtIndex:occupationIndex];
    [self.occupationButton setTitle:occupation forState:UIControlStateNormal];
}

- (IBAction)saveButtonTapped:(id)sender
{
    [self sendUserInfo];
}

- (void)sendUserInfo
{
    GTLServiceFlagengine *service = [FlagClient flagengineService];
    
    GTLFlagengineUserInfo *userInfo = [GTLFlagengineUserInfo alloc];
    [userInfo setUserId:self.user.userId];
    [userInfo setBirth:[NSNumber numberWithInteger:birthYearIndex + MINIMUM_BIRTH_YEAR]];
    [userInfo setSex:[NSNumber numberWithBool:isMan]];
    [userInfo setJob:[NSNumber numberWithInteger:occupationIndex]];
    [userInfo setLat:[NSNumber numberWithFloat:currentLocation.coordinate.latitude]];
    [userInfo setLon:[NSNumber numberWithFloat:currentLocation.coordinate.longitude]];
    
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForUserInfosUpdateWithObject:userInfo];
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id result, NSError *error){
        if (error == nil) {
            [Util showAlertView:nil message:@"정보 업데이트를 완료하였습니다" title:@"나의 정보"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [Util showAlertView:nil message:@"업데이트에 실패하였습니다" title:@"나의 정보"];
        }
    }];
    
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Implementation
- (void)actionPickerCancelled:(id)sender
{
    NSLog(@"Delegate has been informed that ActionSheetPicker was cancelled");
}

#pragma mark -
#pragma mark location manager delegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"fail to update location with error %@", [error localizedDescription]);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    if (location) {
        
        currentLocation = [location mutableCopy];
        [locationManager stopUpdatingLocation];
        
    }else{
        
        currentLocation = [[CLLocation alloc] initWithLatitude:0 longitude:0];
        
    }
}
@end
