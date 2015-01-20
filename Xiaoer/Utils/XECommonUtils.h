//
//  XECommonUtils.h
//  Xiaoer
//
//  Created by KID on 14/12/31.
//
//

#import <Foundation/Foundation.h>

#define ls_dispatch_main_sync_safe(block)\
if ([NSThread isMainThread])\
{\
block();\
}\
else\
{\
dispatch_sync(dispatch_get_main_queue(), block);\
}

@interface XECommonUtils : NSObject

/*! @brief 判断是否为ios7及以上
 *
 *  @return
 */
+(BOOL) isUpperSDK;

+ (NSString *)fileNameEncodedString:(NSString *)string;

//获取文件夹大小
+ (unsigned long long)getDirectorySizeForPath:(NSString*)path;

+ (UInt32)getDistinctAsciiTextNum:(NSString*)text;
+ (UInt32)getHanziTextNum:(NSString*)text;
+ (NSString*)getHanziTextWithText:(NSString*)text maxLength:(UInt32)maxLength;

+ (NSDictionary *)getParamDictFrom:(NSString *)query;

//拨打电话
+ (void)usePhoneNumAction:(NSString *)phone;

@end
