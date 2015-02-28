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
#import "XELinkerHandler.h"
#import "XECommonWebVc.h"
#import "XEActionSheet.h"

@interface LoginViewController () <UITextFieldDelegate>
{
    NSString *_loginType;
    NSString *_registerPhoneTextFieldText;
    NSString *_registerEmailTextFieldText;
    NSString *_registerCodeTextFieldText;
    NSString *_loginPhoneTextFieldText;
    NSString *_loginEmailTextFieldText;
    NSString *_loginPasswordTextFieldText;
    CGRect _oldRect;
    
    int _waitSmsSecond;
    NSTimer *_waitTimer;
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

@property (nonatomic, assign) BOOL bViewDisappear;

- (IBAction)getCodeAction:(id)sender;
- (IBAction)loginAction:(id)sender;
- (IBAction)retrieveAction:(id)sender;
- (IBAction)socialLoginAction:(id)sender;
- (IBAction)protocolAction:(id)sender;
- (IBAction)registerAffimAction:(id)sender;

@end

@implementation LoginViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkTextChaneg:) name:UITextFieldTextDidChangeNotification object:nil];
//    _bViewDisappear = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [self TextFieldResignFirstResponder];
    if (_waitTimer) {
        [_waitTimer invalidate];
        _waitTimer = nil;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _bViewDisappear = NO;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _bViewDisappear = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
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

- (void)waitTimerInterval:(NSTimer *)aTimer{
    XELog(@"a Timer waitSmsSecond = %d",_waitSmsSecond);
    if (_waitSmsSecond <= 0) {
        [aTimer invalidate];
        _waitTimer = nil;
        if ([[_registerPhoneTextField text] isPhone]) {
            _registerVerifyButton.enabled = YES;
            [_registerVerifyButton setBackgroundColor:UIColorToRGB(0x6cc5e9)];
        }
        [_registerVerifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        return;
    }
    
    [_registerVerifyButton setTitle:[NSString stringWithFormat:@"%d秒",_waitSmsSecond] forState:UIControlStateNormal];
    
    _waitSmsSecond--;
    
}

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
            _loginEmailTextFieldText = self.accountTextField.text;
            self.accountTextField.text = _loginPhoneTextFieldText;
        }else if (_selectedSegmentIndex == 1){
            _accountTextField.placeholder = @"请输入邮箱";
            _accountTextField.keyboardType = UIKeyboardTypeEmailAddress;
            _loginPhoneTextFieldText = self.accountTextField.text;
            self.accountTextField.text = _loginEmailTextFieldText;
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
        
        CGRect frame = self.registerAffirmView.frame;
        if (_selectedSegmentIndex == 0) {
            _registerEmailTextFieldText = self.verifyAndemailTextField.text;
            self.verifyAndemailTextField.text = _registerCodeTextFieldText;
            self.registerPhoneTextField.placeholder = @"请输入手机号";
            self.registerPhoneTextField.keyboardType = UIKeyboardTypeNumberPad;
            self.verifyAndemailTextField.placeholder = @"请输入收到的验证码";
            self.verifyAndemailTextField.keyboardType = UIKeyboardTypeNumberPad;
            self.registerTipLabel.text = @"为了验证您的身份\n我们将发送短信验证码";
            self.registerTipImageView.image = [UIImage imageNamed:@"login_sms_icon"];
            self.registerPhoneView.hidden = NO;
            frame.origin.y = self.registerPhoneView.frame.origin.y + self.registerPhoneView.frame.size.height;
        }else if (_selectedSegmentIndex == 1){
            _registerCodeTextFieldText = self.verifyAndemailTextField.text;
            self.verifyAndemailTextField.text = _registerEmailTextFieldText;
            self.verifyAndemailTextField.placeholder = @"请输入您的邮箱";
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
        
        frame = _registerContainerView.frame;
        frame.size.height = self.registerAffirmView.frame.origin.y + self.registerAffirmView.frame.size.height;
        _registerContainerView.frame = frame;
        
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
            if ([[_accountTextField text] isValidateEmail] && ([_passwordTextField text].length >= 6 &&[_passwordTextField text].length <= 15)) {
                _loginButton.enabled = YES;
                return YES;
            }
            _loginButton.enabled = NO;
            return NO;
        }
    }else if (_vcType == VcType_Register){
        if (_selectedSegmentIndex == 0) {
            if ([[_registerPhoneTextField text] isPhone]) {
                if (_waitSmsSecond <= 0) {
                    _registerVerifyButton.enabled = YES;
                    [_registerVerifyButton setBackgroundColor:UIColorToRGB(0x6cc5e9)];
                }
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
            if ([[_verifyAndemailTextField text] isValidateEmail] ) {
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

- (void)TextFieldResignFirstResponder{
    [self.registerPhoneTextField resignFirstResponder];
    [self.verifyAndemailTextField resignFirstResponder];
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

#pragma mark - KeyboardNotification
-(void) keyboardWillShow:(NSNotification *)note{
    
    if (_bViewDisappear) {
        return;
    }
    UIView *supView;
    if (_vcType == VcType_Login) {
        supView = self.loginContainerView;
    }else if (_vcType == VcType_Register){
        supView = self.registerContainerView;
    }
    _oldRect = supView.frame;
    
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect supViewFrame = supView.frame;
    float gapHeight = keyboardBounds.size.height - (self.view.bounds.size.height - supViewFrame.origin.y - supViewFrame.size.height);
    BOOL isMove = (gapHeight > 0);
    
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    if (isMove) {
        supViewFrame.origin.y -= gapHeight;
        supView.frame = supViewFrame;
    }
    
    // commit animations
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    
    if (_bViewDisappear) {
        return;
    }
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    UIView *supView;
    if (_vcType == VcType_Login) {
        supView = self.loginContainerView;
    }else if (_vcType == VcType_Register){
        supView = self.registerContainerView;
    }
    if (_oldRect.size.height != 0 && _oldRect.size.width != 0) {
        supView.frame = _oldRect;
    }
    // commit animations
    [UIView commitAnimations];
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
    
    __weak LoginViewController *weakSelf = self;
    XEActionSheet *sheet = [[XEActionSheet alloc] initWithTitle:nil actionBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 2) {
            return;
        }
        RetrievePwdViewController *rpVc = [[RetrievePwdViewController alloc] init];
        rpVc.reType = (int)buttonIndex;
        [weakSelf.navigationController pushViewController:rpVc animated:YES];
    }];
    [sheet addButtonWithTitle:@"手机号找回"];
    [sheet addButtonWithTitle:@"邮箱找回"];
    [sheet addButtonWithTitle:@"取消"];
    sheet.cancelButtonIndex = sheet.numberOfButtons -1;
    
    
    [sheet showInView:self.view];
}

- (IBAction)socialLoginAction:(id)sender {
    if ([XECommonUtils NetworkConnected])
    {
        _loginType = @"";
        UIButton *button = (UIButton *)sender;
        if (button.tag == 0) {
            _loginType = [[NSString alloc]initWithString:UMShareToQQ];
            if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
                [XEUIUtils showAlertWithMsg:@"您还没有安装QQ？"];
                return;
            }
        }else if (button.tag == 1){
            _loginType = [[NSString alloc]initWithString:UMShareToSina];
        }else if (button.tag == 2){
            _loginType = [[NSString alloc]initWithString:UMShareToWechatSession];
        }
        
        __weak LoginViewController *weakSelf = self;
        int tag = [[XEEngine shareInstance] getConnectTag];
        [[XEEngine shareInstance] loginWithAccredit:_loginType tag:tag error:nil];
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
            
            XELog(@"loginWithAccredit response = %@",dic);
            [weakSelf socialAffirmLogin:dic];
        }tag:tag];
    }else
        [XEProgressHUD AlertErrorNetwork];
}

- (IBAction)protocolAction:(id)sender {
    NSString *url = [[NSString stringWithFormat:@"%@/%@",[XEEngine shareInstance].baseUrl,@"agreement"] description];
    
    XECommonWebVc *webvc = [[XECommonWebVc alloc] initWithAddress:url];
    
//    id vc = [XELinkerHandler handleDealWithHref:url From:self.navigationController];
    if (webvc) {
        [self presentViewController:webvc animated:YES completion:nil];
    }
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
    
    [self sendCode];
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
//    self.registerPhoneTextField.text = nil;
    [self.verifyAndemailTextField resignFirstResponder];
//    self.verifyAndemailTextField.text = nil;
    
    [self.accountTextField resignFirstResponder];
//    self.accountTextField.text = nil;
    [self.passwordTextField resignFirstResponder];
//    self.passwordTextField.text = nil;
    
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
    
    _accountTextField.text = [_accountTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (_accountTextField.text.length == 0) {
        [XEProgressHUD lightAlert:@"请输入手机号"];
        return;
    }
    _loginPasswordTextFieldText = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (_loginPasswordTextFieldText.length == 0) {
        [XEProgressHUD lightAlert:@"请输入密码"];
        return;
    }
    [self TextFieldResignFirstResponder];
    [XEProgressHUD AlertLoading:@"正在登录..." At:self.view];
    __weak LoginViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] loginWithUid:_accountTextField.text password:_loginPasswordTextFieldText tag:tag error:nil];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        [XEProgressHUD AlertSuccess:@"登录成功." At:weakSelf.view];
        
        NSDictionary *object = [jsonRet objectForKey:@"object"];
        XEUserInfo *userInfo = [[XEUserInfo alloc] init];
        [userInfo setUserInfoByJsonDic:object];
        
        [XEEngine shareInstance].uid = userInfo.uid;
        [XEEngine shareInstance].account = _accountTextField.text;
        [XEEngine shareInstance].userPassword = _passwordTextField.text;
        [[XEEngine shareInstance] saveAccount];
        
        [XEEngine shareInstance].userInfo = userInfo;
        
        [weakSelf performSelector:@selector(loginFinished) withObject:nil afterDelay:1.0];
        
    }tag:tag];
    
}
-(void)loginWithEmail{
    
}

