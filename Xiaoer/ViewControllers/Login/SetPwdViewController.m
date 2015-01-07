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

@interface SetPwdViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *setPwdImageView;
@property (strong, nonatomic) IBOutlet UITextField *setPwdTextField;
@property (strong, nonatomic) IBOutlet UITextField *comfirmTextField;


- (IBAction)confirmAction:(id)sender;

@end

@implementation SetPwdViewController

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
    NSLog(@"================");
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
    
    if ([self.setPwdTextField.text isEqualToString:self.comfirmTextField.text]) {
        int tag = [[XEEngine shareInstance] getConnectTag];
        if (self.registerName.length != 0) {
            [XEProgressHUD AlertLoading:@"正在注册"];
            if ([self.registerName isPhone]) {
                [[XEEngine shareInstance] registerWithPhone:self.registerName password:self.setPwdTextField.text tag:tag];
                [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
                    NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
                    if (!jsonRet || errorMsg) {
                        if (!errorMsg.length) {
                            errorMsg = @"获取失败";
                        }
                        return;
                    }
                    [XEProgressHUD AlertLoading:@"注册成功"];
                }tag:tag];
            }else if([self.registerName isEmail]){
                [[XEEngine shareInstance] registerWithEmail:self.registerName password:self.setPwdTextField.text tag:tag];
                [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
                    NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
                    if (!jsonRet || errorMsg) {
                        if (!errorMsg.length) {
                            errorMsg = @"获取失败";
                        }
                        return;
                    }
                    [XEProgressHUD AlertLoading:@"注册成功"];
                }tag:tag];
            }
        }else{
            [XEProgressHUD AlertLoading:@"正在重置密码"];
            [[XEEngine shareInstance] resetPassword:self.setPwdTextField.text withUid:@"t1" tag:tag];
            [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
                NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
                if (!jsonRet || errorMsg) {
                    if (!errorMsg.length) {
                        errorMsg = @"获取失败";
                    }
                    return;
                }
                [XEProgressHUD AlertLoading:@"重置密码成功"];
            }tag:tag];
        }
    }else{
        [self.comfirmTextField becomeFirstResponder];
        [XEProgressHUD AlertError:@"两次密码不一致"];
    }
}
@end
