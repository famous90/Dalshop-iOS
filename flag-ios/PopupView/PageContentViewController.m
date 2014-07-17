//
//  PageContentViewController.m
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 7. 12..
//
//

#define REWARD_TYPE_FIRST   0
#define REWARD_TYPE_SECOND  1
#define REWARD_TYPE_THIRD   2

#import "PageContentViewController.h"

#import "ViewUtil.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController{
    
    NSArray *rewardTypeImageViews;
    NSArray *rewardTypeSubtitleLabels;
    NSArray *rewardTypeMessageLabels;
    NSArray *rewardTypeImageFiles;
    NSArray *rewardTypeSubtitles;
    NSArray *rewardTypeMessages;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.pageIndex < 3) {
        [self initializeHowToRewardTutorialContent];
    }else if (self.pageIndex == 3){
        [self initializeRewardTypeTutorialContent];
    }
}

- (void)initializeHowToRewardTutorialContent
{
    [self rewardTypeContentHidden:YES];
    [self howToRewardContentHidden:NO];
    
    UIFont *titleFont = [UIFont boldSystemFontOfSize:25];
    UIFont *subTitleFont = [UIFont boldSystemFontOfSize:20];
    UIFont *contentFont = [UIFont systemFontOfSize:13];
    
    CGRect titleFrame = [self.titleText boundingRectWithSize:CGSizeMake(self.view.frame.size.width, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: titleFont} context:nil];
    CGRect subtitleFrame = [self.subTitleText boundingRectWithSize:CGSizeMake(self.view.frame.size.width, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: subTitleFont} context:nil];
    CGRect contentFrame = [self.content boundingRectWithSize:CGSizeMake(self.view.frame.size.width, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: contentFont} context:nil];
    
    CGFloat lineSpace = 8.0f;
    CGFloat contentTotalHeight = self.contentImageView.frame.size.height + lineSpace + subtitleFrame.size.height + lineSpace + contentFrame.size.height;
    CGFloat contentImageViewOriginY = (self.view.frame.size.height - contentTotalHeight)/2;
    
    UIColor *labelColor = [UIColor whiteColor];
    
    CGRect titleLabelFrame = CGRectMake((self.view.frame.size.width - titleFrame.size.width)/2, contentImageViewOriginY - lineSpace*2 - self.titleLabel.frame.size.height, titleFrame.size.width, titleFrame.size.height);
    [self.titleLabel setFrame:titleLabelFrame];
    [self.titleLabel setText:self.titleText];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setFont:titleFont];
    [self.titleLabel setTextColor:labelColor];
    
    CGRect imageFrame = CGRectMake(self.contentImageView.frame.origin.x, contentImageViewOriginY, self.contentImageView.frame.size.width, self.contentImageView.frame.size.height);
    [self.contentImageView setFrame:imageFrame];
    [self.contentImageView setImage:[UIImage imageNamed:self.imageFile]];
    
    CGRect subtitleLabelFrame = CGRectMake((self.view.frame.size.width - subtitleFrame.size.width)/2, [ViewUtil getOriginYBottomToFrame:self.contentImageView.frame] + lineSpace, subtitleFrame.size.width, subtitleFrame.size.height);
    [self.subTitleLabel setFrame:subtitleLabelFrame];
    [self.subTitleLabel setText:self.subTitleText];
    [self.subTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.subTitleLabel setFont:subTitleFont];
    [self.subTitleLabel setTextColor:labelColor];
    
    CGRect contentLabelFrame = CGRectMake((self.view.frame.size.width - contentFrame.size.width)/2, [ViewUtil getOriginYBottomToFrame:self.subTitleLabel.frame] + lineSpace, contentFrame.size.width, contentFrame.size.height);
    [self.contentLabel setFrame:contentLabelFrame];
    [self.contentLabel setText:self.content];
    [self.contentLabel setTextAlignment:NSTextAlignmentCenter];
    [self.contentLabel setFont:contentFont];
    [self.contentLabel setTextColor:labelColor];
    
}

