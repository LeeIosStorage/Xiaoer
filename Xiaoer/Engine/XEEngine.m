//
//  XEEngine.m
//  Xiaoer
//
//  Created by KID on 14/12/31.
//
//

#import "XEEngine.h"
#import "EGOCache.h"
#import "JSONKit.h"
#import "PathHelper.h"
#import "XECommonUtils.h"
#import "AFNetworking.h"
#import "XEProgressHUD.h"
#import "URLHelper.h"
#import "NSDictionary+objectForKey.h"
#import "QHQnetworkingTool.h"
#import "XESettingConfig.h"

#define CONNECT_TIMEOUT 20

#define API_URL @"http://192.168.16.29"

static XEEngine* s_ShareInstance = nil;

@interface XEEngine (){

    int _connectTag;
    
    NSMutableDictionary* _onAppServiceBlockMap;
    //....
    EGOCache* _cacheInstance;
    
    NSDictionary* _globalDefaultConfig;
    
    NSMutableSet* _needCacheUrls;
    
    NSMutableDictionary* _urlCacheTagMap;
    
    NSMutableDictionary* _urlTagMap;
}

@end

@implementation XEEngine

+ (XEEngine *)shareInstance{
    @synchronized(self) {
        if (s_ShareInstance == nil) {
            s_ShareInstance = [[XEEngine alloc] init];
        }
    }
    return s_ShareInstance;
}

+ (NSDictionary*)getReponseDicByContent:(NSData*)content err:(NSError*)err{
    if (err || !content || content.length == 0) {
        NSLog(@"#######content=nil");
        return nil;
    }
    NSDictionary* json = [content objectFromJSONData];
    return json;
}

+ (NSString*)getErrorMsgWithReponseDic:(NSDictionary*)dic{
    if (dic == nil) {
        return @"请检查网络连接是否正常";
    }
    if ([[dic objectForKey:@"code"] intValue] == 0){
        return nil;
    }else{
        NSString* error = [dic objectForKey:@"result"];
        if (!error) {
            error = [dic objectForKey:@"result"];
        }
        if (error == nil) {
            error = @"unknow error";
        }
        return error;
    }
}

+ (NSString*)getErrorCodeWithReponseDic:(NSDictionary*)dic {
    
    return [[[dic dictionaryObjectForKey:@"result"] stringObjectForKey:@"error_code"] description];
}

+ (NSString*)getSuccessMsgWithReponseDic:(NSDictionary*)dic{
    
    if (dic == nil) {
        return nil;
    }
    if ([[dic objectForKey:@"code"] intValue] == 0){
        return [dic objectForKey:@"result"];
    }else{
        return nil;
    }
}

- (EGOCache *)getCacheInstance{
    @synchronized(self) {
        if (_uid.length == 0) {
            return [EGOCache globalCache];
        }else{
            if (_cacheInstance == nil) {
                NSString* cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
                cachesDirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:_uid] copy];
                _cacheInstance = [[EGOCache alloc] initWithCacheDirectory:cachesDirectory];
                _cacheInstance.defaultTimeoutInterval = 365*24*60*60;
            }
        }
    }
    return _cacheInstance;
}

- (id)init{
    self = [super init];
    
    _connectTag = 100;
    _onAppServiceBlockMap = [[NSMutableDictionary alloc] init];
    _needCacheUrls = [[NSMutableSet alloc] init];
    _urlCacheTagMap = [[NSMutableDictionary alloc] init];
    _urlTagMap = [[NSMutableDictionary alloc] init];
    
    _uid = nil;
    _userPassword = nil;
    
    //获取用户信息
    [self loadAccount];
    
    _userInfo = [[XEUserInfo alloc] init];
    _userInfo.uid = _uid;
    [self loadUserInfo];
    
    //设置访问
    [self setDebugMode:[[NSUserDefaults standardUserDefaults] boolForKey:@"clientDebugMode2"]];
    
    return self;
}

- (void)logout{
    
    _isFirstLoginInThisDevice = NO;
    [self logout:NO];
}

- (void)logout:(BOOL)removeAccout{
    
    if (removeAccout) {
        _account = nil;
    }
    
    _userPassword = nil;
    [self saveAccount];
    _userInfo = [[XEUserInfo alloc] init];
    [XESettingConfig logout];
    _cacheInstance = nil;
    _bVisitor = YES;
}

