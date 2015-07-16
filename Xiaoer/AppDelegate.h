//
//  AppDelegate.h
//  Xiaoer
//
//  Created by KID on 14/12/29.
//
//

#import <UIKit/UIKit.h>
#import "XETabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readwrite, nonatomic) XETabBarViewController* mainTabViewController;
@property (strong, nonatomic) UIMenuController *appMenu;

- (void)signIn;
- (void)signOut;

/**
 *  合作商户ID
 */
@property (nonatomic,strong)NSString *patener;
/**
 *  账户
 */
@property (nonatomic,strong)NSString *seller;
/**
 *  商户私钥
 */
@property (nonatomic,strong)NSString *privateKey;
@end

