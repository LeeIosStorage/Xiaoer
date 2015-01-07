//
//  SetPwdViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/7.
//
//

#import "SetPwdViewController.h"
#import "XEProgressHUD.h"

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
        
    }else{
        [XEProgressHUD AlertError:@"两次密码不一致"];
    }
}
@end
