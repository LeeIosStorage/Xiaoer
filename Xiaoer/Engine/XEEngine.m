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

#define CONNECT_TIMEOUT 20

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
    if ([dic objectForKey:@"apistatus"] == nil) {
        return nil;
    }
    if ([[dic objectForKey:@"apistatus"] intValue] == 1){
        return nil;
    }
    NSString* error = [[dic objectForKey:@"result"] objectForKey:@"error_zh_CN"];
    if (!error) {
        error = [[dic objectForKey:@"result"] objectForKey:@"error"];
    }
    if (error == nil) {
        error = @"unknow error";
    }
    return error;
}

+ (NSString*)getErrorCodeWithReponseDic:(NSDictionary*)dic {
    
    return [[[dic dictionaryObjectForKey:@"result"] stringObjectForKey:@"error_code"] description];
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
    
    //获取用户信息
    [self loadAccount];
    
    _userInfo = [[XEUserInfo alloc] init];
    _userInfo.uid = _uid;
    [self loadUserInfo];
    
    [self setDebugMode:[[NSUserDefaults standardUserDefaults] boolForKey:@"clientDebugMode2"]];

    
    return self;
}

- (void)logout{
    

}

- (void)logout:(BOOL)removeAccout{

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

- (void)loadAccount{
    NSDictionary * accountDic = [NSDictionary dictionaryWithContentsOfFile:[self getAccountsStoragePath]];
    _uid = [accountDic objectForKey:@"uid"];
    //.....account信息
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
    [dic setObject:params forKey:@"params"];
    return dic;
}

- (BOOL)loginWithAccredit:(NSString*)loginType error:(NSError **)errPtr
{
    //..UM
    //if else
    return NO;
}

- (BOOL)loginWithPhone:(NSString *)phone password:(NSString *)password error:(NSError **)errPtr
{
    return NO;
}

- (BOOL)loginWithEmail:(NSString*)email password:(NSString*)password error:(NSError **)errPtr
{
    return NO;
}

- (BOOL)setPasswordwithUid:(NSString*)uid Password:(NSString*)password tag:(int)tag error:(NSError **)errPtr
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:uid forKey:@"uid"];
    [params setObject:password forKey:@"password"];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:@"/........" type:0 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:errPtr];
}

- (BOOL)reDirectXECommonWithFormatDic:(NSDictionary *)dic withData:(NSData *)data withTag:(NSInteger)tag withTimeout:(NSTimeInterval)timeout error:(NSError **)errPtr {
    
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
        if ([_urlCacheTagMap objectForKey:[NSNumber numberWithInteger:tag]]) {
            [_urlCacheTagMap setObject:fullUrl forKey:[NSNumber numberWithInteger:tag]];
            [_needCacheUrls addObject:fullUrl];
            return YES;
        }
        [_urlTagMap setObject:fullUrl forKey:[NSNumber numberWithInteger:tag]];
        [self getWithURL:fullUrl params:params success:^(id json) {
            NSLog(@"fullUrl===========%@",json);
        } failure:^(NSError *error) {
            [XEProgressHUD lightAlert:@"请检查网络状况"];
        }];
        return YES;
    }else {
        [self postWithURL:url params:params success:^(id json) {
            NSLog(@"url===========%@",json);
        } failure:^(NSError *error) {
            [XEProgressHUD lightAlert:@"请检查网络状况"];

        }];
        return YES;
    }
    
    return NO;
}

//////////////////////
- (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [manager POST:url parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (success) {
                  success(responseObject);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (failure) {
                  failure(error);
              }
              //统一提示连接超时
              [XEProgressHUD AlertErrorTimeOut];
              [XEProgressHUD AlertLoadDone];
          }];
}

- (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [manager GET:url parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(responseObject);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(error);
             }
             //统一提示连接超时
             [XEProgressHUD AlertErrorTimeOut];
             [XEProgressHUD AlertLoadDone];
         }];
}


@end
