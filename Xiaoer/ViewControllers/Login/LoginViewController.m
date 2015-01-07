//
//  LoginViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/5.
//
//

#import "LoginViewController.h"
#import "UMSocial.h"
#import "XEProgressHUD.h"
#import "XEEngine.h"
#import "RetrievePwdViewController.h"

@interface LoginViewController ()
{
    NSString                *_loginType;
}

- (IBAction)getCodeAction:(id)sender;
- (IBAction)loginAction:(id)sender;
- (IBAction)retrieveAction:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    //title
    [self setTitle:@"注册"];
    //right buttom
    [self setRightButtonWithTitle:@"登录" selector:@selector(loginAction:)];
    
//    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] init];
//    segmentedControl.center = self.titleNavBar.center;
//    [self.titleNavBar addSubview:segmentedControl];
    
    UIView *categoryView = [[UIView alloc] init];
    categoryView.backgroundColor = [UIColor clearColor];
    categoryView.frame = CGRectMake(0, 0, 100, 30);
    categoryView.center = self.titleNavBar.center;
    [self.titleNavBar addSubview:categoryView];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBAction
- (IBAction)retrieveAction:(id)sender {
    RetrievePwdViewController *rpVc = [[RetrievePwdViewController alloc] init];
    rpVc.reType = TYPE_PHONE;
//    rpVc.reType = TYPE_EMAIL;
    [self.navigationController pushViewController:rpVc animated:YES];
}

- (IBAction)getCodeAction:(id)sender {
    
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getCodeWithPhone:@"13738168453" tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"获取失败";
            }
            return;
        }
        
    }tag:tag];
}

- (IBAction)loginAction:(id)sender {
    
    if (1)
    {
        _loginType = @"";
        UIButton *button = (UIButton *)sender;
        if (button.tag == 0) {
            _loginType = [[NSString alloc]initWithString:UMShareToQQ];
        }else if (button.tag == 1){
            _loginType = [[NSString alloc]initWithString:UMShareToSina];
        }else if (button.tag == 2){
            _loginType = [[NSString alloc]initWithString:UMShareToWechatSession];
        }
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:_loginType];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
                                      {
                                          if ([_loginType isEqualToString:UMShareToSina])
                                          {
                                              [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse)
                                               {
                                                   if (accountResponse.responseCode == UMSResponseCodeSuccess)
                                                   {
                                                       NSDictionary *info = [[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToSina];
                                                       if (info)
                                                       {
                                                           [XEProgressHUD AlertLoading:@"正在登录"];
                                                           NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                                                           [dic setValue:[info objectForKey:@"usid"]     forKey:@"openId"];
                                                           [dic setValue: @"2"                           forKey:@"type"];
                                                           [dic setValue:[info objectForKey:@"username"] forKey:@"username"];
                                                           [dic setValue:[info objectForKey:@"icon"]     forKey:@"avatar"];
                                                           if ([[info objectForKey:@"gender"]intValue] == 0)
                                                               [dic setValue:@"2" forKey:@"sex"];
                                                           else if ([[info objectForKey:@"gender"]intValue] == 1)
                                                               [dic setValue:@"1" forKey:@"sex"];
                                                           else
                                                               [dic setValue:@"0" forKey:@"sex"];
//                                                           [QHQnetworkingTool postWithURL:JFun_Login_Third params:dic
//                                                                                  success:^(id json)
//                                                            {
//                                                                [self LoginInfo:[json objectForKey:HTTP_Keys_Info]];
//                                                            }
//                                                                                  failure:^(NSError *error)
//                                                            {
//                                                                
//                                                            }];
                                                       }
                                                   }
                                                   else
                                                   {
                                                       [XEProgressHUD AlertError:accountResponse.message];
                                                   }
                                               }];
                                          }
                                          else if ([_loginType isEqualToString:UMShareToQQ])
                                          {
                                              [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ completion:^(UMSocialResponseEntity *respose)
                                               {
                                                   if (respose.responseCode == UMSResponseCodeSuccess)
                                                   {
                                                       NSDictionary *info = respose.data;
                                                       if (info)
                                                       {
                                                           [XEProgressHUD AlertLoading:@"正在登录"];
                                                           NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                                                           [dic setValue:[info objectForKey:@"uid"]      forKey:@"openId"];
                                                           [dic setValue: @"1"                           forKey:@"type"];
                                                           [dic setValue:[info objectForKey:@"screen_name"] forKey:@"username"];
                                                           [dic setValue:[info objectForKey:@"profile_image_url"]     forKey:@"avatar"];
                                                           if ([[info objectForKey:@"gender"] isEqualToString:@"男"])
                                                               [dic setValue:@"1" forKey:@"sex"];
                                                           else if ([[info objectForKey:@"gender"] isEqualToString:@"女"])
                                                               [dic setValue:@"2" forKey:@"sex"];
                                                           else
                                                               [dic setValue:@"0" forKey:@"sex"];
//                                                           [QHQnetworkingTool postWithURL:JFun_Login_Third params:dic
//                                                                                  success:^(id json)
//                                                            {
//                                                                [self LoginInfo:[json objectForKey:HTTP_Keys_Info]];
//                                                            }
//                                                                                  failure:^(NSError *error)
//                                                            {
//                                                                
//                                                            }];
                                                       }
                                                   }
                                                   else
                                                   {
                                                       [XEProgressHUD AlertError:respose.message];
                                                   }
                                               }];
                                          }
                                          else if ([_loginType isEqualToString:UMShareToWechatSession])
                                          {
                                              [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession completion:^(UMSocialResponseEntity *respose)
                                               {
                                                   if (respose.responseCode == UMSResponseCodeSuccess)
                                                   {
                                                       NSDictionary *info = respose.data;
                                                       if (info)
                                                       {
                                                           [XEProgressHUD AlertLoading:@"正在登录"];
                                                           NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                                                           [dic setValue:[info objectForKey:@"openid"]      forKey:@"openId"];
                                                           [dic setValue: @"4"                           forKey:@"type"];
                                                           [dic setValue:[info objectForKey:@"screen_name"] forKey:@"username"];
                                                           [dic setValue:[info objectForKey:@"profile_image_url"]     forKey:@"avatar"];
                                                           if ([[info objectForKey:@"gender"] intValue] == 1)
                                                               [dic setValue:@"1" forKey:@"sex"];
                                                           else if ([[info objectForKey:@"gender"] intValue] == 0)
                                                               [dic setValue:@"2" forKey:@"sex"];
                                                           else
                                                               [dic setValue:@"0" forKey:@"sex"];
//                                                           [QHQnetworkingTool postWithURL:JFun_Login_Third params:dic
//                                                                                  success:^(id json)
//                                                            {
//                                                                [self LoginInfo:[json objectForKey:HTTP_Keys_Info]];
//                                                            }
//                                                                                  failure:^(NSError *error)
//                                                            {
//                                                                
//                                                            }];
                                                       }
                                                   }
                                                   else
                                                   {
                                                       [XEProgressHUD AlertError:respose.message];
                                                   }
                                               }];
                                          }
                                      });
    }
    else
        [XEProgressHUD AlertErrorNetwork];
    
}
@end
