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

+ (NSString *)fileNameEncodedString:(NSString *)string
{
    if (![string length])
        return @"";
    
    CFStringRef static const charsToEscape = CFSTR(".:/");
    CFStringRef escapedString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                        (__bridge CFStringRef)string,
                                                                        NULL,
                                                                        charsToEscape,
                                                                        kCFStringEncodingUTF8);
    return (__bridge_transfer NSString *)escapedString;
}

+ (unsigned long long)getDirectorySizeForPath:(NSString*)path {
    unsigned long long size = 0;
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }
    return size;
}

@end
