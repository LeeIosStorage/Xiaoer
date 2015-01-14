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
#import "SetPwdViewController.h"
#import "XEUserInfo.h"
#import "AppDelegate.h"
#import "NSString+Value.h"

@interface LoginViewController () <UITextFieldDelegate>
{
    NSString *_loginType;
    NSString *_registerPhoneTextFieldText;
    NSString *_loginPhoneTextFieldText;
    NSString *_loginPasswordTextFieldText;
}
//@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (assign, nonatomic) NSInteger selectedSegmentIndex;
@property (strong, nonatomic) IBOutlet UIView *loginContainerView;
@property (strong, nonatomic) IBOutlet UITextField *accountTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *retrievePasswordButton;

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkTextChaneg:) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _selectedSegmentIndex = 0;
    //[self setVcType:VcType_Login];
    [self refreshUIControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    //title
//    [self setTitle:@"注册"];
    //right buttom
    //[self setRightButtonWithTitle:@"注册" selector:@selector(loginAndRegisterTypeAction:)];
    
    [self setSegmentedControlWithSelector:@selector(segmentedControlAction:) items:@[@"手机登录",@"邮箱登录"]];
    
//    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"手机登录",@"邮箱登录"]];
//    _segmentedControl.frame = CGRectMake((self.view.bounds.size.width-215)/2,self.titleNavBar.frame.size.height - 25 - 10 , 215, 25);
//    _segmentedControl.tintColor = [UIColor whiteColor];
//    _segmentedControl.selectedSegmentIndex = _selectedSegmentIndex;
//    [_segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
//    [self.titleNavBar addSubview:_segmentedControl];
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
       // [self setRightButtonWithTitle:@"注册"];
        [self.segmentedControl setTitle:@"手机登录" forSegmentAtIndex:0];
        [self.segmentedControl setTitle:@"邮箱登录" forSegmentAtIndex:1];
        self.loginButton.layer.cornerRadius = 4;
        self.loginButton.layer.masksToBounds = YES;
        [_retrievePasswordButton setTitleColor:UIColorToRGB(0x6cc5e9) forState:0];
        
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
        
        [self loginButtonEnabled];
        
    }else if (_vcType == VcType_Register){
      //  [self setRightButtonWithTitle:@"登录"];
        [self.segmentedControl setTitle:@"手机注册" forSegmentAtIndex:0];
        [self.segmentedControl setTitle:@"邮箱注册" forSegmentAtIndex:1];
        [_protocolButton setTitleColor:UIColorToRGB(0x6cc5e9) forState:0];
        
        self.registerAffirmButton.layer.cornerRadius = 4;
        self.registerAffirmButton.layer.masksToBounds = YES;
        
        [self.accountTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        
        self.verifyAndemailTextField.text = nil;
        
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
        
        [self loginButtonEnabled];
    }
    
}

- (BOOL)loginButtonEnabled{
    if (_vcType == VcType_Login) {
        if (_selectedSegmentIndex == 0) {
            if ([[_accountTextField text] isPhone] && ([_passwordTextField text].length >= 6 &&[_passwordTextField text].length <= 15)) {
                _loginButton.enabled = YES;
                return YES;
            }
            _loginButton.enabled = NO;
            return NO;
        }else if (_selectedSegmentIndex == 1){
            if ([[_accountTextField text] isEmail] && ([_passwordTextField text].length >= 6 &&[_passwordTextField text].length <= 15)) {
                _loginButton.enabled = YES;
                return YES;
            }
            _loginButton.enabled = NO;
            return NO;
        }
    }else if (_vcType == VcType_Register){
        if (_selectedSegmentIndex == 0) {
            if ([[_registerPhoneTextField text] isPhone]) {
                _registerVerifyButton.enabled = YES;
                [_registerVerifyButton setBackgroundColor:UIColorToRGB(0x6cc5e9)];
                if (_verifyAndemailTextField.text.length > 0) {
                    _registerAffirmButton.enabled = YES;
                    return YES;
                }
                _registerAffirmButton.enabled = NO;
                return YES;
            }
            _registerVerifyButton.enabled = NO;
            _registerAffirmButton.enabled = NO;
            [_registerVerifyButton setBackgroundColor:UIColorToRGB(0x699db2)];
            return NO;
            
        }else if (_selectedSegmentIndex == 1){
            if ([[_verifyAndemailTextField text] isEmail] ) {
                _registerAffirmButton.enabled = YES;
                return YES;
            }
            _registerAffirmButton.enabled = NO;
            return NO;
        }
    }
    return NO;
}

