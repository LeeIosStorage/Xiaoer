//
//  WelcomeViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/13.
//
//

#import "WelcomeViewController.h"
#import "LoginViewController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "AppDelegate.h"
#import "MainPageViewController.h"
#import "EvaluationViewController.h"
#import "ExpertChatViewController.h"
#import "MineTabViewController.h"
#import "XENavigationController.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XEShare.h"
#import "WXApi.h"

@interface WelcomeViewController ()
{
    NSString *_loginType;
}
@property (nonatomic,strong) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *qqLoginButton;
@property (strong, nonatomic) IBOutlet UIButton *weiboLoginButton;
@property (strong, nonatomic) IBOutlet UIButton *weixinLoginButton;

- (IBAction)loginAction:(id)sender;
- (IBAction)registerAction:(id)sender;
- (IBAction)visitorAction:(id)sender;
- (IBAction)backAction:(id)sender;
- (IBAction)socialLoginAction:(id)sender;

@end

@implementation WelcomeViewController

- (void)viewWillAppear:(BOOL)animated{
    self.qqLoginButton.hidden= ![QQApi isQQInstalled];
    self.weixinLoginButton.hidden= ![WXApi isWXAppInstalled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.titleNavBar setHidden:YES];
    self.backButton.hidden = !_showBackButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender{
    if (_backActionCallBack) {
        _backActionCallBack(YES);
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)loginAction:(id)sender {
    [XEEngine shareInstance].firstLogin = NO;
    LoginViewController *mpVc = [[LoginViewController alloc] init];
    mpVc.vcType = VcType_Login;
    mpVc.isCanBack = _showBackButton;
    [self.navigationController pushViewController:mpVc animated:YES];
}

- (IBAction)registerAction:(id)sender {
    [XEEngine shareInstance].firstLogin = NO;
    LoginViewController *mpVc = [[LoginViewController alloc] init];
    mpVc.vcType = VcType_Register;
    mpVc.isCanBack = _showBackButton;
    [self.navigationController pushViewController:mpVc animated:YES];
}

- (IBAction)visitorAction:(id)sender {
    
    [XEEngine shareInstance].firstLogin = NO;
    [[XEEngine shareInstance] visitorLogin];
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate signIn];
    
//    XETabBarViewController* tabViewController = [[XETabBarViewController alloc] init];
//    tabViewController.viewControllers = [NSArray arrayWithObjects:
//                                         [[MainPageViewController alloc] init],
//                                         [[EvaluationViewController alloc] init],
//                                         [[ExpertChatViewController alloc] init],
//                                         [[MineTabViewController alloc] init],
//                                         nil];
//    
//    
//    appDelegate.mainTabViewController = tabViewController;
//    
//    XENavigationController* tabNavVc = [[XENavigationController alloc] initWithRootViewController:tabViewController];
//    tabNavVc.navigationBarHidden = YES;
//    appDelegate.window.rootViewController = tabNavVc;
    
//    MainPageViewController *mpVc = [[MainPageViewController alloc] init];
//    [self.navigationController pushViewController:mpVc animated:YES];
    
}

- (IBAction)socialLoginAction:(id)sender{
    
    if ([XECommonUtils NetworkConnected])
    {
        _loginType = @"";
        UIButton *button = (UIButton *)sender;
        if (button.tag == 0) {
            _loginType = [[NSString alloc]initWithString:UMShareToQQ];
            if (![QQApi isQQInstalled]) {
                [XEUIUtils showAlertWithMsg:@"您的设备没有安装QQ" title:@"温馨提示"];
                return;
            }
        }else if (button.tag == 1){
            _loginType = [[NSString alloc]initWithString:UMShareToSina];
        }else if (button.tag == 2){
            _loginType = [[NSString alloc]initWithString:UMShareToWechatSession];
        }
        __weak WelcomeViewController *weakSelf = self;
        int tag = [[XEEngine shareInstance] getConnectTag];
        [[XEEngine shareInstance] loginWithAccredit:_loginType presentingController:self tag:tag error:nil];
        [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
            NSString* errorMsg = [jsonRet stringObjectForKey:@"error"];
            if (!jsonRet || errorMsg) {
                [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
                return;
            }
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if ([_loginType isEqualToString:UMShareToSina]) {
                [dic setValue:[jsonRet objectForKey:@"usid"]     forKey:@"openId"];
                [dic setValue: @"3"                              forKey:@"type"];
                [dic setValue:[jsonRet objectForKey:@"username"] forKey:@"username"];
                [dic setValue:[jsonRet objectForKey:@"icon"]     forKey:@"avatar"];
                if ([[jsonRet objectForKey:@"gender"]intValue] == 0)
                    [dic setValue:@"f" forKey:@"gender"];
                else if ([[jsonRet objectForKey:@"gender"]intValue] == 1)
                    [dic setValue:@"m" forKey:@"gender"];
                else
                    [dic setValue:@"o" forKey:@"gender"];
            }else if ([_loginType isEqualToString:UMShareToQQ]){
                [dic setValue:[jsonRet objectForKey:@"uid"]         forKey:@"openId"];
                [dic setValue: @"2"                                 forKey:@"type"];
                [dic setValue:[jsonRet objectForKey:@"screen_name"] forKey:@"username"];
                [dic setValue:[jsonRet objectForKey:@"profile_image_url"]     forKey:@"avatar"];
                if ([[jsonRet objectForKey:@"gender"] isEqualToString:@"男"])
                    [dic setValue:@"m" forKey:@"gender"];
                else if ([[jsonRet objectForKey:@"gender"] isEqualToString:@"女"])
                    [dic setValue:@"f" forKey:@"gender"];
                else
                    [dic setValue:@"o" forKey:@"gender"];
            }else if ([_loginType isEqualToString:UMShareToWechatSession]){
                [dic setValue:[jsonRet objectForKey:@"openid"]      forKey:@"openId"];
                [dic setValue: @"1"                           forKey:@"type"];
                [dic setValue:[jsonRet objectForKey:@"screen_name"] forKey:@"username"];
                [dic setValue:[jsonRet objectForKey:@"profile_image_url"]     forKey:@"avatar"];
                if ([[jsonRet objectForKey:@"gender"] intValue] == 1)
                    [dic setValue:@"m" forKey:@"gender"];
                else if ([[jsonRet objectForKey:@"gender"] intValue] == 0)
                    [dic setValue:@"f" forKey:@"gender"];
                else
                    [dic setValue:@"o" forKey:@"gender"];
            }
            
            XELog(@"welcomeVc loginWithAccredit response = %@",dic);
            [weakSelf socialAffirmLogin:dic];
        }tag:tag];
    }else
        [XEProgressHUD AlertErrorNetwork];
}

-(void)socialAffirmLogin:(NSDictionary *)info{
    
    if (![info objectForKey:@"openId"]) {
        [XEProgressHUD AlertError:@"授权失败" At:self.view];
        return;
    }
    NSString *plantform = nil;
    if ([_loginType isEqualToString:UMShareToWechatSession]) {
        plantform = @"1";
    }else if ([_loginType isEqualToString:UMShareToQQ]){
        plantform = @"2";
    }else if ([_loginType isEqualToString:UMShareToSina]){
        plantform = @"3";
    }
    [XEProgressHUD AlertLoading:@"正在登录..." At:self.view];
    __weak WelcomeViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] thirdLoginWithPlantform:plantform avatar:[info objectForKey:@"avatar"] openid:[info objectForKey:@"openId"] nickname:[info objectForKey:@"username"] gender:[info objectForKey:@"gender"] tag:tag error:nil];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [jsonRet stringObjectForKey:@"error"];
        if (!jsonRet || errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        [XEProgressHUD AlertSuccess:@"登录成功." At:weakSelf.view];
        
        NSDictionary *object = [jsonRet objectForKey:@"object"];
        XEUserInfo *userInfo = [[XEUserInfo alloc] init];
        [userInfo setUserInfoByJsonDic:object];
        
        [XEEngine shareInstance].uid = userInfo.uid;
        [XEEngine shareInstance].account = userInfo.nickName;
        [XEEngine shareInstance].userPassword = userInfo.uid;
        [[XEEngine shareInstance] saveAccount];
        
        [XEEngine shareInstance].userInfo = userInfo;
        
        [weakSelf performSelector:@selector(loginFinished) withObject:nil afterDelay:1.0];
        
    }tag:tag];
    
}

-(void)loginFinished{
    
    if (_showBackButton) {
        [self backAction:nil];
    }else{
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate signIn];
    }
}

@end
