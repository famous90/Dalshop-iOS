//
//  PageTutorialViewController.m
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 7. 12..
//
//

#import "PageTutorialViewController.h"

@interface PageTutorialViewController ()

@end

@implementation PageTutorialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeContent];
    
    // Analytics
    [self setScreenName:GAI_SCREEN_NAME_PAGE_TUTORIAL_VIEW];
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_APPEAR target:VIEW_FIRST_TUTORIAL value:0];
}

- (void)initializeContent
{
    self.pageTitles = @[@"달을 모으는 방법 1", @"달을 모으는 방법 2", @"달을 모으는 방법 3", @"달의 종류"];
    self.pageImages = @[@"tutorial_bluetooth", @"tutorial_reward_menu", @"tutorial_redeem", @""];
    self.pageSubTitles = @[@"1. 블루투스를 켜세요", @"2. 매장위치를 확인하세요", @"3. 매장에 들어가세요", @""];
    self.pageContents = @[@"(블루투스를 키셔야 자동으로 적립됩니다)", @"(오른쪽 상단에 위치한 버튼을 클릭해 보세요)", @"(적립성공! 당신의 쇼핑발걸음이 공짜 커피가 됩니다)", @""];
    
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageView"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *pageContentViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[pageContentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    CGFloat pageContentMargin = 60.0f;
    [self.pageViewController.view setFrame:CGRectMake(0, pageContentMargin, self.view.frame.size.width, self.view.frame.size.height - pageContentMargin)];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    
    [self.cancelButton setImage:[UIImage imageNamed:@"button_cancel"] forState:UIControlStateNormal];
    [self.cancelButton setTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    DLog(@"page index %d", index);
    
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentView"];
    [pageContentViewController setTitleText:[self.pageTitles objectAtIndex:index]];
    [pageContentViewController setImageFile:[self.pageImages objectAtIndex:index]];
    [pageContentViewController setSubTitleText:[self.pageSubTitles objectAtIndex:index]];
    [pageContentViewController setContent:[self.pageContents objectAtIndex:index]];
    [pageContentViewController setPageIndex:index];
    [pageContentViewController.view setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (IBAction)cancelButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:^(){
    }];
}
@end
