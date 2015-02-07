//
//  WelcomeViewController.h
//  Xiaoer
//
//  Created by KID on 15/1/13.
//
//

#import "SuperMainViewController.h"

typedef void(^BackActionCallBack)(BOOL isBack);

@interface WelcomeViewController : SuperMainViewController

@property (nonatomic, assign) BOOL showBackButton;
@property (nonatomic, strong) BackActionCallBack backActionCallBack;

@end
