//
//  CardDetailViewController.m
//  Xiaoer
//
//  Created by KID on 15/2/3.
//
//

#import "CardDetailViewController.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XEAlertView.h"
#import "UIImageView+WebCache.h"
#import "PerfectInfoViewController.h"

@interface CardDetailViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *cardImageView;
@property (strong, nonatomic) IBOutlet UILabel *cardTitle;
@property (strong, nonatomic) IBOutlet UILabel *cardDes;
@property (strong, nonatomic) IBOutlet UILabel *cardPrice;
@property (strong, nonatomic) IBOutlet UILabel *leftNum;
@property (strong, nonatomic) IBOutlet UIWebView *cardWebView;
@property (strong, nonatomic) IBOutlet UIButton *statusBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *containerView;

- (IBAction)receiveAction:(id)sender;

@end

@implementation CardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self refreshDetailUI];
    [self refreshCardInfo];
    NSURL *cardUrl = [NSURL URLWithString:_cardInfo.cardActionUrl];
    [_cardWebView loadRequest:[NSURLRequest requestWithURL:cardUrl]];
    [(UIScrollView *)[[_cardWebView subviews] objectAtIndex:0] setBounces:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    [self setTitle:@"卡包详情"];
}

- (void)refreshCardInfo{
    __weak CardDetailViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getCardDetailInfoWithUid:[XEEngine shareInstance].uid cid:self.cardInfo.cid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        
        [self.pullRefreshView finishedLoading];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        
        NSDictionary *dic = [jsonRet objectForKey:@"object"];
        [weakSelf.cardInfo setCardInfoByJsonDic:dic];
        [weakSelf refreshDetailUI];
    }tag:tag];
}

- (void)refreshDetailUI{
    _cardPrice.text = [NSString stringWithFormat:@"￥%@",_cardInfo.price];
    if (_cardInfo.status == 1) {
        [_statusBtn setTitle:@"免费领取" forState:UIControlStateNormal];
    }else if (_cardInfo.status == 2) {
        [_statusBtn setTitle:@"领用完" forState:UIControlStateNormal];
        _statusBtn.enabled = NO;
        [_statusBtn setBackgroundImage:[UIImage imageNamed:@"card_staus_hover_bg"] forState:UIControlStateNormal];
    }else if (_cardInfo.status == 3) {
        [_statusBtn setTitle:@"已过期" forState:UIControlStateNormal];
        _statusBtn.enabled = NO;
        [_statusBtn setBackgroundImage:[UIImage imageNamed:@"card_staus_hover_bg"] forState:UIControlStateNormal];
    }else if (_cardInfo.status == 4) {
        [_statusBtn setTitle:@"已领取" forState:UIControlStateNormal];
        _statusBtn.enabled = NO;
        [_statusBtn setBackgroundImage:[UIImage imageNamed:@"card_staus_hover_bg"] forState:UIControlStateNormal];
    }
    if (![_cardInfo.img isEqual:[NSNull null]]) {
        [_cardImageView sd_setImageWithURL:[NSURL URLWithString:_cardInfo.img] placeholderImage:[UIImage imageNamed:@"activity_load_icon"]];
    }else{
        [_cardImageView sd_setImageWithURL:nil];
        [_cardImageView setImage:[UIImage imageNamed:@"topic_load_icon"]];
    }
    _cardTitle.text = _cardInfo.title;
    _cardDes.text = _cardInfo.des;
    _leftNum.text = [NSString stringWithFormat:@"%d",_cardInfo.leftNum];
}

- (void)receiveCardWithInfo:(XECardInfo *)cardInfo{
    __weak CardDetailViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] receiveCardWithUid:[XEEngine shareInstance].uid cid:cardInfo.cid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        
        [self.pullRefreshView finishedLoading];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        [weakSelf.statusBtn setTitle:@"已领取" forState:UIControlStateNormal];
        weakSelf.statusBtn.enabled = NO;
        [weakSelf.statusBtn setBackgroundImage:[UIImage imageNamed:@"card_staus_hover_bg"] forState:UIControlStateNormal];
        weakSelf.leftNum.text = [NSString stringWithFormat:@"%d",[jsonRet intValueForKey:@"object"]];
    }tag:tag];
}

- (IBAction)receiveAction:(id)sender {
    if ([XEEngine shareInstance].userInfo.profileStatus == 0) {
        [self receiveCardWithInfo:self.cardInfo];
    }else{
        XEAlertView *alertView = [[XEAlertView alloc] initWithTitle:nil message:@"您需要完善资料才能领取" cancelButtonTitle:@"取消" cancelBlock:^{
        } okButtonTitle:@"确定" okBlock:^{
            PerfectInfoViewController *piVc = [[PerfectInfoViewController alloc] init];
            piVc.userInfo = [XEEngine shareInstance].userInfo;
            piVc.isFromCard = YES;
            [self.navigationController pushViewController:piVc animated:YES];
        }];
        [alertView show];
    }
}

#pragma webview
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"webViewDidStartLoad");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad: ");
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
//    NSLog(@"==========%f",frame.size.height);
    [_containerView setContentSize:CGSizeMake(SCREEN_WIDTH,265 + frame.size.height)];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)dealloc
{
    [self.cardWebView stopLoading];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.cardWebView.delegate = nil;
}

@end
