//
//  MyInfoViewController.m
//  flag-ios
//
//  Created by Hwang Gyuyoung on 2014. 5. 8..
//
//
#define MINIMUM_BIRTH_YEAR          1900
#define DEFAULT_BIRTH_YEAR_INDEX    87

#import "MyInfoViewController.h"

#import "User.h"

#import "Util.h"
#import "ViewUtil.h"
#import "DataUtil.h"
#import "NSDate+Utils.h"
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
    NSInteger sex;
    
    NSInteger birthYearIndex;
    NSMutableArray *birthYearData;
    
    NSInteger occupationIndex;
    NSArray *occupationData;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.user = [[User alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setContenView];
    
    if (self.parentPage == SLIDE_MENU_PAGE) {
        [self getUserInfo];
    }else if (self.parentPage == PHONE_CERTIFICATION_VIEW_PAGE){
        [self setUserInfoByDefault];
    }
    
    
    // Analytics
    [self setScreenName:GAI_SCREEN_NAME_ADDITIONAL_INFO_VIEW];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_APPEAR target:VIEW_EDIT_PROFILE value:0];
}

- (void)setContenView
{
    self.title = NSLocalizedString(@"My Info", @"My Info");
    
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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUser:[DelegateUtil getUser]];
    [ViewUtil setAppDelegatePresentingViewControllerWithViewController:self];
}

- (void)getUserInfo
{
    URLParameters *urlparams = [self urlParamsToGetUserInfo];
    
    [FlagClient getDataResultWithURL:[urlparams getURLForRequest] methodName:[urlparams getMethodName] completion:^(NSDictionary *result){
        
        if (result) {
            [self setUserInfoWithData:result];
        }else{
            [self setUserInfoByDefault];
        }
    }];
}

- (URLParameters *)urlParamsToGetUserInfo
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"user_info"];
    [urlParam addParameterWithUserId:self.user.userId];
    
    return urlParam;
}

- (void)setUserInfoWithData:(id)data
{
    sex = [[data valueForKey:@"sex"] integerValue];
    
    NSNumber *birth = [data valueForKey:@"birth"];
    NSInteger birthYear = [NSDate breakDownTimeInterval:[birth floatValue]/1000 toCalendarComponent:NSYearCalendarUnit];
    birthYearIndex = birthYear - MINIMUM_BIRTH_YEAR;

    occupationIndex = [[data valueForKey:@"job"] integerValue];
    
    [self setContentConfigureWithUserInfo];
}

- (void)setContentConfigureWithUserInfo
{
    [self setManAndWomanButton];
    [self.birthYearButton setTitle:[NSString stringWithFormat:@"%ld%@", (long)(birthYearIndex+MINIMUM_BIRTH_YEAR), NSLocalizedString(@"birth year", @"birth year")] forState:UIControlStateNormal];
    [self.occupationButton setTitle:[occupationData objectAtIndex:occupationIndex] forState:UIControlStateNormal];
}

- (void)setUserInfoByDefault
{
    sex = MALE;
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
    BOOL isMan;
    if (sex == MALE) {
        isMan = YES;
    }else isMan = NO;
    
    [self.manButton setSelected:isMan];
    [self.womanButton setSelected:!isMan];
}

#pragma mark - 
#pragma mark IBAction
- (IBAction)manButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"sex_click" label:@"inside_view" value:nil];

    
    [self changeSexToSex:MALE];
    [self setManAndWomanButton];
}

- (IBAction)womanButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"sex_click" label:@"inside_view" value:nil];

    
    [self changeSexToSex:FEMALE];
    [self setManAndWomanButton];
}

- (void)changeSexToSex:(NSInteger)theSex
{
    if (sex == theSex) {
        return;
    }
    
    if (sex == MALE) {
        sex = FEMALE;
    }else{
        sex = MALE;
    }
}

