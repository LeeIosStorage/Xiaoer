//
//  BabyImpressBoundPhoneController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/8/14.
//
//

#import "BabyImpressBoundPhoneController.h"

@interface BabyImpressBoundPhoneController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *getSecretBtn;
@property (weak, nonatomic) IBOutlet UITextField *secreatTextField;
- (IBAction)vetifyBtnTouched:(id)sender;
- (IBAction)getSecreatBtnTouched:(id)sender;

@end

@implementation BabyImpressBoundPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机";
    
    self.phoneTextField.placeholder = @"请输入手机号";
    self.secreatTextField.placeholder = @"请输入短信验证码";
    self.getSecretBtn.layer.cornerRadius = 5;
    self.getSecretBtn.layer.masksToBounds = YES;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.secreatTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.getSecretBtn.backgroundColor = SKIN_COLOR;

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

- (IBAction)vetifyBtnTouched:(id)sender {

}

- (IBAction)getSecreatBtnTouched:(id)sender {
    if ([self.getSecretBtn.backgroundColor isEqual:SKIN_COLOR]) {
        self.getSecretBtn.backgroundColor = [UIColor lightGrayColor];
        [self.getSecretBtn setTitle:@"123" forState:UIControlStateNormal];
    }else{
        self.getSecretBtn.backgroundColor = SKIN_COLOR;
        [self.getSecretBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        
    }
}
@end
