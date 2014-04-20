//
//  QRCodeReaderViewController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 19..
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class Item;
@class ItemListViewController;

@interface QRCodeReaderViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>

@property (weak) ItemListViewController *itemListViewController;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@property (nonatomic, strong) Item *theItem;

//- (IBAction)stopButtonTapped:(id)sender;

@end