- (NSString*)getCurrentAccoutDocDirectory{
    return [PathHelper documentDirectoryPathWithName:[NSString stringWithFormat:@"accounts/%@", _uid]];
}

- (NSDictionary*)globalDefaultConfig {
    if (_globalDefaultConfig == nil) {
        _globalDefaultConfig = [NSDictionary dictionaryWithContentsOfFile:[self getGlobalDefaultConfigPath]];
        
        if (_globalDefaultConfig == nil) {
            _globalDefaultConfig = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"globalDefaultConfig" ofType:nil]];
        }
    }
    
    return _globalDefaultConfig;
}

- (void)setGlobalDefaultConfig:(NSDictionary *)globalDefaultConfig {
    _globalDefaultConfig = globalDefaultConfig;
}

- (NSString *)getGlobalDefaultConfigPath{
    NSString *filePath = [[PathHelper documentDirectoryPathWithName:nil] stringByAppendingPathComponent:@"globalDefaultConfig"];
    return filePath;
}

- (NSString *)getAccountsStoragePath{
    NSString *filePath = [[PathHelper documentDirectoryPathWithName:nil] stringByAppendingPathComponent:@"account"];
    return filePath;
}

- (void)loadUserInfo{
    if(!_uid){
        return;
    }
    NSString *path = [[self getCurrentAccoutDocDirectory] stringByAppendingPathComponent:@"myUserInfo.xml"];
    NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *userDic = [jsonString objectFromJSONString];
    if (userDic) {
        if (_userInfo == nil) {
            _userInfo = [[XEUserInfo alloc] init];
        }
        [_userInfo setUserInfoByJsonDic:userDic];
    }
}

- (void)saveUserInfo{
    if (!_uid) {
        return;
    }
    
    if (!self.userInfo.jsonString) {
        return;
    }
    NSString* path = [[self getCurrentAccoutDocDirectory] stringByAppendingPathComponent:@"myUserInfo.xml"];
    [self.userInfo.jsonString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)setUserInfo:(XEUserInfo *)userInfo{
    _userInfo = userInfo;
    [[XESettingConfig staticInstance] setUserCfg:_userInfo.userInfoByJsonDic];
    [[NSNotificationCenter defaultCenter] postNotificationName:XE_USERINFO_CHANGED_NOTIFICATION object:self];
    [self saveUserInfo];
}


- (void)loadAccount{
    NSDictionary * accountDic = [NSDictionary dictionaryWithContentsOfFile:[self getAccountsStoragePath]];
     //.....account信息
    _uid = [accountDic objectForKey:@"uid"];
    _account = [accountDic objectForKey:@"account"];
    _userPassword = [accountDic objectForKey:@"accountPwd"];
}

- (void)saveAccount{
    NSMutableDictionary* accountDic= [NSMutableDictionary dictionaryWithCapacity:2];
    if (_uid) {
        [accountDic setValue:_uid forKey:@"uid"];
    }
    if (_account)
        [accountDic setValue:_account forKey:@"account"];
    if(_userPassword)
        [accountDic setValue:_userPassword forKey:@"accountPwd"];
    [accountDic writeToFile:[self getAccountsStoragePath] atomically:NO];
}

- (void)setDebugMode:(BOOL)debugMode save:(BOOL)save {
    _debugMode = debugMode;
    if (save) {
        [[NSUserDefaults standardUserDefaults] setBool:_debugMode forKey:@"clientDebugMode2"];
    }
}

- (void)setDebugMode:(BOOL)debugMode{
    
    [self setDebugMode:debugMode save:YES];
}

- (BOOL)hasAccoutLoggedin{
    NSLog(@"_account=%@, _userPassword=%@, _uid=%@", _account, _userPassword, _uid);
    return (_account && _userPassword && _uid);
}

-(NSString *)baseUrl{
    return API_URL;
}

//////////////////////
- (int)getConnectTag{
    return _connectTag++;
}

- (void)addOnAppServiceBlock:(onAppServiceBlock)block tag:(int)tag{
    [_onAppServiceBlockMap setObject:[block copy] forKey:[NSNumber numberWithInt:tag]];
}

- (void)removeOnAppServiceBlockForTag:(int)tag{
    [_onAppServiceBlockMap removeObjectForKey:[NSNumber numberWithInt:tag]];
}

- (onAppServiceBlock)getonAppServiceBlockByTag:(int)tag{
    return [_onAppServiceBlockMap objectForKey:[NSNumber numberWithInt:tag]];
}

- (void)addGetCacheTag:(int)tag{
    [_urlCacheTagMap setObject:@"" forKey:[NSNumber numberWithInt:tag]];
}

- (void)getCacheReponseDicForTag:(int)tag complete:(void(^)(NSDictionary* jsonRet))complete{
    NSString* urlString = [_urlCacheTagMap objectForKey:[NSNumber numberWithInt:tag]];
    [_urlCacheTagMap removeObjectForKey:[NSNumber numberWithInt:tag]];
    if (urlString == nil) {
        complete(nil);
        return;
    }
    if (urlString.length == 0) {
        complete(nil);
        return;
    }
    [self getCacheReponseDicForUrl:urlString complete:complete];
}

- (void)getCacheReponseDicForUrl:(NSString*)url complete:(void(^)(NSDictionary* jsonRet))complete{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *response = [[self getCacheInstance] stringForKey:[XECommonUtils fileNameEncodedString:url]];
        NSDictionary* jsonRet = [response objectFromJSONString];
        ls_dispatch_main_sync_safe(^{
            //catch缓存异常，并删除该缓存
            @try {
                complete(jsonRet);
            }
            @catch (NSException *exception) {
                NSLog(@"getCacheReponseDicForUrl complete exception=%@", exception);
                [[self getCacheInstance] removeCacheForKey:[XECommonUtils fileNameEncodedString:url]];
            }
        });
    });
}

