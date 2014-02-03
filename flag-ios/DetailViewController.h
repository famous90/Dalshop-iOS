//
//  DetailViewController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 3..
//
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
