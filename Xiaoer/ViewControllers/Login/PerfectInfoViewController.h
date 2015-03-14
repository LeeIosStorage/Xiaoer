//
//  PerfectInfoViewController.h
//  Xiaoer
//
//  Created by KID on 15/1/8.
//
//

#import "XESuperViewController.h"
#import "XEUserInfo.h"
#import "XEActivityInfo.h"
#import "XECardInfo.h"

typedef void(^FinishedCallBack)(BOOL isFinish);

@interface PerfectInfoViewController : XESuperViewController

@property (nonatomic, strong) XEUserInfo *userInfo;
@property (nonatomic, assign) BOOL isNeedSkip;//注册成功完善时
@property (nonatomic, assign) BOOL isFromCard;//领取卡包完善时
@property (nonatomic, strong) XECardInfo *cardInfo;//isFromCard = YES时必传
@property (nonatomic, assign) BOOL isFromActivity;//活动报名完善时
@property (nonatomic, strong) XEActivityInfo *activityInfo;//isFromActivity = YES时必传

@property (nonatomic, strong) FinishedCallBack finishedCallBack;

@end
