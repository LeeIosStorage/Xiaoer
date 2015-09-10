//
//  XEAPPAgreeDeclarationController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/9/8.
//
//

#import "XEAPPAgreeDeclarationController.h"

@interface XEAPPAgreeDeclarationController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation XEAPPAgreeDeclarationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"《晓儿挂号用户协议》";
    self.webView.delegate = self;
    NSString *url = [NSString stringWithFormat:@"%@/agreement",[[XEEngine shareInstance] baseUrl]];

    [self loadWebViewWithUrl:[NSURL URLWithString:url]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadWebViewWithUrl:(NSURL *)url {
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    [XEProgressHUD AlertLoading:@"正在加载"];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [XEProgressHUD AlertSuccess:@"加载成功"];
}



@end
