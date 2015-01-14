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

@property (strong, nonatomic) IBOutlet UIImageView *setPwdImageView;
@property (strong, nonatomic) IBOutlet UITextField *setPwdTextField;
@property (strong, nonatomic) IBOutlet UITextField *comfirmTextField;
@property (strong, nonatomic) IBOutlet UIButton *comfimAction;


- (IBAction)confirmAction:(id)sender;

@end

@implementation SetPwdViewController

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    //title
    [self setTitle:@"设置密码"];
    [self.setPwdImageView setImage:[UIImage imageNamed:@"set_pwd_icon"]];
    
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
    
    __weak SetPwdViewController *weakSelf = self;
    if ([self.setPwdTextField.text isEqualToString:self.comfirmTextField.text]) {
        [XEProgressHUD lightAlert:@"正在注册"];
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
                    [weakSelf perfectInformation];
                }tag:tag];
            }else if([weakSelf.registerName isEmail]){
                [[XEEngine shareInstance] registerWithEmail:weakSelf.registerName password:self.setPwdTextField.text tag:tag];
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
    PerfectInfoViewController *pVc = [[PerfectInfoViewController alloc] init];
    XEUserInfo *userInfo = [[XEUserInfo alloc] init];
    userInfo.uid = @"1";
    pVc.userInfo = userInfo;
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

@end
