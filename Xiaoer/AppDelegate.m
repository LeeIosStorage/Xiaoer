//
//  AppDelegate.m
//  Xiaoer
//
//  Created by KID on 14/12/29.
//
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MainPageViewController.h"
#import "EvaluationViewController.h"
#import "ExpertChatViewController.h"
#import "MineTabViewController.h"
#import "XENavigationController.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocial.h"
#import "LoginViewController.h"
#import "NewIntroViewController.h"

@interface AppDelegate () <NewIntroViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    application.statusBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //友盟组件
    [UMSocialData setAppKey:UMS_APP];
    [UMSocialWechatHandler setWXAppId:UMS_WX_ID appSecret:UMS_WX_Key url:nil];
    [UMSocialQQHandler setQQWithAppId:UMS_QQ_ID appKey:UMS_QQ_Key    url:nil];
    [UMSocialQQHandler setSupportWebView:YES];
    [UMSocialSinaHandler openSSOWithRedirectURL:Sina_RedirectURL];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor clearColor];
    
    [self showNewIntro];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

//新手引导
-(void)showNewIntro{
    
    NewIntroViewController *introVc = [[NewIntroViewController alloc] init];
    introVc.delegate = self;
    self.window.rootViewController = introVc;
    
}

- (void)signIn{
    NSLog(@"signIn");
    
    XETabBarViewController* tabViewController = [[XETabBarViewController alloc] init];
    tabViewController.viewControllers = [NSArray arrayWithObjects:
                                         [[MainPageViewController alloc] init],
                                         [[EvaluationViewController alloc] init],
                                         [[ExpertChatViewController alloc] init],
                                         [[MineTabViewController alloc] init],
                                         nil];
    
    _mainTabViewController = tabViewController;
    
    XENavigationController* tabNavVc = [[XENavigationController alloc] initWithRootViewController:tabViewController];
    tabNavVc.navigationBarHidden = YES;
    self.window.rootViewController = tabNavVc;
    
}
- (void)signOut{
    NSLog(@"signOut");
    
    LoginViewController* loginViewController = [[LoginViewController alloc] init];
    XENavigationController* navigationController = [[XENavigationController alloc] initWithRootViewController:loginViewController];
    navigationController.navigationBarHidden = YES;
    self.window.rootViewController = navigationController;
    
    _mainTabViewController = nil;
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

#pragma mark -LSIntroduceVcDelegate

- (void)introduceVcFinish:(NewIntroViewController *)vc {
    [self signIn];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
