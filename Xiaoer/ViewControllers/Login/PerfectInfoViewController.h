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
@property (nonatomic, assign) BOOL isNeedSkip;//注册成功完善时
@property (nonatomic, assign) BOOL isFromCard;//领取卡包完善时

@end
