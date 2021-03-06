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
#import "ShopViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APService.h"
#import "AddressInfoManager.h"
#import "BabyImpressMyPictureController.h"

#import "BabyImpressTransmitLoveController.h"

@interface AppDelegate () <NewIntroViewControllerDelegate,UIAlertViewDelegate>

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
    
    
    application.statusBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    _appMenu = [[UIMenuController alloc] init];
    
//    [XEUIUtils colorWithHex:0xb4b4b4 alpha:1.0];//180 180 180
    
    
    
    //友盟组件
    [UMSocialData setAppKey:UMS_APP];
    [UMSocialWechatHandler setWXAppId:UMS_WX_ID appSecret:UMS_WX_Key url:nil];
    [UMSocialQQHandler setQQWithAppId:UMS_QQ_ID appKey:UMS_QQ_Key    url:nil];
    [UMSocialQQHandler setSupportWebView:YES];
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];//@"http://sns.whalecloud.com/sina2/callback"
    
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
//    [NSThread sleepForTimeInterval:2.0];
    
    
    
    NSDictionary *plist = [[NSBundle mainBundle]infoDictionary];
    
    /**
     *  支付宝
     */
    self.seller = [plist objectForKey:@"seller"];
    self.patener = [plist objectForKey:@"patener"];
    self.privateKey = [plist objectForKey:@"privateKey"];
    
    
    
    /**
     *  七牛的mananger创建
     */
    self.upManager = [[QNUploadManager alloc] init];
    
    
    
    
    [self.window makeKeyAndVisible];
    
    /**
     *  激光推送
     */
    
    // Required
    #if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //categories
            [APService
             registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                 UIUserNotificationTypeSound |
                                                 UIUserNotificationTypeAlert)
             categories:nil];
        } else {
            //categories nil
            [APService
             registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert)
#else
             //categories nil
             categories:nil];
            [APService
             registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert)
#endif
             // Required
             categories:nil];
        }
    [APService setupWithOption:launchOptions];



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
    if ([XEEngine shareInstance].uid) {
        NSSet *set = [NSSet setWithObject:[XEEngine shareInstance].uid];
        [APService setTags:set callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }else{
        
        NSSet *set = [NSSet setWithObject:@"XiaoEr_Cancel"];
        [APService setTags:set callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
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
                                         [[ShopViewController alloc]init],
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
    
//    [self checkVersion];
//    [self motionCheckVerison];
    
}

- (void)signOut{
    NSLog(@"signOut");
    
    if([XESettingConfig isFirstEnterVersion]){
        [self showNewIntro];
        return;
    }

    NSSet *set = [NSSet setWithObject:@"XiaoEr_Cancel"];
    [APService setTags:set callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    [[AddressInfoManager manager]deleteFile];
    WelcomeViewController* welcomeViewController = [[WelcomeViewController alloc] init];
    XENavigationController* navigationController = [[XENavigationController alloc] initWithRootViewController:welcomeViewController];
    navigationController.navigationBarHidden = YES;
    self.window.rootViewController = navigationController;
    
    _mainTabViewController = nil;
    
    [[XEEngine shareInstance] logout];
//    [XEEngine shareInstance].firstLogin = YES;
}

/**
 *  自动检查更新
 */
- (void)motionCheckVerison{
    NSString *appID = @"967105015";
    NSString *urlStr = @"http://itunes.apple.com/lookup?id=967105015";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

   [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       if (!response) {
           NSLog(@"没有网络");
           return;
       }else{
           NSLog(@"有网络");
       }
       if (connectionError) {
           NSLog(@"error == %@",[connectionError description]);
           return ;
       }
       NSLog(@"response == %@",response);
       [self handleResponseWith:data];

       return;
        
    }];

    
    
    
    
    
}
- (void)handleResponseWith:(NSData *)data{
           NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
           NSLog(@"appInfoDic === %@",appInfoDic);
           NSArray *resultsArray = [appInfoDic objectForKey:@"results"];
           if (![resultsArray count]) {
               NSLog(@"error == resultsArray ==nil");
               return;
           }
           NSDictionary *info = [resultsArray objectAtIndex:0];
           //需要 verions trackViewUrl trackName
           NSString *latesrVerison = [info objectForKey:@"version"];
           NSString *trackViewUrl = [info objectForKey:@"trackViewUrl"];
           NSString *localVserion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
           NSLog(@"localVserion === %@  latesrVerison %@",localVserion,latesrVerison);
           if ([localVserion isEqualToString:latesrVerison]) {
               return;
           }
           XEAlertView *alert = [[XEAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@版本已上线", latesrVerison] message:@"宝爸宝妈快去更新吧" cancelButtonTitle:@"取消" cancelBlock:nil okButtonTitle:@"立刻更新" okBlock:^{
               //        NSURL *url = [[ NSURL alloc ] initWithString: @"http://itunes.apple.com/app/id967105015"] ;
               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
           }];
           [alert show];
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
            
            NSString *localVserion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSLog(@"localVserion --------------  %@",localVserion);
            NSString* version = nil;
            NSLog(@"jsonRet --------------  %@",jsonRet);
            version = [jsonRet stringObjectForKey:@"object"];
            
            NSString* checkedVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"checkedVersion"];
            NSLog(@"checkedVersion === %@",checkedVersion);
            if ([checkedVersion isEqualToString:version]) {
                return;
            }
//            }else{
//                                XEAlertView *alert = [[XEAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@版本已上线", version] message:@"宝爸宝妈快去更新吧" cancelButtonTitle:@"取消" cancelBlock:nil okButtonTitle:@"立刻更新" okBlock:^{
//                                    NSURL *url = [[ NSURL alloc ] initWithString: @"http://itunes.apple.com/app/id967105015"] ;
//                                    [[UIApplication sharedApplication] openURL:url];
//                                }];
//                                [alert show];
//            }
            
            [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"checkedVersion"];
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
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
        }];

        return YES;
    } else {
        return  [UMSocialSnsService handleOpenURL:url];
    }
    
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
    [APService resetBadge];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken ---------------  %@",deviceToken);
    [APService registerDeviceToken:deviceToken];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [APService handleRemoteNotification:userInfo];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"2收到通知:%@", userInfo);
    /*
     1;// 商城下单
     2;// 商城支付
     3;// 商城退款
     4;// 宝宝印象发货
     5;// 爱心单支付成功
     6;// 给爱心分赠送人的推送
     7;// 给爱心分获赠人的推送
     */
    [APService handleRemoteNotification:userInfo];
    self.type = [userInfo objectForKey:@"type"];

    NSDictionary *alertContent = [userInfo objectForKey:@"aps"];
    NSString *alertContentStr = [alertContent objectForKey:@"alert"];
    
    if ([userInfo objectForKey:@"type"]) {
        self.type = [[userInfo objectForKey:@"type"] stringValue];
    } else {
        self.type = [[userInfo objectForKeyedSubscript:@"type"] stringValue];
    }
    NSLog(@"self.type == %@",self.type);
    if ([self.type isEqualToString:@"5"]) {
        UIAlertView *remoteNotificationAlert = [[UIAlertView alloc] initWithTitle:@"消息推送" message:alertContentStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        remoteNotificationAlert.tag = 10001;
        [remoteNotificationAlert show];
    }else{
        
        UIAlertView *remoteNotificationAlert = [[UIAlertView alloc] initWithTitle:@"消息推送" message:alertContentStr delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"查看", nil];
        remoteNotificationAlert.tag = 10001;
        [remoteNotificationAlert show];
    }

    [UIApplication sharedApplication].applicationIconBadgeNumber += 1;
    NSLog(@"app badge = %ld",(long)[UIApplication sharedApplication].applicationIconBadgeNumber);
    [APService setBadge:[UIApplication sharedApplication].applicationIconBadgeNumber];
    
    completionHandler(UIBackgroundFetchResultNewData);
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"收到本地消息");
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
    
}


