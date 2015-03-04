//
//  SetPwdViewController.h
//  Xiaoer
//
//  Created by KID on 15/1/7.
//
//

#import "XESuperViewController.h"
#import "XEUserInfo.h"

@interface SetPwdViewController : XESuperViewController

@property (nonatomic, assign) BOOL isCanBack;//
@property (nonatomic, strong) NSString *registerName;
@property (nonatomic, strong) XEUserInfo *userInfo;

@end
