//
//  RetrievePwdViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/6.
//
//

#import "RetrievePwdViewController.h"
#import "XEEngine.h"
#import "XEUserInfo.h"
#import "SetPwdViewController.h"
#import "NSString+Value.h"
#import "XEProgressHUD.h"

@interface RetrievePwdViewController ()
{
    CGRect _oldRect;
    int _waitSmsSecond;
    NSTimer *_waitTimer;
}
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIImageView *retrieveImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *noticeLabel;
@property (strong, nonatomic) IBOutlet UIView *phoneNumView;
@property (strong, nonatomic) IBOutlet UIButton *verifyButton;
@property (strong, nonatomic) IBOutlet UIButton *commitButton;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *commitTextField;

@property (nonatomic, assign) BOOL bViewDisappear;

- (IBAction)getCodeAction:(id)sender;
- (IBAction)sendAction:(id)sender;

@end

@implementation RetrievePwdViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkTextChaneg:) name:UITextFieldTextDidChangeNotification object:nil];
    
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    //title
    
    if (self.reType == TYPE_PHONE) {
        [self setTitle:@"手机找回密码"];
        [self.retrieveImageView setImage:[UIImage imageNamed:@"verify_phone_icon"]];
    }else{
        [self setTitle:@"邮箱找回密码"];
        [self.retrieveImageView setImage:[UIImage imageNamed:@"verify_eamil_icon"]];
        self.titleLabel.text = @"请输入您的邮箱账号";
        self.noticeLabel.text = @"您的密码重置链接将发送到您的邮箱\n如果没有收到，请检查垃圾邮件";
        CGRect frame = self.noticeLabel.frame;
//        CGSize size = CGSizeMake(180, MAXFLOAT);
//        CGSize titleSize = [self.noticeLabel.text sizeWithFont:self.noticeLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
        CGSize titleSize = [XECommonUtils sizeWithText:self.noticeLabel.text font:self.noticeLabel.font width:self.noticeLabel.frame.size.width];
        frame.size.height = titleSize.height;
        self.noticeLabel.frame = frame;

        self.commitTextField.placeholder = @"";
        [self.commitButton setTitle:@"找回密码" forState:UIControlStateNormal];
        self.phoneNumView.hidden = YES;
    }
    [self loginButtonEnabled];
}

- (void)TextFieldResignFirstResponder{
    [self.phoneTextField resignFirstResponder];
    [self.commitTextField resignFirstResponder];
}

- (void)waitTimerInterval:(NSTimer *)aTimer{
    XELog(@"a Timer waitTimerInterval = %d",_waitSmsSecond);
    if (_waitSmsSecond <= 0) {
        [aTimer invalidate];
        _waitTimer = nil;
        if ([[_phoneTextField text] isPhone]) {
            _verifyButton.enabled = YES;
            [_verifyButton setBackgroundColor:UIColorToRGB(0x6cc5e9)];
        }
        [_verifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        return;
    }
    
    [_verifyButton setTitle:[NSString stringWithFormat:@"%d秒",_waitSmsSecond] forState:UIControlStateNormal];
    
    _waitSmsSecond--;
    
}

- (IBAction)getCodeAction:(id)sender {
    
    if(_waitTimer){
        [_waitTimer invalidate];
        _waitTimer = nil;
    }
    
    _waitTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(waitTimerInterval:) userInfo:nil repeats:YES];
    _waitSmsSecond = 60;
    _verifyButton.enabled = NO;
    [_verifyButton setBackgroundColor:UIColorToRGB(0x699db2)];
    [self waitTimerInterval:_waitTimer];
    __weak RetrievePwdViewController *weakSelf = self;
    [XEProgressHUD AlertLoading:@"正在验证手机号" At:self.view];
    [self TextFieldResignFirstResponder];
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getCodeWithPhone:self.phoneTextField.text type:@"1" tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"获取失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            _waitSmsSecond = 0;
            [self waitTimerInterval:_waitTimer];
            return;
        }
        //NSLog(@"=====%@",[jsonRet objectForKey:@"obj"]);
    }tag:tag];
}

- (IBAction)sendAction:(id)sender {
    //test
    [self TextFieldResignFirstResponder];
    __weak RetrievePwdViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
//    [[XEEngine shareInstance] loginWithUid:@"t1" password:@"123456" tag:tag error:nil];
    [[XEEngine shareInstance] checkCodeWithPhone:self.phoneTextField.text code:self.commitTextField.text codeType:@"1" tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"获取失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        
//        if ([jsonRet objectForKey:@"object"]) {
//            NSDictionary *dic = [jsonRet objectForKey:@"object"];
//            XEUserInfo *userInfo = [[XEUserInfo alloc] init];
//            [userInfo setUserInfoByJsonDic:dic];
//            NSLog(@"================");
//        }
        
        SetPwdViewController *spVc = [[SetPwdViewController alloc] init];
        [self.navigationController pushViewController:spVc animated:YES];
        
    }tag:tag];
}


- (BOOL)loginButtonEnabled{
    
    if (self.reType == TYPE_PHONE) {
        if ([[_phoneTextField text] isPhone]) {
            _verifyButton.enabled = YES;
            [_verifyButton setBackgroundColor:UIColorToRGB(0x6cc5e9)];
            if (_commitTextField.text.length > 0) {
                _commitButton.enabled = YES;
                return YES;
            }
            _commitButton.enabled = NO;
            return YES;
        }
        _verifyButton.enabled = NO;
        _commitButton.enabled = NO;
        [_verifyButton setBackgroundColor:UIColorToRGB(0x699db2)];
        return NO;
        
    }else if (self.reType == TYPE_EMAIL){
        if ([[_commitTextField text] isEmail] ) {
            _commitButton.enabled = YES;
            return YES;
        }
        _commitButton.enabled = NO;
        return NO;
    }
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
    
    if (self.reType == TYPE_PHONE) {
        if (textField == _phoneTextField && textField.markedTextRange == nil) {
            if (newString.length > 11 && textField.text.length >= 11) {
                return NO;
            }
        }
        return YES;
    }else if (self.reType == TYPE_EMAIL){
        
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
