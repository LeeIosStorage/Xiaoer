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
    NSString *_loginType;
}
@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (assign, nonatomic) NSInteger selectedSegmentIndex;
@property (strong, nonatomic) IBOutlet UIView *loginContainerView;
@property (strong, nonatomic) IBOutlet UITextField *accountTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) IBOutlet UIView *registerContainerView;
@property (strong, nonatomic) IBOutlet UIImageView *registerTipImageView;
@property (strong, nonatomic) IBOutlet UILabel *registerTipLabel;
@property (strong, nonatomic) IBOutlet UIView *registerPhoneView;
@property (strong, nonatomic) IBOutlet UITextField *registerPhoneTextField;
@property (strong, nonatomic) IBOutlet UIButton *registerVerifyButton;
@property (strong, nonatomic) IBOutlet UIView *registerAffirmView;
@property (strong, nonatomic) IBOutlet UITextField *verifyAndemailTextField;
@property (strong, nonatomic) IBOutlet UIButton *registerAffirmButton;
@property (strong, nonatomic) IBOutlet UIButton *protocolButton;

@property (strong, nonatomic) IBOutlet UIView *socialContainerView;

- (IBAction)getCodeAction:(id)sender;
- (IBAction)loginAction:(id)sender;
- (IBAction)retrieveAction:(id)sender;
- (IBAction)socialLoginAction:(id)sender;
- (IBAction)protocolAction:(id)sender;
- (IBAction)registerAffimAction:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _selectedSegmentIndex = 0;
    [self setVcType:VcType_Login];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    //title
//    [self setTitle:@"注册"];
    //right buttom
    [self setRightButtonWithTitle:@"注册" selector:@selector(loginAndRegisterTypeAction:)];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"手机登录",@"邮箱登录"]];
    _segmentedControl.frame = CGRectMake((self.titleNavBar.frame.size.width-215)/2,self.titleNavBar.frame.size.height - 25 - 10 , 215, 25);
    _segmentedControl.tintColor = [UIColor whiteColor];
    _segmentedControl.selectedSegmentIndex = _selectedSegmentIndex;
    [_segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.titleNavBar addSubview:_segmentedControl];
}

-(void)setVcType:(VcType)vcType{
    _vcType = vcType;
    [self refreshUIControl];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)refreshUIControl{
    
    if (_vcType == VcType_Login) {
        [self setRightButtonWithTitle:@"注册"];
        [_segmentedControl setTitle:@"手机登录" forSegmentAtIndex:0];
        [_segmentedControl setTitle:@"邮箱登录" forSegmentAtIndex:1];
        self.loginButton.layer.cornerRadius = 4;
        self.loginButton.layer.masksToBounds = YES;
        
        [self.registerPhoneTextField resignFirstResponder];
        [self.verifyAndemailTextField resignFirstResponder];
        
        if (_selectedSegmentIndex == 0) {
            _accountTextField.placeholder = @"请输入手机号";
            _accountTextField.keyboardType = UIKeyboardTypeNumberPad;
        }else if (_selectedSegmentIndex == 1){
            _accountTextField.placeholder = @"请输入邮箱";
            _accountTextField.keyboardType = UIKeyboardTypeEmailAddress;
        }
        
        _loginContainerView.hidden = NO;
        _socialContainerView.hidden = NO;
        _registerContainerView.hidden = YES;
    }else if (_vcType == VcType_Register){
        [self setRightButtonWithTitle:@"登录"];
        [_segmentedControl setTitle:@"手机注册" forSegmentAtIndex:0];
        [_segmentedControl setTitle:@"邮箱注册" forSegmentAtIndex:1];
        [_protocolButton setTitleColor:UIColorToRGB(0x6cc5e9) forState:0];
        self.registerAffirmButton.layer.cornerRadius = 4;
        self.registerAffirmButton.layer.masksToBounds = YES;
        
        [self.accountTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        
        CGRect frame = self.registerAffirmView.frame;
        if (_selectedSegmentIndex == 0) {
            self.registerPhoneTextField.placeholder = @"请输入手机号";
            self.registerPhoneTextField.keyboardType = UIKeyboardTypeNumberPad;
            self.verifyAndemailTextField.placeholder = @"请输入收到的验证码";
            self.verifyAndemailTextField.keyboardType = UIKeyboardTypeNumberPad;
            self.registerTipLabel.text = @"为了验证您的身份\n我们将发送短信验证码";
            self.registerTipImageView.image = [UIImage imageNamed:@"login_sms_icon"];
            self.registerPhoneView.hidden = NO;
            frame.origin.y = self.registerPhoneView.frame.origin.y + self.registerPhoneView.frame.size.height;
        }else if (_selectedSegmentIndex == 1){
            self.verifyAndemailTextField.placeholder = nil;
            self.verifyAndemailTextField.keyboardType = UIKeyboardTypeEmailAddress;
            self.registerTipLabel.text = @"请输入您的邮箱账号";
            self.registerTipImageView.image = [UIImage imageNamed:@"verify_eamil_icon"];
            self.registerPhoneView.hidden = YES;
            frame.origin.y = self.registerPhoneView.frame.origin.y;
        }
        self.registerAffirmView.frame = frame;
        
        frame = self.registerTipLabel.frame;
        float textHeight = [self.registerTipLabel sizeThatFits:CGSizeMake(self.registerTipLabel.frame.size.width, CGFLOAT_MAX)].height;
        frame.size.height = textHeight;
        self.registerTipLabel.frame = frame;
        
        
        _loginContainerView.hidden = YES;
        _socialContainerView.hidden = YES;
        _registerContainerView.hidden = NO;
    }
    
}

#pragma mark - IBAction

-(void)loginAndRegisterTypeAction:(id)sender{
    
    if (_vcType == VcType_Login) {
        [self setVcType:VcType_Register];
    }else if (_vcType == VcType_Register) {
        [self setVcType:VcType_Login];
    }
    
}

- (IBAction)retrieveAction:(id)sender {
    RetrievePwdViewController *rpVc = [[RetrievePwdViewController alloc] init];
    rpVc.reType = (int)_selectedSegmentIndex;
    [self.navigationController pushViewController:rpVc animated:YES];
}

- (IBAction)socialLoginAction:(id)sender {
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
}

- (IBAction)protocolAction:(id)sender {
    
}

- (IBAction)registerAffimAction:(id)sender {
    
    if (_vcType == VcType_Register) {
        if (_selectedSegmentIndex == 0) {
            
        }else if (_selectedSegmentIndex == 1){
            
        }
    }
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
    
}

-(void)segmentedControlAction:(UISegmentedControl *)sender{
    
    _selectedSegmentIndex = sender.selectedSegmentIndex;
    [self refreshUIControl];
    switch (_selectedSegmentIndex) {
        case 0:
        {
            XELog(@"selectedSegmentIndex0");
        }
            break;
        case 1:
        {
            XELog(@"selectedSegmentIndex1");
        }
            break;
        default:
            break;
    }
}

@end
