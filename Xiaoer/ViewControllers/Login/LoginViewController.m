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

@interface LoginViewController ()
{
    NSString                *_loginType;
}
- (IBAction)loginAction:(id)sender;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBAction
- (IBAction)loginAction:(id)sender {
    
    if (1)
    {
        _loginType = @"";
        _loginType = [[NSString alloc]initWithString:UMShareToSina];//UMShareToQQ UMShareToWechatSession //UMShareToSina
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
