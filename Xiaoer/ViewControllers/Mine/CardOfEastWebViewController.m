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
        [self.activityBtn setTitle:@"" forState:UIControlStateNormal];
        self.activityBtn.userInteractionEnabled = NO;
    }
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
