//
//  PerfectInfoViewController.h
//  Xiaoer
//
//  Created by KID on 15/1/8.
//
//

#import "XESuperViewController.h"
#import "XEUserInfo.h"

@interface PerfectInfoViewController : XESuperViewController

@property (nonatomic, strong) XEUserInfo *userInfo;
@property (nonatomic, assign) BOOL isNeedSkip;

@end
