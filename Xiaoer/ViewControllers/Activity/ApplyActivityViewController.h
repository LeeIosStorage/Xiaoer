//
//  ApplyActivityViewController.h
//  Xiaoer
//
//  Created by KID on 15/1/19.
//
//

#import "XESuperViewController.h"
#import "XEActivityInfo.h"

@interface ApplyActivityViewController : XESuperViewController

@property (nonatomic, strong) XEActivityInfo *activityInfo;
@property (nonatomic, strong) NSString *infoId;

@property (nonatomic, assign) int vcType; //0是活动报名 1卡包领取

@end