-(void)socialAffirmLogin:(NSDictionary *)info{
    
    NSString *plantform = nil;
    if ([_loginType isEqualToString:UMShareToWechatSession]) {
        plantform = @"1";
    }else if ([_loginType isEqualToString:UMShareToQQ]){
        plantform = @"2";
    }else if ([_loginType isEqualToString:UMShareToSina]){
        plantform = @"3";
    }
    [XEProgressHUD AlertLoading:@"正在登录..." At:self.view];
    __weak LoginViewController *weakSelf = self;
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
    [self TextFieldResignFirstResponder];
    [XEProgressHUD AlertLoading:@"正在验证,请稍等" At:self.view];
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
    
    if(_waitTimer){
        [_waitTimer invalidate];
        _waitTimer = nil;
    }
    
    _waitTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(waitTimerInterval:) userInfo:nil repeats:YES];
    _waitSmsSecond = 60;
    _registerVerifyButton.enabled = NO;
    [_registerVerifyButton setBackgroundColor:UIColorToRGB(0x699db2)];
    [self waitTimerInterval:_waitTimer];
    
    [self TextFieldResignFirstResponder];
    [XEProgressHUD AlertLoading:@"正在验证手机号" At:self.view];
    __weak LoginViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getCodeWithPhone:_registerPhoneTextFieldText type:@"0" tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败!";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            _waitSmsSecond = 0;
            [weakSelf waitTimerInterval:_waitTimer];
            return;
        }
        
        [XEProgressHUD AlertSuccess:@"验证码发送成功." At:weakSelf.view];
        
    }tag:tag];
}

-(void)checkPhone{
    
    _registerPhoneTextFieldText = [_registerPhoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (_registerPhoneTextFieldText.length == 0) {
        [XEProgressHUD lightAlert:@"请输入手机号"];
        return;
    }
    [self TextFieldResignFirstResponder];
    [XEProgressHUD AlertLoading:@"正在验证手机号" At:self.view];
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
    [self TextFieldResignFirstResponder];
    [XEProgressHUD AlertLoading:@"正在验证邮箱号" At:self.view];
    __weak LoginViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] checkEmailWithEmail:verifyAndemailTextFieldText uid:nil tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertLoadDone];
            [XEUIUtils showAlertWithMsg:errorMsg];
            return;
        }
        
        [XEProgressHUD AlertSuccess:@"邮箱验证通过." At:weakSelf.view];
        
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
