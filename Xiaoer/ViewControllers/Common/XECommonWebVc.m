//
//  XECommonWebVc.m
//  Xiaoer
//
//  Created by KID on 15/1/19.
//
//

#import "XECommonWebVc.h"
#import "XEShareActionSheet.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XEAlertView.h"
#import "StageSelectViewController.h"
#import "ExpertListViewController.h"

NSInteger const SGProgresstagId = 222122323;
CGFloat const SGProgressBarHeight = 2.5;

@interface XECommonWebVc ()<UIGestureRecognizerDelegate,XEShareActionSheetDelegate>
{
    XEShareActionSheet *_shareAction;
}

@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, assign) BOOL  canceled;//进度条取消
@property (nonatomic, assign) int  progressOn;



@end

@implementation XECommonWebVc

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect frame = [UIScreen mainScreen].bounds;
//    if (!self.isPortrait) {
//        float temp = frame.size.height;
//        frame.size.height = frame.size.width;
//        frame.size.width = temp;
//    }
    if (self.isFullScreen) {
        [self.titleNavBar setHidden:YES];
        self.mainWebView.frame = frame;
    }else{
        frame.origin.y = [self titleNavBar].frame.size.height;
        frame.size.height -= frame.origin.y;
        self.mainWebView.frame = frame;
        
        frame = self.titleNavBar.frame;
        frame.size.width = SCREEN_WIDTH;
        self.titleNavBar.frame = frame;
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    //        [self.navigationController setToolbarHidden:YES animated:animated];
    //    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //判断设备当前的方向，然后重新布局不同方向的操作。
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainWebView = [[UIWebView alloc] init];
    self.mainWebView.delegate = self;
    self.mainWebView.scalesPageToFit = YES;
    self.mainWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self loadURL:self.URL];
    [self.view insertSubview:self.mainWebView atIndex:0];
    if (self.isShareViewOut) {
        [self setRightButtonWithImageName:@"more_icon" selector:@selector(actionButtonClicked:)];
    }
    if (self.isCanClosed) {
        self.disablePan = YES;
        [self setTilteLeftViewHide:YES];
        [self setRightButtonWithTitle:@"结束" selector:@selector(closedAction)];
        
    }

//    UIView *leftEdge = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, [UIScreen mainScreen].bounds.size.height)];
//    //    leftEdge.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
//    leftEdge.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:leftEdge];
    
}