- (void)saveCacheWithString:(NSString*)str url:(NSString*)url {
    [[self getCacheInstance] setString:str forKey:[XECommonUtils fileNameEncodedString:url]];
}

- (void)clearAllCache {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self getCacheInstance] clearCache];
    });
}

- (unsigned long long)getUrlCacheSize {
    NSString* cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    cachesDirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:_uid] copy];
    return [XECommonUtils getDirectorySizeForPath:cachesDirectory];
}

- (NSDictionary*)getRequestJsonWithUrl:(NSString*)url type:(int)type parameters:(NSDictionary *)params{
    return [self getRequestJsonWithUrl:url requestType:type serverType:1 parameters:params fileParam:nil];
}

- (NSDictionary*)getRequestJsonWithUrl:(NSString*)url requestType:(int)requestType serverType:(int)serverType parameters:(NSDictionary *)params fileParam:(NSString*)fileParam{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:url forKey:@"url"];
    [dic setObject:[NSNumber numberWithInt:requestType]  forKey:@"requestType"];
    [dic setObject:[NSNumber numberWithInt:serverType] forKey:@"serverType"];
//    if ([params count] > 0) {
//        [dic setObject:[URLHelper getURL:nil queryParameters:params prefixed:NO] forKey:@"params"];
//    }
//    if (fileParam) {
//        [dic setObject:fileParam forKey:@"fileParam"];
//    }
    if (params) {
        [dic setObject:params forKey:@"params"];
    }
    return dic;
}

