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
#import "XEEngine.h"
#import "XESettingConfig.h"
#import "WelcomeViewController.h"
#import "LSReachability.h"
#import "XEAlertView.h"
#import "APService.h"

@interface AppDelegate () <NewIntroViewControllerDelegate>

@end

@implementation AppDelegate

// Internal error reporting
void uncaughtExceptionHandler(NSException *exception) {
    
    NSLog(@"CRASH: %@", exception);
    
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    //极光推送
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    
    [APService setupWithOption:launchOptions];
    
    application.statusBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    _appMenu = [[UIMenuController alloc] init];
    
//    [XEUIUtils colorWithHex:0xb4b4b4 alpha:1.0];//180 180 180
    
    //友盟组件
    [UMSocialData setAppKey:UMS_APP];
    [UMSocialWechatHandler setWXAppId:UMS_WX_ID appSecret:UMS_WX_Key url:nil];
    [UMSocialQQHandler setQQWithAppId:UMS_QQ_ID appKey:UMS_QQ_Key    url:nil];
    [UMSocialQQHandler setSupportWebView:YES];
    [UMSocialSinaHandler openSSOWithRedirectURL:nil];//@"http://sns.whalecloud.com/sina2/callback"
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor clearColor];
    
    if ([[XEEngine shareInstance] hasAccoutLoggedin] || ![XEEngine shareInstance].firstLogin) {
        if ([XESettingConfig isFirstEnterVersion]) {
            [self showNewIntro];
        } else {
            [self signIn];
        }
    }else{
        NSLog(@"signOut for accout miss");
        [self signOut];
    }
    [NSThread sleepForTimeInterval:2.0];
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
    [APService setAlias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    if ([[XEEngine shareInstance] hasAccoutLoggedin]) {
        [XEEngine shareInstance].bVisitor = NO;
    }else {
        [XEEngine shareInstance].bVisitor = YES;
    }
    
    if([XESettingConfig isFirstEnterVersion]){
        [self showNewIntro];
        return;
    }
    
    [XESettingConfig saveEnterUsr];
    
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
    
    if (![XEEngine shareInstance].firstLogin) {
        _mainTabViewController.initialIndex = 0;
    }
    
    self.window.rootViewController = tabNavVc;
    
    [self checkVersion];
    
}

- (void)signOut{
    NSLog(@"signOut");
    
    if([XESettingConfig isFirstEnterVersion]){
        [self showNewIntro];
        return;
    }
    
    WelcomeViewController* welcomeViewController = [[WelcomeViewController alloc] init];
    XENavigationController* navigationController = [[XENavigationController alloc] initWithRootViewController:welcomeViewController];
    navigationController.navigationBarHidden = YES;
    self.window.rootViewController = navigationController;
    
    _mainTabViewController = nil;
    
    [[XEEngine shareInstance] logout];
//    [XEEngine shareInstance].firstLogin = YES;
}

- (void)checkVersion{
    if ([[LSReachability reachabilityForLocalWiFi] isReachableViaWiFi]) {
        int tag = [[XEEngine shareInstance] getConnectTag];
        //去服务器取版本信息
        [[XEEngine shareInstance] getAppNewVersionWithTag:tag];
        [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
            if (!jsonRet || err){
                return ;
            }

            NSString *localVserion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
            NSString* version = nil;
            
            version = [jsonRet stringObjectForKey:@"object"];
            
//            NSString* checkedVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"checkedVersion"];
//            if ([checkedVersion isEqualToString:version]) {
//                return;
//            }
//            [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"checkedVersion"];
            if ([XECommonUtils isVersion:version greaterThanVersion:localVserion]) {
                
                XEAlertView *alert = [[XEAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@版本已上线", version] message:@"宝爸宝妈快去更新吧" cancelButtonTitle:@"取消" cancelBlock:nil okButtonTitle:@"立刻更新" okBlock:^{
                    NSURL *url = [[ NSURL alloc ] initWithString: @"http://itunes.apple.com/app/id967105015"] ;
                    [[UIApplication sharedApplication] openURL:url];
                }];
                [alert show];
                return;
            }
        } tag:tag];
    }
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
    [self signOut];
//    [self signIn];
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", userInfo);
    NSDictionary *alertContent = [userInfo objectForKey:@"aps"];
    NSString *alertContentStr = [alertContent objectForKey:@"alert"];
    UIAlertView *remoteNotificationAlert = [[UIAlertView alloc] initWithTitle:@"消息推送" message:alertContentStr delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"查看", nil];
    [remoteNotificationAlert show];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", userInfo);
    
    NSDictionary *alertContent = [userInfo objectForKey:@"aps"];
    NSString *alertContentStr = [alertContent objectForKey:@"alert"];
    UIAlertView *remoteNotificationAlert = [[UIAlertView alloc] initWithTitle:@"消息推送" message:alertContentStr delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"查看", nil];
    remoteNotificationAlert.tag = 10001;
    [remoteNotificationAlert show];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

//极光推送绑定别名回掉
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}



@end
