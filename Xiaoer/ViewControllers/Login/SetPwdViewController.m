//
//  SetPwdViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/7.
//
//

#import "SetPwdViewController.h"
#import "XEProgressHUD.h"
#import "XEEngine.h"
#import "NSString+Value.h"
#import "PerfectInfoViewController.h"

@interface SetPwdViewController ()
{
    CGRect _oldRect;
}
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIImageView *setPwdImageView;
@property (strong, nonatomic) IBOutlet UITextField *setPwdTextField;
@property (strong, nonatomic) IBOutlet UITextField *comfirmTextField;
@property (strong, nonatomic) IBOutlet UIButton *comfimAction;

@property (nonatomic, assign) BOOL bViewDisappear;

- (IBAction)confirmAction:(id)sender;

@end

@implementation SetPwdViewController

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
//    _bViewDisappear = YES;
    [self TextFieldResignFirstResponder];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    //title
    [self setTitle:@"设置密码"];
    [self.setPwdImageView setImage:[UIImage imageNamed:@"set_pwd_icon"]];
    [self loginButtonEnabled];
}

- (void)TextFieldResignFirstResponder{
    [self.setPwdTextField resignFirstResponder];
    [self.comfirmTextField resignFirstResponder];
}

- (IBAction)confirmAction:(id)sender {
    
    if  (self.setPwdTextField.text.length == 0)
    {
        [self.setPwdTextField becomeFirstResponder];
        [XEProgressHUD AlertError:@"请输入密码"];
        return;
    }
    
    if  (self.comfirmTextField.text.length == 0)
    {
        [self.comfirmTextField becomeFirstResponder];
        [XEProgressHUD AlertError:@"请验证密码"];
        return;
    }
    
    if  (self.setPwdTextField.text.length <= 5)
    {
        [self.setPwdTextField becomeFirstResponder];
        [XEProgressHUD AlertError:@"密码需要6位以上"];
        return;
    }
    [self TextFieldResignFirstResponder];
    __weak SetPwdViewController *weakSelf = self;
    if ([self.setPwdTextField.text isEqualToString:self.comfirmTextField.text]) {
        [XEProgressHUD AlertLoading:@"正在注册"];
        int tag = [[XEEngine shareInstance] getConnectTag];
        if (weakSelf.registerName.length != 0) {
            if ([weakSelf.registerName isPhone]) {
                [[XEEngine shareInstance] registerWithPhone:weakSelf.registerName password:weakSelf.setPwdTextField.text tag:tag];
                [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
                    [XEProgressHUD AlertLoadDone];
                    NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
                    if (!jsonRet || errorMsg) {
                        if (!errorMsg.length) {
                            errorMsg = @"获取失败";
                            [XEProgressHUD AlertError:errorMsg];
                        }
                        [XEUIUtils showAlertWithMsg:errorMsg];
                        return;
                    }
                    [XEProgressHUD AlertSuccess:@"注册成功"];
                    NSDictionary *dic = [jsonRet objectForKey:@"object"];
                    if (!_userInfo) {
                        _userInfo = [[XEUserInfo alloc] init];
                    }
                    [_userInfo setUserInfoByJsonDic:dic];
                    [weakSelf perfectInformation];
                }tag:tag];
            }else if([weakSelf.registerName isEmail]){
                [[XEEngine shareInstance] registerWithEmail:weakSelf.registerName password:weakSelf.setPwdTextField.text tag:tag];
                [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
                    [XEProgressHUD AlertLoadDone];
                    NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
                    if (!jsonRet || errorMsg) {
                        if (!errorMsg.length) {
                            errorMsg = @"获取失败";
                            [XEProgressHUD AlertError:errorMsg];
                        }
                        [XEUIUtils showAlertWithMsg:errorMsg];
                        return;
                    }
                    [XEProgressHUD AlertSuccess:@"注册成功"];
                    NSDictionary *dic = [jsonRet objectForKey:@"object"];
                    if (!_userInfo) {
                        _userInfo = [[XEUserInfo alloc] init];
                    }
                    [_userInfo setUserInfoByJsonDic:dic];
                    [weakSelf perfectInformation];
                }tag:tag];
            }
        }else{
            [XEProgressHUD lightAlert:@"正在重置密码"];
            [[XEEngine shareInstance] resetPassword:self.setPwdTextField.text withUid:@"t1" tag:tag];
            [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
                [XEProgressHUD AlertLoadDone];
                NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
                if (!jsonRet || errorMsg) {
                    if (!errorMsg.length) {
                        errorMsg = @"获取失败";
                        [XEProgressHUD AlertError:errorMsg];
                    }
                    [XEUIUtils showAlertWithMsg:errorMsg];
                    return;
                }
                [XEProgressHUD AlertSuccess:@"重置密码成功"];
            }tag:tag];
        }
    }else{
        [self.comfirmTextField becomeFirstResponder];
        [XEProgressHUD AlertError:@"两次密码不一致"];
    }
}

-(void)perfectInformation{
    [XEEngine shareInstance].uid = _userInfo.uid;
    [XEEngine shareInstance].account = self.registerName;
    [XEEngine shareInstance].userPassword = self.setPwdTextField.text;
    [[XEEngine shareInstance] saveAccount];
    
    PerfectInfoViewController *pVc = [[PerfectInfoViewController alloc] init];
    pVc.userInfo = _userInfo;
    pVc.isNeedSkip = YES;
    [self.navigationController pushViewController:pVc animated:YES];
}


- (BOOL)loginButtonEnabled{
    if ([[_setPwdTextField text] length] >= 6 && [_comfirmTextField text].length >= 6) {
        _comfimAction.enabled = YES;
        return YES;
    }
    _comfimAction.enabled = NO;
    return NO;
}

- (void)checkTextChaneg:(NSNotification *)notif
{
    //    UITextField *textField = notif.object;
    [self loginButtonEnabled];
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
    
    if (textField == _setPwdTextField) {
        if (newString.length > 15 && textField.text.length >= 15) {
            return NO;
        }
    }else if (textField == _comfirmTextField){
        if (newString.length > 15 && textField.text.length >= 15) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - KeyboardNotification
-(void) keyboardWillShow:(NSNotification *)note{
    
    if (_bViewDisappear) {
        return;
    }
    UIView *supView = self.containerView;
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
    if (_oldRect.size.height != 0 && _oldRect.size.width != 0) {
        UIView *supView = self.containerView;
        supView.frame = _oldRect;
    }
    // commit animations
    [UIView commitAnimations];
}

@end