- (BOOL)reDirectXECommonWithFormatDic:(NSDictionary *)dic withData:(NSArray *)dataArray withTag:(int)tag withTimeout:(NSTimeInterval)timeout error:(NSError *)errPtr {
    
    NSString* url = [dic objectForKey:@"url"];
    NSString* method = @"POST";
    if ([[dic objectForKey:@"requestType"] integerValue] == 1) {
        method = @"GET";
    }
    
    NSDictionary *params = [dic objectForKey:@"params"];
    
    if ([method isEqualToString:@"GET"]) {
        NSString* fullUrl = url;
        if (params) {
            NSString *param = [URLHelper getURL:nil queryParameters:params prefixed:NO];
            fullUrl = [NSString stringWithFormat:@"%@?%@", fullUrl, param];
        }
        NSLog(@"getFullUrl=%@",fullUrl);
        if ([_urlCacheTagMap objectForKey:[NSNumber numberWithInt:tag]]) {
            [_urlCacheTagMap setObject:fullUrl forKey:[NSNumber numberWithInt:tag]];
            [_needCacheUrls addObject:fullUrl];
            return YES;
        }
        [_urlTagMap setObject:fullUrl forKey:[NSNumber numberWithInteger:tag]];
        [QHQnetworkingTool getWithURL:fullUrl params:params success:^(id response) {
            NSLog(@"getFullUrl===========%@ response%@",fullUrl,response);
            [self onResponse:response withTag:tag withError:errPtr];
        } failure:^(NSError *error) {
            [XEProgressHUD lightAlert:@"请检查网络状况"];
        }];
        return YES;
    }else {
        NSString* fullUrl = url;
        if (params) {
            NSString *param = [URLHelper getURL:nil queryParameters:params prefixed:NO];
            fullUrl = [NSString stringWithFormat:@"%@?%@", fullUrl, param];
        }
        NSLog(@"postFullUrl=%@",fullUrl);
        if (dataArray) {
            
            [QHQnetworkingTool postWithURL:fullUrl params:nil formDataArray:dataArray success:^(id response) {
                NSLog(@"postFullUrl===========%@ response%@",fullUrl,response);
                [self onResponse:response withTag:tag withError:errPtr];
            } failure:^(NSError *error) {
                [XEProgressHUD lightAlert:@"请检查网络状况"];
            }];
            
        }else{
            [QHQnetworkingTool postWithURL:fullUrl params:params success:^(id response) {
                NSLog(@"postFullUrl===========%@ response%@",fullUrl,response);
                [self onResponse:response withTag:tag withError:errPtr];
            } failure:^(NSError *error) {
                [XEProgressHUD lightAlert:@"请检查网络状况"];
                
            }];
        }
        return YES;
    }
    
    NSError* err = nil;
    
    onAppServiceBlock block = [self getonAppServiceBlockByTag:tag];
    if (block) {
        [self removeOnAppServiceBlockForTag:tag];
        block(tag, nil, err);
    }
    
    return NO;
}

- (void)onResponse:(id)jsonRet withTag:(int)tag withError:(NSError *)errPtr
{
    if (!jsonRet) {
        NSLog(@"========================%@",[jsonRet objectForKey:@"code"]);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        BOOL timeout = NO;
//        if ([jsonRet integerForKey:@"code"] == 2) {
//            timeout = YES;
//        }
//        NSLog(@"========================%@",[jsonRet objectForKey:@"result"]);
        if (jsonRet && !errPtr) {
            NSString* fullUrl = [_urlTagMap objectForKey:[NSNumber numberWithInt:tag]];
            if (fullUrl) {
                //有错误的内容不缓存
                if ([_needCacheUrls containsObject:fullUrl] && ![XEEngine getErrorMsgWithReponseDic:jsonRet]) {
                 //   [[self getCacheInstance] setString:response forKey:[XECommonUtils fileNameEncodedString:fullUrl]];
                 //   NSLog(@"=======================%@",jsonRet);
                }
            }
        }
        
        [_urlTagMap removeObjectForKey:[NSNumber numberWithInt:tag]];
        
        onAppServiceBlock block = [self getonAppServiceBlockByTag:tag];
        if (block) {
            [self removeOnAppServiceBlockForTag:tag];
            if (timeout) {
                block(tag, nil, [NSError errorWithDomain:@"timeout" code:408 userInfo:nil]);
            }else{
                block(tag, jsonRet, errPtr);
            }
        }
    });
}

- (BOOL)registerWithPhone:(NSString*)phone password:(NSString*)password tag:(int)tag
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:phone forKey:@"phone"];
    [params setObject:password forKey:@"password"];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/user/reg/phone",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)registerWithEmail:(NSString*)email password:(NSString*)password tag:(int)tag
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:email forKey:@"email"];
    [params setObject:password forKey:@"password"];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/user/reg/email",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)loginWithAccredit:(NSString*)loginType error:(NSError **)errPtr
{
    //..UM
    //if else
    return NO;
}