- (void)initializeRewardTypeTutorialContent
{
    rewardTypeImageViews = @[self.content1ImageView, self.content2ImageView, self.content3ImageView];
    rewardTypeSubtitleLabels = @[self.subtitle1Label, self.subtitle2Label, self.subtitle3Label];
    rewardTypeMessageLabels = @[self.content1MessageLabel, self.content2MessageLabel, self.content3MessageLabel];
    rewardTypeImageFiles = @[@"icon_checkIn_done", @"icon_scan_before", @"icon_buy_done"];
    rewardTypeSubtitles = @[@"1. 체크인 리워드", @"2. 스캔 리워드", @"3. 구매 리워드"];
    rewardTypeMessages = @[@"(매장 방문시 자동으로 적립되는 리워드)", @"(매장에서 특정상품의 바코드 스캔 시 적립되는 리워드)", @"(매장에서 상품을 구매한 분들께 추가로 적립해주는 리워드)"];
    
    [self rewardTypeContentHidden:NO];
    [self howToRewardContentHidden:YES];
    
    
    UIFont *titleFont = [UIFont boldSystemFontOfSize:25];
    UIFont *subtitleFont = [UIFont boldSystemFontOfSize:15];
    UIFont *messageFont = [UIFont systemFontOfSize:12];
    
    UIColor *labelColor = [UIColor whiteColor];
    
    CGFloat originYFromTitleLabel;
    CGFloat paragraphSpace = self.view.frame.size.height/30;
    CGFloat lineSpace = self.view.frame.size.height/60;
    CGFloat lastViewOriginY;

    CGRect titleFrame = [self.titleText boundingRectWithSize:CGSizeMake(self.view.frame.size.width, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: titleFont} context:nil];
    CGRect titleLabelFrame = CGRectMake((self.view.frame.size.width - titleFrame.size.width)/2, self.view.frame.size.height/20, titleFrame.size.width, titleFrame.size.height);
    [self.titleLabel setFrame:titleLabelFrame];
    [self.titleLabel setText:self.titleText];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setFont:titleFont];
    [self.titleLabel setTextColor:labelColor];
    
    originYFromTitleLabel = [ViewUtil getOriginYBottomToFrame:self.titleLabel.frame];
    lastViewOriginY = originYFromTitleLabel;
    
    for (int i=0; i<3; i++) {
        
        UIImageView *imageView = [rewardTypeImageViews objectAtIndex:i];
        UIImage *contentImage = [UIImage imageNamed:[rewardTypeImageFiles objectAtIndex:i]];
        CGRect imageFrame = CGRectMake((self.view.frame.size.width - imageView.frame.size.width)/2, lastViewOriginY + paragraphSpace, imageView.frame.size.width, imageView.frame.size.height);
        [imageView setFrame:imageFrame];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImage:contentImage];
        lastViewOriginY += (paragraphSpace + imageFrame.size.height);
        
        NSString *subtitle = [rewardTypeSubtitles objectAtIndex:i];
        CGRect subtitleFrame = [subtitle boundingRectWithSize:CGSizeMake(self.view.frame.size.width, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: subtitleFont} context:nil];
        CGRect subtitleLabelFrame = CGRectMake((self.view.frame.size.width - subtitleFrame.size.width)/2, lastViewOriginY + lineSpace, subtitleFrame.size.width, subtitleFrame.size.height);
        UILabel *subtitleLabel = [rewardTypeSubtitleLabels objectAtIndex:i];
        [subtitleLabel setFrame:subtitleLabelFrame];
        [subtitleLabel setText:subtitle];
        [subtitleLabel setFont:subtitleFont];
        [subtitleLabel setTextColor:labelColor];
        lastViewOriginY += (lineSpace + subtitleLabel.frame.size.height);
        
        NSString *message = [rewardTypeMessages objectAtIndex:i];
        UILabel *messageLabel = [rewardTypeMessageLabels objectAtIndex:i];
        CGRect messageFrame = [message boundingRectWithSize:CGSizeMake(self.view.frame.size.width, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: messageFont} context:nil];
        CGRect messageLabelFrame = CGRectMake((self.view.frame.size.width - messageFrame.size.width)/2, lastViewOriginY + lineSpace, messageFrame.size.width, messageFrame.size.height);
        [messageLabel setFrame:messageLabelFrame];
        [messageLabel setText:message];
        [messageLabel setFont:messageFont];
        [messageLabel setTextColor:labelColor];
        lastViewOriginY += (lineSpace + messageLabel.frame.size.height);
    }
}

- (void)rewardTypeContentHidden:(BOOL)hidden
{
    [self.content1MessageLabel setHidden:hidden];
    [self.subtitle1Label setHidden:hidden];
    [self.content1MessageLabel setHidden:hidden];

    [self.content2MessageLabel setHidden:hidden];
    [self.subtitle2Label setHidden:hidden];
    [self.content2MessageLabel setHidden:hidden];

    [self.content3MessageLabel setHidden:hidden];
    [self.subtitle3Label setHidden:hidden];
    [self.content3MessageLabel setHidden:hidden];
}

- (void)howToRewardContentHidden:(BOOL)hidden
{
    [self.contentImageView setHidden:hidden];
    [self.subTitleLabel setHidden:hidden];
    [self.contentLabel setHidden:hidden];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
