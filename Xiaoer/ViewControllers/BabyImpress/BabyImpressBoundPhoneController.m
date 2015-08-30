//
//  BabyImpressBoundPhoneController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/8/14.
//
//

#import "BabyImpressBoundPhoneController.h"
#import "XEProgressHUD.h"
#import "XEEngine.h"
#import "NSString+Value.h"
@interface BabyImpressBoundPhoneController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *getSecretBtn;
@property (weak, nonatomic) IBOutlet UITextField *secreatTextField;
- (IBAction)vetifyBtnTouched:(id)sender;
- (IBAction)getSecreatBtnTouched:(id)sender;
@property (nonatomic,strong)NSTimer *timer;

@end

@implementation BabyImpressBoundPhoneController
- (NSTimer *)timer{
    if (!_timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(begainCountDown) userInfo:nil repeats:YES];
    }
    return _timer;
}
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(begainCountDownNofomation:) name:@"notificationBegainCountDown" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endCountDowNnotification:) name:@"notificationEndCountDown" object:nil];

}


- (void)begainCountDown{
    NSString *str = self.getSecretBtn.titleLabel.text;
    CGFloat index = [str floatValue];
    index -=1;
    if (index <= 0) {
        self.getSecretBtn.backgroundColor = SKIN_COLOR;
        [self.getSecretBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationEndCountDown" object:[NSString stringWithFormat:@"%.0fs",index]];

    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationBegainCountDown" object:[NSString stringWithFormat:@"%.0fs",index]];
    }
    
}



- (IBAction)vetifyBtnTouched:(id)sender {

    if (![self.phoneTextField.text isPhone]) {
        [XEProgressHUD lightAlert:@"请输入正确的手机号"];
        return;
    }
    if (self.secreatTextField.text.length == 0) {
        [XEProgressHUD lightAlert:@"请输入验证码"];
        return;
    }
    __weak BabyImpressBoundPhoneController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance]checkCodeWithPhone:self.phoneTextField.text code:self.secreatTextField.text codeType:@"2" tag:tag];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        //        获取失败信息
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            [self nomalStata];
            return ;
        }
 
        [self finalBoundPhone];
    
    } tag:tag];
    
}

- (void)finalBoundPhone{
    /**
     *  绑定手机号
     */
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance]loveBoundPhoneWith:tag userid:[XEEngine shareInstance].uid phone:self.phoneTextField.text];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        
        [self nomalStata];
        NSString *code = [jsonRet[@"code"] stringValue];
        if ([code isEqualToString:@"0"]) {
            [XEProgressHUD AlertSuccess:@"绑定成功"];
            [[XEEngine shareInstance]refreshUserInfo];
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }else if ([code isEqualToString:@"2"]){
            [XEProgressHUD AlertError:@"用户不存在"];
            return ;
            
        }else if ([code isEqualToString:@"3"]){
            [XEProgressHUD AlertError:@"您输入的手机号不正确哦，请检查后重试"];
            return ;
            
        }else if ([code isEqualToString:@"4"]){
            [XEProgressHUD AlertError:@"该号码已经被绑定过了"];
            return ;
            
        }else if ([code isEqualToString:@"5"]){
            [XEProgressHUD AlertError:@"您的帐号已绑定了手机，不能再次绑定"];
            return ;
            
        }else{
            [XEProgressHUD AlertError:@"绑定失败"];
            return;
        }
        
    } tag:tag];
}
- (void)nomalStata{
    self.getSecretBtn.backgroundColor = SKIN_COLOR;
    [self.getSecretBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.timer invalidate];
    self.timer = nil;
}

- (IBAction)getSecreatBtnTouched:(id)sender {
    NSLog(@"123");
    if (![self.phoneTextField.text isPhone]) {
        [XEProgressHUD lightAlert:@"请输入正确的手机号"];
        return;
    }
    
    if ([self.getSecretBtn.backgroundColor isEqual:SKIN_COLOR]) {
        self.getSecretBtn.backgroundColor = [UIColor lightGrayColor];
        [self.getSecretBtn setTitle:@"60s" forState:UIControlStateNormal];
        self.getSecretBtn.titleLabel.text = @"60s";
        [self.timer fire];
        /**
         *  获取验证码
         */
        NSLog(@"123");
//     [self nomalStata];
        [self getSerect];
    }else{
        //倒计时的时候  不能更改
        
    }
}
- (void)getSerect{
    __weak BabyImpressBoundPhoneController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance]getCodeWithPhone:self.phoneTextField.text type:@"2" tag:tag];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//     获取失败信息
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            [self nomalStata];
            return ;
        }

    } tag:tag];
}
- (void)begainCountDownNofomation:(NSNotification *)sender{
    self.getSecretBtn.backgroundColor = [UIColor lightGrayColor];
    [self.getSecretBtn setTitle:[NSString stringWithFormat:@"%@",sender.object] forState:UIControlStateNormal];
    self.getSecretBtn.titleLabel.text = [NSString stringWithFormat:@"%@",sender.object];
}

- (void)endCountDowNnotification:(NSNotification *)sender{
    [self nomalStata];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    NSLog(@"delloc");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationBegainCountDown" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationEndCountDown" object:nil];

}
@end
