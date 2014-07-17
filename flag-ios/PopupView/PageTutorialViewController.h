//
//  PageTutorialViewController.h
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 7. 12..
//
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface PageTutorialViewController : GAITrackedViewController <UIPageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (nonatomic, strong) NSArray *pageTitles;
@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSArray *pageSubTitles;
@property (nonatomic, strong) NSArray *pageContents;

- (IBAction)cancelButtonTapped:(id)sender;

@end
