//
//  XEEngine.h
//  Xiaoer
//
//  Created by KID on 14/12/31.
//
//

#import <Foundation/Foundation.h>
#import "XEUserInfo.h"

#define XE_USERINFO_CHANGED_NOTIFICATION @"XE_USERINFO_CHANGED_NOTIFICATION"

typedef void(^onAppServiceBlock)(NSInteger tag, NSDictionary* jsonRet, NSError* err);
typedef void(^onLSMsgFileProgressBlock)(NSUInteger receivedSize, long long expectedSize);

@interface XEEngine : NSObject

@property (nonatomic, strong) NSString* uid;
@property (nonatomic, strong) NSString* account;
@property (nonatomic, strong) NSString* userPassword;
@property (nonatomic, strong) XEUserInfo* userInfo;
@property (nonatomic, readonly) NSDictionary* globalDefaultConfig;
@property (nonatomic,assign) BOOL debugMode;

@property (nonatomic,readonly) NSString* baseUrl;
@property (nonatomic, readonly) BOOL isFirstLoginInThisDevice;
@property (assign, nonatomic) BOOL bVisitor;

+ (XEEngine *)shareInstance;
+ (NSDictionary*)getReponseDicByContent:(NSData*)content err:(NSError*)err;
+ (NSString*)getErrorMsgWithReponseDic:(NSDictionary*)dic;
+ (NSString*)getErrorCodeWithReponseDic:(NSDictionary*)dic;
+ (NSString*)getSuccessMsgWithReponseDic:(NSDictionary*)dic;

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

- (BOOL)hasAccoutLoggedin;
- (void)logout;
- (void)logout:(BOOL)removeAccout;

//获取验证码
- (BOOL)getCodeWithPhone:(NSString*)phone type:(NSString*)type tag:(int)tag;
//校验验证码
- (BOOL)checkCodeWithPhone:(NSString*)phone code:(NSString*)msgcode codeType:(NSString*)type tag:(int)tag;

//重置密码
- (BOOL)resetPassword:(NSString*)password withUid:(NSString*)uid tag:(int)tag;

//校验邮箱 uid可以为空
- (BOOL)checkEmailWithEmail:(NSString *)email uid:(NSString *)uid tag:(int)tag;
//校验手机号 uid可以为空
- (BOOL)checkPhoneWithPhone:(NSString *)phone uid:(NSString *)uid tag:(int)tag;
//修改头像
- (BOOL)updateAvatarWithUid:(NSString *)uid avatar:(NSArray *)data tag:(int)tag;
//上传baby头像
- (BOOL)updateBabyAvatarWithBabyUid:(NSString *)bbUid avatar:(NSArray *)data tag:(int)tag;

//用户信息编辑
- (BOOL)editUserInfoWithUid:(NSString *)uid name:(NSString *)name nickname:(NSString *)nickname title:(NSString *)title desc:(NSString *)desc district:(NSString *)district address:(NSString *)address bbId:(NSString *)bbId bbName:(NSString *)bbName bbGender:(NSString *)bbGender bbBirthday:(NSString *)bbBirthday bbAvatar:(NSString *)bbAvatar userAvatar:(NSString *)userAvatar tag:(int)tag;

//获取地区-省
- (BOOL)getCommonAreaRoot:(int)tag;
//获取地区-市
- (BOOL)getCommonAreaNodeWithCode:(NSString *)code tag:(int)tag;

#pragma mark - home
//获取轮播信息
- (BOOL)getBannerWithTag:(int)tag;
//获取资讯(食谱,养育,评测)标签页数据
- (BOOL)getInfoWithBabyId:(NSString *)bbId tag:(int)tag;

//获取资讯(食谱,养育,评测)列表数据
- (BOOL)getListInfoWithNum:(NSString *)pagenum stage:(NSUInteger)stage cat:(int)cat tag:(int)tag;

//专家列表
- (BOOL)getExpertListWithPage:(int)page tag:(int)tag;

@end
