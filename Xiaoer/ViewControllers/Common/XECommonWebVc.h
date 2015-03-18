//
//  XECommonWebVc.h
//  Xiaoer
//
//  Created by KID on 15/1/19.
//
//

#import "XESuperViewController.h"

enum {
    WebViewControllerAvailableActionsNone             = 0,
    WebViewControllerAvailableActionsOpenInSafari     = 1 << 0,
    WebViewControllerAvailableActionsMailLink         = 1 << 1,
    WebViewControllerAvailableActionsCopyLink         = 1 << 2,
    WebViewControllerAvailableActionsOpenInChrome     = 1 << 3
};
typedef NSUInteger WebViewControllerAvailableActions;

@interface XECommonWebVc : XESuperViewController<UIWebViewDelegate>

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;

@property (nonatomic, readwrite) WebViewControllerAvailableActions availableActions;
@property (nonatomic, strong) UIWebView *mainWebView;
@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, assign) BOOL isPortrait;
@property (nonatomic, assign) BOOL isShareViewOut;
@property (nonatomic, assign) BOOL isCanClosed;
@property (nonatomic, assign) BOOL isResult;
@property (nonatomic, strong) NSString *openId;

@end