- (BOOL)loginWithPhone:(NSString *)phone password:(NSString *)password tag:(int)tag error:(NSError **)errPtr
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:phone forKey:@"phone"];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/user/login",API_URL] type:0 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)loginWithUid:(NSString *)uid password:(NSString*)password tag:(int)tag error:(NSError **)errPtr{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:uid forKey:@"content"];
    [params setObject:password forKey:@"password"];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/user/login",API_URL] type:0 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];

}

- (BOOL)loginWithEmail:(NSString*)email password:(NSString*)password error:(NSError **)errPtr
{
    return NO;
}

- (BOOL)getCodeWithPhone:(NSString*)phone type:(NSString*)type tag:(int)tag
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:phone forKey:@"phone"];
    [params setObject:type forKey:@"type"];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/user/msg/code",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)checkCodeWithPhone:(NSString*)phone code:(NSString*)msgcode codeType:(NSString*)type tag:(int)tag
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:phone forKey:@"phone"];
    [params setObject:msgcode forKey:@"msgcode"];
    [params setObject:type forKey:@"type"];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/user/check/msgcode",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];

}

- (BOOL)resetPassword:(NSString*)password withUid:(NSString*)uid tag:(int)tag
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:password forKey:@"password"];
    [params setObject:uid forKey:@"userid"];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/user/password/reset",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}


- (BOOL)checkEmailWithEmail:(NSString *)email uid:(NSString *)uid tag:(int)tag{
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    if (email) {
        [params setObject:email forKey:@"email"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/user/check/email",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)checkPhoneWithPhone:(NSString *)phone uid:(NSString *)uid tag:(int)tag{
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    if (phone) {
        [params setObject:phone forKey:@"phone"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/user/check/phone",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)updateAvatarWithUid:(NSString *)uid avatar:(NSArray *)data tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    
    [params setObject:uid forKey:@"userid"];
    
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/user/avatar",API_URL] type:2 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:data withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)updateBabyAvatarWithBabyUid:(NSString *)bbUid avatar:(NSArray *)data tag:(int)tag{
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (bbUid) {
        [params setObject:bbUid forKey:@"babyid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/user/bbavatar",API_URL] type:2 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:data withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)editUserInfoWithUid:(NSString *)uid name:(NSString *)name nickname:(NSString *)nickname title:(NSString *)title desc:(NSString *)desc district:(NSString *)district address:(NSString *)address bbId:(NSString *)bbId bbName:(NSString *)bbName bbGender:(NSString *)bbGender bbBirthday:(NSString *)bbBirthday bbAvatar:(NSString *)bbAvatar userAvatar:(NSString *)userAvatar tag:(int)tag{
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (uid) {
        [params setObject:uid forKey:@"id"];
    }
    if (name) {
        [params setObject:name forKey:@"name"];
    }
    if (nickname) {
        [params setObject:nickname forKey:@"nickname"];
    }
    if (title) {
        [params setObject:title forKey:@"title"];
    }
    if (desc) {
        [params setObject:desc forKey:@"desc"];
    }
    if (district) {
        [params setObject:district forKey:@"district"];
    }
    if (address) {
        [params setObject:address forKey:@"address"];
    }
    if (bbId) {
        [params setObject:bbId forKey:@"bb_id"];
    }
    if (bbName) {
        [params setObject:bbName forKey:@"bb_name"];
    }
    if (bbGender) {
        [params setObject:bbGender forKey:@"bb_gender"];
    }
    if (bbBirthday) {
        [params setObject:bbBirthday forKey:@"bb_born"];
    }
    if (bbAvatar) {
        [params setObject:bbAvatar forKey:@"bb_icon"];
    }
    if (userAvatar) {
        [params setObject:userAvatar forKey:@"avatar"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/user/edit",API_URL] type:0 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
    
}

- (BOOL)getCommonAreaRoot:(int)tag{
    
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/common/area/root",API_URL] type:1 parameters:nil];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
    
}
- (BOOL)getCommonAreaNodeWithCode:(NSString *)code tag:(int)tag{
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (code) {
        [params setObject:code forKey:@"code"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/common/area/node",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getBannerWithTag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/index/banner",API_URL] type:0 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getInfoWithBabyId:(NSString *)bbId tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/index/info/tab",API_URL] type:0 parameters:params];
    if (bbId) {
        [params setObject:bbId forKey:@"babyid"];
    }
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

@end
