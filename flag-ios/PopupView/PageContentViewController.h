//
//  PageContentViewController.h
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 7. 12..
//
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *content1ImageView;
@property (weak, nonatomic) IBOutlet UILabel *subtitle1Label;
@property (weak, nonatomic) IBOutlet UILabel *content1MessageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *content2ImageView;
@property (weak, nonatomic) IBOutlet UILabel *subtitle2Label;
@property (weak, nonatomic) IBOutlet UILabel *content2MessageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *content3ImageView;
@property (weak, nonatomic) IBOutlet UILabel *subtitle3Label;
@property (weak, nonatomic) IBOutlet UILabel *content3MessageLabel;


@property (nonatomic, assign) NSUInteger pageIndex;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *imageFile;
@property (nonatomic, strong) NSString *subTitleText;
@property (nonatomic, strong) NSString *content;

@end
