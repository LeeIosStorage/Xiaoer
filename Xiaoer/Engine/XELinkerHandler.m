//
//  XELinkerHandler.m
//  Xiaoer
//
//  Created by KID on 14/12/31.
//
//

#import "XELinkerHandler.h"

@implementation XELinkerHandler

+(id)handleDealWithHref:(NSString *)href From:(UINavigationController*)nav{
    NSURL *realUrl = [NSURL URLWithString:href];
    if (realUrl == nil) {
        realUrl = [NSURL URLWithString:[href stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    NSString* scheme = [realUrl.scheme lowercaseString];
    if ([scheme isEqualToString:@"XXX"]) {
        NSString *lastCompment = [[realUrl path] lastPathComponent];
        //NSDictionary *paramDic = [LSCommonUtils getParamDictFrom:realUrl.query];
        if ([[realUrl host] isEqualToString:@"AAA"]) {
            return nil;
        }
        //else if...
        
    }else if([scheme hasPrefix:@"http"]){
        NSString *lastCompment = [[realUrl path] lastPathComponent];
        //NSDictionary *paramDic = [LSCommonUtils getParamDictFrom:realUrl.query];
        //if...else
        
        if (nav) {
            NSString *url = [realUrl description];
//            LSCommonWebVc *webvc = [[LSCommonWebVc alloc] initWithAddress:url];
            //...
        }

    }
    
    return nil;
}

@end
