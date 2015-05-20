//
//  CardOfEastWebViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/5/19.
//
//

#import "CardOfEastWebViewController.h"
#import "CardOfEastVerifyController.h"
@interface CardOfEastWebViewController ()
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/**
 *  网页数据请求
 */
@property (nonatomic, retain) NSURLRequest *request;

@end

@implementation CardOfEastWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"卡券详情";
    [self loadWebViewWithUrlString:@"http://xiaor123.cn:801/api/info/detail?id=416"];

    [self configureBottomBtn];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(activityed) name:@"activity" object:nil];

    

}
- (void)activityed{
    NSLog(@"接受通知");
    self.activityBtn.userInteractionEnabled = NO;
}
- (void)configureBottomBtn{
    if (self.hideCardInfo) {
        self.cardNumber.hidden = YES;
        self.password.hidden = YES;
        [self.activityBtn setTitle:@"激活卡券" forState:UIControlStateNormal];
        self.activityBtn.userInteractionEnabled = YES;
    }else{
        self.cardNumber.hidden = NO;
        self.password.hidden = NO;
        [self getCardInfomation];
        [self.activityBtn setTitle:@"" forState:UIControlStateNormal];
        self.activityBtn.userInteractionEnabled = NO;
    }
}
/**
 *  获取东方有线卡信息
 */
- (void)getCardInfomation{
    __block UIViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [XEEngine shareInstance].serverPlatform = TestPlatform;
    [[XEEngine shareInstance]getEastCardInfomaitonWithuserid:[XEEngine shareInstance].uid kabaoid:@"9" tag:tag];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSLog(@"jsonRet = %@",[[jsonRet objectForKey:@"objext"] objectForKey:@"eastcardNo"]);
        /**
         *  获取失败信息
         */
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"激活失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }else{
            self.cardNumber.text = [NSString stringWithFormat:@"券号:%@",[[jsonRet objectForKey:@"object"] objectForKey:@"eastcardNo"]];
            self.password.text = [NSString stringWithFormat:@"密码:%@",[[jsonRet objectForKey:@"object"] objectForKey:@"eastcardKey"]];
            
        }
    } tag:tag];
    

}

- (IBAction)activityBtnTouched:(id)sender {
    CardOfEastVerifyController *verify = [[CardOfEastVerifyController alloc]init];
    [self.navigationController pushViewController:verify animated:YES];
}

- (void)loadWebViewWithUrlString:(NSString *)urlString {
    
    NSURL *url =[NSURL URLWithString:urlString];
    self.request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:_request];
    
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

@end
