//
//  CardOfEastWebViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/5/19.
//
//

#import "CardOfEastWebViewController.h"
#import "CardOfEastVerifyController.h"
#import "UIImageView+WebCache.h"
@interface CardOfEastWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

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
    [self configureCardInfomationView];
    
    [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT*2)];
    

    NSURL *cardUrl = [NSURL URLWithString:self.cardinfo.cardActionUrl];
    [self loadWebViewWithUrl:cardUrl];
    [self configureBottomBtn];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(activityed) name:@"activity" object:nil];

    

}

- (void)configureCardInfomationView{
    self.titleLab.text = self.cardinfo.title;
//    self.describe.text = [self.cardinfo returnCardOfEastDes];
    self.price.text = [NSString stringWithFormat:@"￥%@", self.cardinfo.price];
    
    if (![self.cardinfo.img isEqual:[NSNull null]]) {
        NSLog(@"imageurl = %@",self.cardinfo.originalCardImageUrl );
        [self.cardImage sd_setImageWithURL:self.cardinfo.originalCardImageUrl placeholderImage:[UIImage imageNamed:@"activity_load_icon"]];
    }else{
        [self.cardImage sd_setImageWithURL:nil];
        [self.cardImage setImage:[UIImage imageNamed:@"topic_load_icon"]];
    }
    
}

- (void)activityed{
    self.activityBtn.userInteractionEnabled = NO;
}

- (void)configureBottomBtn{
    if (self.hideCardInfo == YES) {
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
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *kabao = [userDefaults objectForKey:[NSString stringWithFormat:@"kabaoid%@",[XEEngine shareInstance].uid]];
    __block CardOfEastWebViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [XEEngine shareInstance].serverPlatform = OnlinePlatform;
    [[XEEngine shareInstance]getEastCardInfomaitonWithuserid:[XEEngine shareInstance].uid kabaoid:self.cardinfo.cid tag:tag];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//        NSLog(@"jsonRet = %@",jsonRet);
        /**
         *  获取失败信息
         */
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
//        NSLog(@"errorMsg = %@",errorMsg);
        if (errorMsg) {
//            NSLog(@"进入");
        [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }else{
            
            weakSelf.cardNumber.text = [NSString stringWithFormat:@"券号:%@",[[jsonRet objectForKey:@"object"] objectForKey:@"eastcardNo"]];
            weakSelf.password.text = [NSString stringWithFormat:@"密码:%@",[[jsonRet objectForKey:@"object"] objectForKey:@"eastcardKey"]];
            
        }
    } tag:tag];
    
}

- (IBAction)activityBtnTouched:(id)sender {
    CardOfEastVerifyController *verify = [[CardOfEastVerifyController alloc]initWithNibName:@"CardOfEastVerifyController" bundle:nil];
    verify.kabaoid = self.kabaoid;
    verify.cardinfo = self.cardinfo;
    [self.navigationController pushViewController:verify animated:YES];
}

- (void)loadWebViewWithUrl:(NSURL *)url {
    
    self.request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:_request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma web delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad: ");
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
  //  [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,265 + frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,310 + frame.size.height)];

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
