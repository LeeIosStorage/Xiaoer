//
//  XEWebViewWithEvaluationVc.m
//  Xiaoer
//
//  Created by KID on 15/3/6.
//
//

#import "XEWebViewWithEvaluationVc.h"
#import "JSONKit.h"
#import "XELinkerHandler.h"

@interface XEWebViewWithEvaluationVc ()<UIWebViewDelegate>

@end

@implementation XEWebViewWithEvaluationVc

-(id)initWithAddress:(NSString *)urlString {
    if (self = [super initWithAddress:urlString]) {
        self.availableActions = WebViewControllerAvailableActionsOpenInSafari | WebViewControllerAvailableActionsOpenInChrome | WebViewControllerAvailableActionsCopyLink | WebViewControllerAvailableActionsMailLink;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setRightButtonWithTitle:@"结束" selector:@selector(actionButtonClicked:)];
    [self setTilteLeftViewHide:YES];
    self.disablePan = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.mainWebView.delegate = self;
    self.navigationItem.rightBarButtonItem = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)backAction:(id)sender{
    if (self.mainWebView.canGoBack) {
        [self.mainWebView goBack];
//        [self setLeft2ButtonWithImageName:@"expert_question_icon" selector:@selector(closeButtonClicked:)];
    }else{
//        if (self.navigationController) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }else{
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }
    }
}

-(void)closeButtonClicked:(id)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)actionButtonClicked:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

+(NSString *)decodeUrlString:(NSString *)src{
    return [[src stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = request.URL;
    NSLog(@"shouldStartLoadWithRequest: %@", url);
    if ([url.scheme caseInsensitiveCompare:@"xiaoer"] == NSOrderedSame) {
        if ([url.host isEqualToString:@"purchase"]){
//            NSString *durl = [XEWebViewWithEvaluationVc decodeUrlString:[url absoluteString]];
//            NSString *info = [durl substringFromIndex:[durl rangeOfString:@"="].location+1];
//            NSDictionary *infoDic = [info objectFromJSONString];
            
            NSDictionary *paramDic = [XECommonUtils getParamDictFrom:url.query];
            NSLog(@"infoDic: %@", paramDic);
            if (paramDic) {
                
            }
            return NO;
        }
        else if ([url.host isEqualToString:@"member"]) {
            return NO;
        }
    }
    
    return [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}


-(void)openVideoPage:(NSString *)videoUrl{
    [XELinkerHandler handleDealWithHref:videoUrl From:self.navigationController];
}

@end
