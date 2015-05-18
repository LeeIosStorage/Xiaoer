//
//  CardOfEastWebViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/5/18.
//
//

#import "CardOfEastWebViewController.h"

@interface CardOfEastWebViewController ()<UIWebViewDelegate>
/**
 *  显示的网页
 */
@property (nonatomic,strong)UIWebView *webView;
/**
 *  网页数据请求
 */
@property (nonatomic, retain) NSURLRequest *request;

@property (weak, nonatomic) IBOutlet UIWebView *we;

@end

@implementation CardOfEastWebViewController


- (UIWebView *)webView {
    if (!_webView) {
        self.webView = [[UIWebView alloc] initWithFrame:(CGRect){0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 80- 64}];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_webView];
        
    }
    return _webView;
}

- (UIButton *)activateButton{
    if (!_activateButton) {
        self.activateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_activateButton setTitle:@"激活卡券" forState:UIControlStateNormal];
        [_activateButton setBackgroundImage:[UIImage imageNamed:@"激活"] forState:UIControlStateNormal];
        [_activateButton setBackgroundImage:[UIImage imageNamed:@"激活"] forState:UIControlStateHighlighted];
        [_activateButton addTarget:self action:@selector(activityCard) forControlEvents:UIControlEventTouchUpInside];
        _activateButton.frame = CGRectMake(0, self.view.bounds.size.height - 80, self.view.bounds.size.width, 80);
    }
    return _activateButton;
        
}

- (void)loadView{
    [super loadView];
    
    self.view.bounds = [UIScreen mainScreen].bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"卡券详情";
    NSLog(@"self.we%@" ,self.we);
    self.webView.delegate = self;
    [self.view addSubview:self.activateButton];
    [self loadWebViewWithUrlString:@"http://xiaor123.cn:801/api/info/detail?id=416"];
}

- (void)activityCard{
    
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
