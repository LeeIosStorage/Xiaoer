//
//  XEEngine.h
//  Xiaoer
//
//  Created by KID on 14/12/31.
//
//

#import <Foundation/Foundation.h>
#import "XEUserInfo.h"

#define LS_USERINFO_CHANGED_NOTIFICATION @"LS_USERINFO_CHANGED_NOTIFICATION"

typedef void(^onAppServiceBlock)(NSInteger tag, NSDictionary* jsonRet, NSError* err);
typedef void(^onLSMsgFileProgressBlock)(NSUInteger receivedSize, long long expectedSize);

@interface XEEngine : NSObject

@property (nonatomic, strong) NSString* uid;
@property (nonatomic, strong) XEUserInfo* userInfo;
@property (nonatomic, readonly) NSDictionary* globalDefaultConfig;
@property (nonatomic,assign) BOOL debugMode;


+ (XEEngine *)shareInstance;
+ (NSDictionary*)getReponseDicByContent:(NSData*)content err:(NSError*)err;
+ (NSString*)getErrorMsgWithReponseDic:(NSDictionary*)dic;
+ (NSString*)getErrorCodeWithReponseDic:(NSDictionary*)dic;

- (void)saveAccount;
- (NSString*)getCurrentAccoutDocDirectory;

//////////////////
- (int)getConnectTag;
- (void)addOnAppServiceBlock:(onAppServiceBlock)block tag:(int)tag;
- (void)removeOnAppServiceBlockForTag:(int)tag;
- (void)addGetCacheTag:(int)tag;
- (onAppServiceBlock)getonAppServiceBlockByTag:(int)tag;

//异步回调
- (void)getCacheReponseDicForTag:(int)tag complete:(void(^)(NSDictionary* jsonRet))complete;
- (void)getCacheReponseDicForUrl:(NSString*)url complete:(void(^)(NSDictionary* jsonRet))complete;

//保存cache
- (void)saveCacheWithString:(NSString*)str url:(NSString*)url;
- (void)clearAllCache;
- (unsigned long long)getUrlCacheSize;


#pragma mark -register and login
- (BOOL)registerWithPhone:(NSString*)phone password:(NSString*)password tag:(int)tag;
- (BOOL)registerWithEmail:(NSString*)email password:(NSString*)password tag:(int)tag;

- (BOOL)loginWithAccredit:(NSString*)loginType error:(NSError **)errPtr;
- (BOOL)loginWithPhone:(NSString*)phone password:(NSString*)password tag:(int)tag error:(NSError **)errPtr;
- (BOOL)loginWithEmail:(NSString*)email password:(NSString*)password error:(NSError **)errPtr;

- (BOOL)loginWithUid:(NSString *)uid password:(NSString*)password tag:(int)tag error:(NSError **)errPtr;

- (void)logout;
- (void)logout:(BOOL)removeAccout;

//获取验证码
- (BOOL)getCodeWithPhone:(NSString*)phone tag:(int)tag;
//校验验证码
- (BOOL)checkCodeWithPhone:(NSString*)phone code:(NSString*)msgcode codeType:(NSString*)type tag:(int)tag;

//重置密码
- (BOOL)resetPassword:(NSString*)password withUid:(NSString*)uid tag:(int)tag;

/////////////////

- (BOOL)setPasswordwithUid:(NSString*)uid Password:(NSString*)password tag:(int)tag error:(NSError *)errPtr;

//校验邮箱 uid可以为空
- (BOOL)checkEmailWithEmail:(NSString *)email uid:(NSString *)uid tag:(int)tag;
//校验手机号 uid可以为空
- (BOOL)checkPhoneWithPhone:(NSString *)phone uid:(NSString *)uid tag:(int)tag;

@end