- (void)closedAction{
    if (self.navigationController) {
        NSString *message = _isResult?@"测试结果已经保存，点确定重新测试":@"你确定要结束吗？结束将不保存该次评测数据";
        __weak XECommonWebVc *weakSelf = self;
        XEAlertView *alertView = [[XEAlertView alloc] initWithTitle:nil message:message cancelButtonTitle:@"取消" cancelBlock:^{
        } okButtonTitle:@"确认" okBlock:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        [alertView show];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithAddress:(NSString*)urlString{
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL*)URL{
    if(self = [super init]) {
        self.URL = URL;
        self.availableActions = WebViewControllerAvailableActionsOpenInSafari | WebViewControllerAvailableActionsOpenInChrome | WebViewControllerAvailableActionsMailLink;
    }
    
    return self;
}

- (void)loadURL:(NSURL*)URL{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    
//    NSDictionary *commonHeaders = [[LanShanEngine shareInstance] getHttpRequestCommonHeader];
//    if (commonHeaders) {
//        for (NSString *key in [commonHeaders allKeys]) {
//            [request addValue:[commonHeaders valueForKey:key] forHTTPHeaderField:key];
//        }
//    }
//    
//    NSString *agent = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserAgent"];
//    if (agent == nil) {
//        //get the original user-agent of webview
//        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
//        NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
//        NSLog(@"old agent :%@", oldAgent);
//        
//        //add my info to the new agent
//        NSString *newAgent = [oldAgent stringByAppendingFormat:@" WeMeet/%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]];
//        NSLog(@"new agent :%@", newAgent);
//        
//        //regist the new agent
//        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
//        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
//    }
    
    [self.mainWebView loadRequest:request];
}

#pragma mark -
#pragma mark UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"shouldStartLoadWithRequest url=%@ navigationType is %d\n", request.URL, (int)navigationType);
    
    NSURL *url = request.URL;
    NSLog(@"shouldStartLoadWithRequest: %@", url);
    if (_isFullScreen) {
        if ([url.absoluteString hasSuffix:@"===="]) {
            UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
            [self.navigationController popToViewController:vc animated:YES];
            return NO;
        }
        return YES;
    }
    if(_isCanClosed){
        NSRange range = [url.path rangeOfString:@"/eva/result"];
        if (range.length > 0) {
            _isResult = YES;
        }
    }
    
    NSRange range = [url.path rangeOfString:@"eva/history"];
    if (range.length > 0) {
        NSDictionary *paramDic = [XECommonUtils getParamDictFrom:url.query];
        NSLog(@"infoDic: %@", paramDic);
        if (paramDic) {
            
        }
        if (self.navigationController.viewControllers.count > 2) {
            UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
            if ([vc isKindOfClass:[StageSelectViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return NO;
            }
        }
        StageSelectViewController *ssVc = [[StageSelectViewController alloc] init];
        [self.navigationController pushViewController:ssVc animated:YES];
        return NO;
    }
    NSRange rangeNursers = [url.path rangeOfString:@"eva/nursers"];
    if (rangeNursers.length > 0) {
        ExpertListViewController *vc = [[ExpertListViewController alloc] init];
        vc.vcType = VcType_Nurser;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    NSRange rangeRestart = [url.path rangeOfString:@"eva/restart"];
    if (rangeRestart.length > 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self startPercentagePressed:nil];
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"web finish load, url=%@", self.mainWebView.request.URL);
    
    //    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    //    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    //    [self removeLoadNotice];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self setTitle:title];
//    [self updateToolbarItems:YES];
    [self finishPressed:nil];
//    NSString *backNum = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('backid').innerHTML"];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"web fail load ");
    
//    [self updateToolbarItems:YES];
    [self finishPressed:nil];
    
    if(self.availableActions == 0){
        return;
    }
}

- (void)startPercentagePressed:(id)sender
{
    self.canceled = NO;
    self.progressOn= (_progressOn + 1) % 5;
    [self performSelectorInBackground:@selector(runPercentageLoop) withObject:nil];
}

- (void)runPercentageLoop
{
    
    float percentage = 0;
    int   tag = self.progressOn;
    while (percentage <= 200 && !self.canceled )
    {
        //NSLog(@"%f", percentage);
        if (tag != self.progressOn) {
            return;
        }
        if (percentage <= 75 && !self.canceled) {
            [NSThread sleepForTimeInterval:0.1];
            percentage = percentage + 3;
            [self setSGProgressPercentage:percentage];
        }else{
            [NSThread sleepForTimeInterval:0.15];
            [self setSGProgressPercentage:percentage];
            if(percentage >= 90.0)
            {
                return;
            }
            percentage = percentage + (arc4random() % 3);
        }
    }
    self.progressOn = NO;
}

- (IBAction)finishPressed:(id)sender
{
    [self finishSGProgress];
    [self cancelPressed:nil];
}

- (IBAction)cancelPressed:(id)sender
{
    self.canceled = YES;
    [self cancelSGProgress];
}

- (void)viewUpdatesForPercentage:(float)percentage andTintColor:(UIColor *)tintColor
{
    if (self.canceled) {
        return;
    }
    
    UIView *progressView = [self setupSGProgressSubview];
    
    float maxWidth = SCREEN_WIDTH;
    float progressWidth = maxWidth * (percentage / 100);
    
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect progressFrame = progressView.frame;
        progressFrame.size.width = progressWidth;
        progressView.frame = progressFrame;
        
    } completion:^(BOOL finished)
     {
         //		 if(percentage >= 100.0)
         //		 {
         //			 [UIView animateWithDuration:0.5 animations:^{
         //				 progressView.alpha = 0;
         //			 } completion:^(BOOL finished) {
         //				 [progressView removeFromSuperview];
         //			 }];
         //		 }
     }];
}

- (UIView *)setupSGProgressSubview
{
    return [self setupSGProgressSubviewWithTintColor:[self getTintColor]];
}

- (UIView *)setupSGProgressSubviewWithTintColor:(UIColor *)tintColor
{
    float y = self.titleNavBar.frame.size.height - SGProgressBarHeight;
    
    UIView *progressView;
    for (UIView *subview in [self.titleNavBar subviews])
    {
        if (subview.tag == SGProgresstagId)
        {
            progressView = subview;
        }
    }
    
    if(!progressView)
    {
        progressView = [[UIView alloc] initWithFrame:CGRectMake(0, y, 0, SGProgressBarHeight)];
        progressView.tag = SGProgresstagId;
        progressView.backgroundColor = tintColor;
        [self.titleNavBar addSubview:progressView];
    }
    else
    {
        CGRect progressFrame = progressView.frame;
        progressFrame.origin.y = y;
        progressView.frame = progressFrame;
    }
    
    return progressView;
}

- (UIColor *)getTintColor
{
    //return [UIColor colorWithRed:51.0f/255.0f green:153.0f/255.0f blue:255.0f/255.0f alpha:1];
    return [UIColor whiteColor];
}

- (void)finishSGProgress
{
    UIView *progressView = [self setupSGProgressSubview];
    if(progressView)
    {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect progressFrame = progressView.frame;
            progressFrame.size.width = SCREEN_WIDTH;
            progressView.frame = progressFrame;
        }];
    }
}

