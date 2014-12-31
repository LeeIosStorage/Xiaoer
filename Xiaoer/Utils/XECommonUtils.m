//
//  XECommonUtils.m
//  Xiaoer
//
//  Created by KID on 14/12/31.
//
//

#import "XECommonUtils.h"

@implementation XECommonUtils

+(BOOL) isUpperSDK
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        return YES;
    }
    return NO;
}

@end