- (void)checkTextChaneg:(NSNotification *)notif
{
//    UITextField *textField = notif.object;
    if (_selectedSegmentIndex == 0) {
        [self loginButtonEnabled];
    }else if (_selectedSegmentIndex == 1){
        [self loginButtonEnabled];
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        return NO;
    }
    if (!string.length && range.length > 0) {
        return YES;
    }
    NSString *oldString = [textField.text copy];
    NSString *newString = [oldString stringByReplacingCharactersInRange:range withString:string];
    
    if (_vcType == VcType_Login) {
        if (_selectedSegmentIndex == 0) {
            if (textField == _accountTextField && textField.markedTextRange == nil) {
                if (newString.length > 11 && textField.text.length >= 11) {
                    return NO;
                }
            }else if (textField == _passwordTextField){
                if (newString.length > 15 && textField.text.length >= 15) {
                    return NO;
                }
            }
            return YES;
        }else if (_selectedSegmentIndex == 1){
            if (textField == _passwordTextField){
                if (newString.length > 15 && textField.text.length >= 15) {
                    return NO;
                }
            }
        }
    }else if (_vcType == VcType_Register){
        if (_selectedSegmentIndex == 0) {
            if (textField == _registerPhoneTextField && textField.markedTextRange == nil) {
                if (newString.length > 11 && textField.text.length >= 11) {
                    return NO;
                }
            }
            return YES;
        }else if (_selectedSegmentIndex == 1){
            
        }
    }
    return YES;
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
            [self checkCode];
        }else if (_selectedSegmentIndex == 1){
            [self checkEmail];
        }
    }
}

- (IBAction)getCodeAction:(id)sender {
    
    [self checkPhone];
}

- (IBAction)loginAction:(id)sender {
    
    if (_vcType == VcType_Login) {
        if (_selectedSegmentIndex == 0) {
            [self loginWithPhone];
        }else if (_selectedSegmentIndex == 1){
            [self loginWithPhone];
        }
    }
}

-(void)segmentedControlAction:(UISegmentedControl *)sender{
    
    _selectedSegmentIndex = sender.selectedSegmentIndex;
    [self refreshUIControl];
    
    [self.registerPhoneTextField resignFirstResponder];
    self.registerPhoneTextField.text = nil;
    [self.verifyAndemailTextField resignFirstResponder];
    self.verifyAndemailTextField.text = nil;
    
    [self.accountTextField resignFirstResponder];
    self.accountTextField.text = nil;
    [self.passwordTextField resignFirstResponder];
    self.passwordTextField.text = nil;
    
    switch (_selectedSegmentIndex) {
        case 0:
        {
            XELog(@"selectedSegmentIndex0");
        }
            break;
        case 1:
        {
            XELog(@"selectedSegmentIndex1");
//            SetPwdViewController *spVc = [[SetPwdViewController alloc] init];
//            spVc.registerName = @"13888888888";
//            [self.navigationController pushViewController:spVc animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)loginWithPhone{
    
    _loginPhoneTextFieldText = [_accountTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (_loginPhoneTextFieldText.length == 0) {
        [XEProgressHUD lightAlert:@"请输入手机号"];
        return;
    }
    _loginPasswordTextFieldText = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (_loginPasswordTextFieldText.length == 0) {
        [XEProgressHUD lightAlert:@"请输入密码"];
        return;
    }
    [XEProgressHUD AlertLoading:@"正在登录..."];
    __weak LoginViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] loginWithUid:_loginPhoneTextFieldText password:_loginPasswordTextFieldText tag:tag error:nil];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg];
            return;
        }
        [XEProgressHUD AlertSuccess:@"登录成功."];
        
        NSDictionary *object = [jsonRet objectForKey:@"object"];
        XEUserInfo *userInfo = [[XEUserInfo alloc] init];
        [userInfo setUserInfoByJsonDic:object];
        [XEEngine shareInstance].userInfo = userInfo;
        
        [XEEngine shareInstance].uid = userInfo.uid;
        [XEEngine shareInstance].account = userInfo.account;
        [XEEngine shareInstance].userPassword = _passwordTextField.text;
        [[XEEngine shareInstance] saveAccount];
        
        [weakSelf performSelector:@selector(loginFinished) withObject:nil afterDelay:1.0];
        
    }tag:tag];
    
}
-(void)loginWithEmail{
    
}

-(void)loginFinished{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate signIn];
}