- (void)cancelSGProgress {
    UIView *progressView;
    for (UIView *subview in [self.titleNavBar subviews])
    {
        if (subview.tag == SGProgresstagId)
        {
            progressView = subview;
        }
    }
    if(progressView)
    {
        [UIView animateWithDuration:0.5 animations:^{
            progressView.alpha = 0;
        } completion:^(BOOL finished) {
            [progressView removeFromSuperview];
        }];
    }
}

- (void)setSGProgressPercentage:(float)percentage
{
    [self setSGProgressPercentage:percentage andTintColor:[self getTintColor]];
}

- (void)setSGProgressPercentage:(float)percentage andTintColor:(UIColor *)tintColor
{
    if (percentage > 100.0)
    {
        percentage = 100.0;
    }
    else if(percentage < 0)
    {
        percentage = 0;
    }
    
    if([NSThread isMainThread])
    {
        [self viewUpdatesForPercentage:percentage andTintColor:tintColor];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self viewUpdatesForPercentage:percentage andTintColor:tintColor];
        });
    }
}

- (void)actionButtonClicked:(id)sender {
    //出现分享菜单
    //[self tapAtRightShareBtn:sender];
//    if ([[XEEngine shareInstance] needUserLogin:@"当前为游客状态，登录以后才能查看更多"]) {
//        return;
//    }
    __weak XECommonWebVc *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];

    [[XEEngine shareInstance] getRecipesStatusWithUid:[XEEngine shareInstance].uid rid:self.openId tag:tag];

    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {

        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
    
        BOOL status = [jsonRet boolValueForKey:@"object"];
        NSLog(@"请求成功");
        _shareAction = [[XEShareActionSheet alloc] init];
        _shareAction.owner = self;
        _shareAction.selectShareType = XEShareType_Web;
        _shareAction.bCollect = status;
        _shareAction.recipesId = weakSelf.openId;
        NSString *title = [self.mainWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('shareid').innerHTML"];
        _shareAction.webShareTitle = title;
        NSLog(@"title== %@",title);
        [_shareAction showShareAction];
    }tag:tag];
}

#pragma mark - XEShareActionSheetDelegate
-(void) deleteTopicAction:(id)info{
    [super backAction:nil];
}
- (void)dealloc
{
    [self.mainWebView stopLoading];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.mainWebView.delegate = nil;
}

@end