- (IBAction)birthYearButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"birth_year_click" label:@"inside_view" value:nil];

    
    [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"Select birth year", @"Select birth year") rows:birthYearData initialSelection:birthYearIndex target:self successAction:@selector(birthYearWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

- (IBAction)birthYearPickerButtonTapped:(UIBarButtonItem *)sender
{
    [self birthYearButtonTapped:sender];

}

- (void)birthYearWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    birthYearIndex = [selectedIndex integerValue];
    [self.birthYearButton setTitle:[NSString stringWithFormat:@"%ld%@", (long)(birthYearIndex + MINIMUM_BIRTH_YEAR), NSLocalizedString(@"birth year", @"birth year")] forState:UIControlStateNormal];
}

- (IBAction)occupationButtonTapped:(id)sender
{
    // GA
    [GAUtil sendGADataWithUIAction:@"occupation_click" label:@"inside_view" value:nil];

    
    [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"Select occupation", @"Select occupation") rows:occupationData initialSelection:occupationIndex target:self successAction:@selector(occupationWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
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
    // Analytics
    [GAUtil sendGADataWithUIAction:@"update_user_info" label:@"inside_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_DISAPPEAR target:VIEW_EDIT_PROFILE value:0];

    
    [self sendUserInfo];
}

- (void)sendUserInfo
{
    NSDate *startDate = [NSDate date];
    
    GTLServiceFlagengine *service = [FlagClient flagengineService];
    
    GTLFlagengineUserInfo *userInfo = [GTLFlagengineUserInfo alloc];
    [userInfo setUserId:self.user.userId];
    NSTimeInterval year = [NSDate generateTimeIntervalFromYear:(long)(birthYearIndex + MINIMUM_BIRTH_YEAR)];
    [userInfo setBirth:[NSNumber numberWithDouble:year*1000]];
    [userInfo setSex:[NSNumber numberWithInteger:sex]];
    [userInfo setJob:[NSNumber numberWithInteger:occupationIndex]];
    
    GTLQueryFlagengine *query = [GTLQueryFlagengine queryForUserInfosUpdateWithObject:userInfo];
    NSLog(@"userinfo %@", userInfo);
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLFlagengineUserInfo *result, NSError *error){
        
        if (error == nil) {
        
            // Analytics
            [GAUtil sendGADataLoadTimeWithInterval:[[NSDate date] timeIntervalSinceDate:startDate] actionName:@"send_user_info" label:nil];
            [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_DISAPPEAR target:VIEW_EDIT_PROFILE value:0];
            
            
            [self didUpdateAdditionalUserInfo];
        
        }else{
        
            NSLog(@"user info update error %@ %@", error, [error localizedDescription]);
            [Util showAlertView:nil message:NSLocalizedString(@"Failed to update", @"Failed to update") title:NSLocalizedString(@"My Info", @"My Info")];
        
        }
        
    }];
    
}

- (IBAction)cancel:(id)sender
{
    // Anaytics
    [GAUtil sendGADataWithUIAction:@"go_back" label:@"escape_view" value:nil];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_DISAPPEAR target:VIEW_EDIT_PROFILE value:0];
    
    
    if (self.parentPage == SLIDE_MENU_PAGE) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark Implementation
- (void)actionPickerCancelled:(id)sender
{
    NSLog(@"Delegate has been informed that ActionSheetPicker was cancelled");
}

- (void)didUpdateAdditionalUserInfo
{
    [DataUtil saveUserAdditionalInfoEntered];
    
    if (self.parentPage == SLIDE_MENU_PAGE) {
        
        [Util showAlertView:nil message:NSLocalizedString(@"Success updating", @"Success updating") title:NSLocalizedString(@"My Info", @"My Info")];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else if (self.parentPage == PHONE_CERTIFICATION_VIEW_PAGE){
        
        [Util showAlertView:nil message:NSLocalizedString(@"Updated additional info", @"Updated additional info") title:NSLocalizedString(@"My Info", @"My Info")];
        [ViewUtil presentTabbarViewControllerInView:self withUser:self.user];
        
    }
}

@end