////极光推送绑定别名回掉
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    if ([XEEngine shareInstance].uid) {
        if (iResCode  == 6002) {
            NSSet *set = [NSSet setWithObject:[XEEngine shareInstance].uid];
            [APService setTags:set callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
        
        }
    }

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error======%@",error);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",(long)buttonIndex);
    if (buttonIndex == 0) {
        return;
    }
    if (![XEEngine shareInstance].uid) {
        
        if ([[XEEngine shareInstance] needUserLogin:nil]) {
            return;
        }
    }
    
    NSLog(@"app badge = %ld",(long)[UIApplication sharedApplication].applicationIconBadgeNumber);
    if ([self.type isEqualToString:@"4"]) {
        BabyImpressMyPictureController *my = [[BabyImpressMyPictureController alloc]init];
        UINavigationController *navi = (UINavigationController *)self.window.rootViewController;
        if ([navi.viewControllers.lastObject isKindOfClass:[BabyImpressMyPictureController class]]) {
            BabyImpressMyPictureController *baby = (BabyImpressMyPictureController *)navi.viewControllers.lastObject;
            [baby getPosedData];
        }else{
            
            [navi pushViewController:my animated:YES];
        }
    }
    
    if ([self.type isEqualToString:@"6"] || [self.type isEqualToString:@"7"]) {
        BabyImpressTransmitLoveController *my = [[BabyImpressTransmitLoveController alloc]init];
        UINavigationController *navi = (UINavigationController *)self.window.rootViewController;
        if ([navi.viewControllers.lastObject isKindOfClass:[BabyImpressTransmitLoveController class]]) {
            BabyImpressTransmitLoveController *baby = (BabyImpressTransmitLoveController *)navi.viewControllers.lastObject;
            [baby refreshUserInfo];
        }else{
            [navi pushViewController:my animated:YES];
        }
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber -= 1;
    [APService setBadge:[UIApplication sharedApplication].applicationIconBadgeNumber];

}

@end
