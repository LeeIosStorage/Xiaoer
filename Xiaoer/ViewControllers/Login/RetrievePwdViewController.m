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

@interface RetrievePwdViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *retrieveImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *noticeLabel;
@property (strong, nonatomic) IBOutlet UIView *phoneNumView;
@property (strong, nonatomic) IBOutlet UIButton *verifyButton;
@property (strong, nonatomic) IBOutlet UIButton *commitButton;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *commitTextField;

- (IBAction)getCodeAction:(id)sender;
- (IBAction)sendAction:(id)sender;

@end

@implementation RetrievePwdViewController

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
    
    if (self.reType == TYPE_PHONE) {
        [self setTitle:@"手机找回密码"];
        [self.retrieveImageView setImage:[UIImage imageNamed:@"verify_phone_icon"]];
    }else{
        [self setTitle:@"邮箱找回密码"];
        [self.retrieveImageView setImage:[UIImage imageNamed:@"verify_eamil_icon"]];
        self.titleLabel.text = @"请输入您的邮箱账号";
        self.noticeLabel.text = @"您的密码重置链接将发送到您的邮箱\n如果没有收到，请检查垃圾邮件";
        CGRect frame = self.noticeLabel.frame;
        CGSize size = CGSizeMake(180, MAXFLOAT);
        CGSize titleSize = [self.noticeLabel.text sizeWithFont:self.noticeLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
        frame.size.height = titleSize.height;
        self.noticeLabel.frame = frame;

        self.commitTextField.placeholder = @"";
        [self.commitButton setTitle:@"找回密码" forState:UIControlStateNormal];
        self.phoneNumView.hidden = YES;
    }
}

- (IBAction)getCodeAction:(id)sender {
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getCodeWithPhone:@"13888888888" tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"获取失败";
            }
            return;
        }
        NSLog(@"=====%@",[jsonRet objectForKey:@"obj"]);
    }tag:tag];
}

- (IBAction)sendAction:(id)sender {
    //test
    int tag = [[XEEngine shareInstance] getConnectTag];
//    [[XEEngine shareInstance] loginWithUid:@"t1" password:@"123456" tag:tag error:nil];
    [[XEEngine shareInstance] checkCodeWithPhone:@"13888888888" code:@"835576" codeType:@"1" tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"获取失败";
            }
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



@end
