//
//  XEProgressHUD.h
//  Xiaoer
//
//  Created by KID on 15/1/4.
//
//

#import <Foundation/Foundation.h>

@interface XEProgressHUD : NSObject

//提示信息
+ (void) AlertLoading;
+ (void) AlertLoading:(NSString *)Info;
+ (void) AlertLoadDone;
+ (void) AlertSuccess:(NSString *)Info;
+ (void) AlertError:  (NSString *)Info;
+ (void) AlertErrorNetwork;
+ (void) AlertErrorTimeOut;

//当前页提示信息
+ (void) AlertLoading:(NSString *)Info At:(UIView *)view;
+ (void) AlertSuccess:(NSString *)Info At:(UIView *)view;
+ (void) AlertError:(NSString *)Info At:(UIView *)view;
+ (void) AlertErrorNetworkAt:(UIView *)view;
+ (void) AlertErrorTimeOutAt:(UIView *)view;

//从底部轻轻地弹出提示，2秒后默默得消失
+ (void) lightAlert:(NSString *)Info;

@end
