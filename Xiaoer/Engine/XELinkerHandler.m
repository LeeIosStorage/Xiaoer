//
//  XELinkerHandler.m
//  Xiaoer
//
//  Created by KID on 14/12/31.
//
//

#import "XELinkerHandler.h"
#import "XECommonWebVc.h"
#import "XEEngine.h"
//#import "SVModalWebViewController+Back.h"

@implementation XELinkerHandler

+(id)handleDealWithHref:(NSString *)href From:(UINavigationController*)nav{
    NSURL *realUrl = [NSURL URLWithString:href];
    if (realUrl == nil) {
        realUrl = [NSURL URLWithString:[href stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    NSString* scheme = [realUrl.scheme lowercaseString];
    if ([scheme isEqualToString:@"XXX"]) {
//        NSString *lastCompment = [[realUrl path] lastPathComponent];
//        NSDictionary *paramDic = [XECommonUtils getParamDictFrom:realUrl.query];
//        if ([[realUrl host] isEqualToString:@"AAA"]) {
//            return nil;
//        }
//        //else if...
        
    }else if([scheme hasPrefix:@"http"]){
//        NSString *lastCompment = [[realUrl path] lastPathComponent];
//        NSDictionary *paramDic = [XECommonUtils getParamDictFrom:realUrl.query];
        //if...else
        
        if (nav) {
            NSString *url = [realUrl description];
            XECommonWebVc *webvc = [[XECommonWebVc alloc] initWithAddress:url];

            if ([url hasPrefix:[NSString stringWithFormat:@"%@/info/detail",[XEEngine shareInstance].baseUrl]]) {
                NSDictionary *paramDic = [XECommonUtils getParamDictFrom:realUrl.query];
                NSString *openId = [paramDic stringObjectForKey:@"id"];
                webvc.isShareViewOut = YES;
                webvc.openId = openId;
            }
            if ([url hasPrefix:[NSString stringWithFormat:@"%@/eva/test/start",[XEEngine shareInstance].baseUrl]]) {
                webvc.isCanClosed = YES;
            }
            if ([url hasPrefix:[NSString stringWithFormat:@"%@/eva/result",[XEEngine shareInstance].baseUrl]]) {
                webvc.isCanClosed = YES;
                webvc.isResult = YES;
            }
            if ([url hasPrefix:[NSString stringWithFormat:@"%@/train/cat",[XEEngine shareInstance].baseUrl]]) {
                webvc.isFullScreen = YES;
            }
//            webvc.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsOpenInChrome | SVWebViewControllerAvailableActionsCopyLink | SVWebViewControllerAvailableActionsMailLink;
            [nav pushViewController:webvc animated:YES];
        }
        return nil;
    }
    
    return nil;
}

@end
