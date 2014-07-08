//
//  UserPolicyViewController.h
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 6. 2..
//
//

#import <UIKit/UIKit.h>

@interface UserPolicyViewController : GAITrackedViewController

@property (weak, nonatomic) IBOutlet UITextView *policyTextView;
@property (nonatomic, strong) NSString *textFileName;
@property (nonatomic, assign) NSInteger parentPage;

@end
