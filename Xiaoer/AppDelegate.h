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

@property (assign, nonatomic) BOOL firstLogin;

- (void)signIn;
- (void)signOut;

@end

