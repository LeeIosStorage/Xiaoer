//
//  XEProgressHUD.m
//  Xiaoer
//
//  Created by KID on 15/1/4.
//
//

#import "XEProgressHUD.h"
#import "ProgressHUD.h"
#import "ProgressHUDJF.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@implementation XEProgressHUD

+ (void)AlertLoading
{
    [self AlertLoading:@"正在加载"];
}

+ (void)AlertLoading:(NSString *)Info At:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUDJF show:Info Interaction:NO atView:view];
    });
}

+ (void)AlertLoading:(NSString *)Info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUDJF show:Info Interaction:NO];
    });
}

+ (void)AlertLoadDone
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUDJF dismiss];
    });
}

+ (void)AlertSuccess:(NSString *)Info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD showSuccess:Info];
    });
}

+ (void)AlertError:(NSString *)Info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD showError:Info];
    });
}

+ (void)AlertErrorNetwork
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD showError:@"系统网络已被断开\n请连接网络后重试"];
    });
}

+ (void)AlertErrorTimeOut
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD showError:@"网络连接超时\n请您稍后再试"];
    });
}

+ (void) lightAlert:(NSString *)Info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = Info;
        HUD.margin = 10.f;
        CGRect mFrame = [UIScreen mainScreen].bounds;
        HUD.yOffset = mFrame.size.height/2 - 68;
        HUD.removeFromSuperViewOnHide = YES;
        [HUD hide:YES afterDelay:2];
    });
}


@end