-(void)checkCode{
    
    _registerPhoneTextFieldText = [_registerPhoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (_registerPhoneTextFieldText.length == 0) {
        [XEProgressHUD lightAlert:@"请输入手机号"];
        return;
    }
    NSString *verifyAndemailTextFieldText = [_verifyAndemailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (verifyAndemailTextFieldText.length == 0) {
        [XEProgressHUD lightAlert:@"请输入验证码"];
        return;
    }
    
    [XEProgressHUD AlertLoading:@"正在验证,请稍等"];
    __weak LoginViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] checkCodeWithPhone:_registerPhoneTextFieldText code:verifyAndemailTextFieldText codeType:@"0" tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
//            [XEProgressHUD AlertError:errorMsg];
            [XEUIUtils showAlertWithMsg:errorMsg];
            return;
        }
        SetPwdViewController *spVc = [[SetPwdViewController alloc] init];
        spVc.registerName = _registerPhoneTextFieldText;
        [weakSelf.navigationController pushViewController:spVc animated:YES];
        
    }tag:tag];

}

-(void)sendCode{
    _registerPhoneTextFieldText = [_registerPhoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (_registerPhoneTextFieldText.length == 0) {
        [XEProgressHUD lightAlert:@"请输入手机号"];
        return;
    }
    
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getCodeWithPhone:_registerPhoneTextFieldText type:@"0" tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败!";
            }
            [XEProgressHUD AlertError:errorMsg];
            return;
        }
        
        [XEProgressHUD AlertSuccess:@"验证码发送成功."];
        
    }tag:tag];
}

-(void)checkPhone{
    
    _registerPhoneTextFieldText = [_registerPhoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (_registerPhoneTextFieldText.length == 0) {
        [XEProgressHUD lightAlert:@"请输入手机号"];
        return;
    }
    
    [XEProgressHUD AlertLoading:@"正在验证手机号"];
    __weak LoginViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] checkPhoneWithPhone:_registerPhoneTextFieldText uid:nil tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败!";
            }
//            [XEProgressHUD AlertError:errorMsg];
            [XEUIUtils showAlertWithMsg:errorMsg];
            return;
        }
        [weakSelf sendCode];
        
    }tag:tag];
    
}

-(void)checkEmail{
    
    NSString *verifyAndemailTextFieldText = [_verifyAndemailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (verifyAndemailTextFieldText.length == 0) {
        [XEProgressHUD lightAlert:@"请输入邮箱"];
        return;
    }
    
    [XEProgressHUD AlertLoading:@"正在验证邮箱"];
    __weak LoginViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] checkEmailWithEmail:verifyAndemailTextFieldText uid:nil tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
//            [XEProgressHUD AlertError:errorMsg];
            [XEUIUtils showAlertWithMsg:errorMsg];
            return;
        }
        
        [XEProgressHUD AlertSuccess:@"邮箱验证通过."];
        
        SetPwdViewController *spVc = [[SetPwdViewController alloc] init];
        spVc.registerName = verifyAndemailTextFieldText;
        [weakSelf.navigationController pushViewController:spVc animated:YES];
        
    }tag:tag];
}

//-(void)registerWithPhone{
//    
//    _registerPhoneTextFieldText = [_registerPhoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if (_registerPhoneTextFieldText.length == 0) {
//        [XEProgressHUD lightAlert:@"请输入手机号"];
//        return;
//    }
//    NSString *verifyAndemailTextFieldText = [_verifyAndemailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if (verifyAndemailTextFieldText.length == 0) {
//        [XEProgressHUD lightAlert:@"请输入验证码"];
//        return;
//    }
//    
////    __weak LoginViewController *weakSelf = self;
//    int tag = [[XEEngine shareInstance] getConnectTag];
//    [[XEEngine shareInstance] registerWithPhone:@"13803833466" password:@"916881" tag:tag];
//    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
//        if (!jsonRet || errorMsg) {
//            if (!errorMsg.length) {
//                errorMsg = @"获取失败";
//            }
//            return;
//        }
//        
//        
//        
//    }tag:tag];
//}
//
//-(void)registerWithEmail{
//    
//    //    __weak LoginViewController *weakSelf = self;
//    int tag = [[XEEngine shareInstance] getConnectTag];
//    [[XEEngine shareInstance] registerWithEmail:@"123@qq.com" password:@"123456" tag:tag];
//    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
//        if (!jsonRet || errorMsg) {
//            if (!errorMsg.length) {
//                errorMsg = @"获取失败";
//            }
//            return;
//        }
//        
//    }tag:tag];
//}

@end
