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
#import "XEAlertView.h"
#import "WelcomeViewController.h"
#import "AppDelegate.h"
#import "XENavigationController.h"
#import "UMSocial.h"

#define CONNECT_TIMEOUT 20
//测试接口
//static NSString* API_URL = @"http://xiaor123.cn:801/api";
static NSString* API_URL = @"http://test.xiaor123.cn:801/api";

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
    
    _serverPlatform = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"serverPlatform"];
    if (_serverPlatform == 0)
    {
        _serverPlatform = OnlinePlatform;//默认线上平台
    }
    
    //设置访问
    [self setDebugMode:[[NSUserDefaults standardUserDefaults] boolForKey:@"clientDebugMode2"]];
    
    [self serverInit];
    
    _xeInstanceDocPath = [PathHelper documentDirectoryPathWithName:@"XE_Path"];
    NSLog(@"cache file path: %@", _xeInstanceDocPath);
    
    return self;
}

- (void)serverInit{
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    if (self.serverPlatform == TestPlatform) {
        API_URL = @"http://test.xiaor123.cn:801/api";
    } else {
        API_URL = @"http://xiaor123.cn:801/api";
    }
}

- (void)logout{
    _firstLogin = YES;
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
    if (!jsonString) {
        [self refreshUserInfo];
    }
    NSDictionary *userDic = [jsonString objectFromJSONString];
    XELog(@"XEEngine loadUserInfo userDic =%@ ",userDic);
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

-(void)removeAccount{
    [[NSFileManager defaultManager] removeItemAtPath:[self getAccountsStoragePath] error:nil];
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

- (void)setServerPlatform:(ServerPlatform)serverPlatform {
    _serverPlatform = serverPlatform;
    [[NSUserDefaults standardUserDefaults] setInteger:_serverPlatform forKey:@"serverPlatform"];
    [self serverInit];
}

- (void)refreshUserInfo{
    int tag = [self getConnectTag];
    [self getUserInfoWithUid:self.uid tag:tag error:nil];
    [self addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (jsonRet && !errorMsg) {
            [[XEEngine shareInstance].userInfo setUserInfoByJsonDic:[jsonRet objectForKey:@"object"]];
            [XEEngine shareInstance].userInfo = [XEEngine shareInstance].userInfo;
        }
        
    } tag:tag];
}

#pragma mark - Visitor 
- (void)visitorLogin{
    _uid = nil;
    _account = nil;
    _userPassword = nil;
    [self removeAccount];
    _userInfo = [[XEUserInfo alloc] init];
}
- (BOOL)needUserLogin:(NSString *)message{
    if (![self hasAccoutLoggedin]) {
        if (message == nil) {
            message = @"请登录";
        }
        XEAlertView *alertView = [[XEAlertView alloc] initWithTitle:nil message:message cancelButtonTitle:@"取消" cancelBlock:^{
        } okButtonTitle:@"登录" okBlock:^{
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            WelcomeViewController *welcomeVc = [[WelcomeViewController alloc] init];
            welcomeVc.showBackButton = YES;
            XENavigationController* navigationController = [[XENavigationController alloc] initWithRootViewController:welcomeVc];
            navigationController.navigationBarHidden = YES;
            [appDelegate.mainTabViewController.navigationController presentViewController:navigationController animated:YES completion:^{
                
            }];
        }];
        [alertView show];
        return YES;
    }
    return NO;
}

#pragma mark - request
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
            [self onResponse:nil withTag:tag withError:error];
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
                [self onResponse:nil withTag:tag withError:error];
            }];
        }else{
            [QHQnetworkingTool postWithURL:fullUrl params:params success:^(id response) {
                NSLog(@"postFullUrl===========%@ response%@",fullUrl,response);
                [self onResponse:response withTag:tag withError:errPtr];
            } failure:^(NSError *error) {
                [self onResponse:nil withTag:tag withError:error];
            }];
        }
        return YES;
    }
    
    NSError* err = nil;
    if (errPtr) {
        err = errPtr;
    }
    onAppServiceBlock block = [self getonAppServiceBlockByTag:tag];
    if (block) {
        [self removeOnAppServiceBlockForTag:tag];
        block(tag, nil, err);
    }
    
    return NO;
}

- (void)onResponse:(id)jsonRet withTag:(int)tag withError:(NSError *)errPtr
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        BOOL timeout = NO;
        if (!jsonRet) {
            timeout = YES;
        }
        if (jsonRet && !errPtr) {
            NSString* fullUrl = [_urlTagMap objectForKey:[NSNumber numberWithInt:tag]];
            if (fullUrl) {
                //有错误的内容不缓存
                if ([_needCacheUrls containsObject:fullUrl] && ![XEEngine getErrorMsgWithReponseDic:jsonRet]) {
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonRet options:NSJSONWritingPrettyPrinted error:nil];
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    [[self getCacheInstance] setString:jsonString forKey:[XECommonUtils fileNameEncodedString:fullUrl]];
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

- (BOOL)loginWithAccredit:(NSString*)loginType presentingController:(UIViewController *)presentingController tag:(int)tag error:(NSError **)errPtr
{
    //..UM
    //if else
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:loginType];
    snsPlatform.loginClickHandler(presentingController,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
                                  {
                                      if ([loginType isEqualToString:UMShareToSina])
                                      {
                                          [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse)
                                           {
                                               NSDictionary *info = nil;
                                               if (accountResponse.responseCode == UMSResponseCodeSuccess)
                                               {
                                                   info = [[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToSina];
                                               }else
                                               {
                                                   NSString *message = @"授权失败";
                                                   if (accountResponse.message) {
                                                       message = accountResponse.message;
                                                   }
                                                   info = [NSDictionary dictionaryWithObject:message forKey:@"error"];
                                               }
                                               onAppServiceBlock block = [self getonAppServiceBlockByTag:tag];
                                               if (block) {
                                                   [self removeOnAppServiceBlockForTag:tag];
                                                   block(tag, info, nil);
                                               }
                                           }];
                                      }
                                      else if ([loginType isEqualToString:UMShareToQQ])
                                      {
                                          [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ completion:^(UMSocialResponseEntity *respose)
                                           {
                                               NSDictionary *info = nil;
                                               if (respose.responseCode == UMSResponseCodeSuccess)
                                               {
                                                   info = respose.data;
                                               }else
                                               {
                                                   NSString *message = @"授权失败";
                                                   if (respose.message) {
                                                       message = respose.message;
                                                   }
                                                   info = [NSDictionary dictionaryWithObject:message forKey:@"error"];
                                               }
                                               onAppServiceBlock block = [self getonAppServiceBlockByTag:tag];
                                               if (block) {
                                                   [self removeOnAppServiceBlockForTag:tag];
                                                   block(tag, info, nil);
                                               }
                                           }];
                                      }
                                      else if ([loginType isEqualToString:UMShareToWechatSession])
                                      {
                                          [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession completion:^(UMSocialResponseEntity *respose)
                                           {
                                               NSDictionary *info = nil;
                                               if (respose.responseCode == UMSResponseCodeSuccess)
                                               {
                                                   info = respose.data;
                                               }else
                                               {
                                                   NSString *message = @"授权失败";
                                                   if (respose.message) {
                                                       message = respose.message;
                                                   }
                                                   info = [NSDictionary dictionaryWithObject:message forKey:@"error"];
                                               }
                                               onAppServiceBlock block = [self getonAppServiceBlockByTag:tag];
                                               if (block) {
                                                   [self removeOnAppServiceBlockForTag:tag];
                                                   block(tag, info, nil);
                                               }
                                           }];
                                      }
                                  });
    return YES;
}

- (BOOL)thirdLoginWithPlantform:(NSString*)plantform avatar:(NSString*)avatar openid:(NSString*)openid nickname:(NSString*)nickname gender:(NSString*)gender tag:(int)tag error:(NSError **)errPtr{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (plantform) {
        [params setObject:plantform forKey:@"plantform"];
    }
    if (avatar) {
        [params setObject:avatar forKey:@"avatar"];
    }
    if (openid) {
        [params setObject:openid forKey:@"openid"];
    }
    if (nickname) {
        [params setObject:nickname forKey:@"nickname"];
    }
    if (gender) {
        [params setObject:gender forKey:@"gender"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/third/login",API_URL] type:0 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
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

- (BOOL)getUserInfoWithUid:(NSString*)uid tag:(int)tag error:(NSError **)errPtr{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/user/sync",API_URL] type:1 parameters:params];
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

- (BOOL)resetPassword:(NSString*)password withPhone:(NSString*)phone tag:(int)tag
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (password) {
        [params setObject:password forKey:@"password"];
    }
    if (phone) {
        [params setObject:phone forKey:@"phone"];
    }
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
- (BOOL)preresetPasswordWithEmail:(NSString *)email tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (email) {
        [params setObject:email forKey:@"email"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/user/password/email/prereset",API_URL] type:1 parameters:params];
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

- (BOOL)updateBgImgWithUid:(NSString *)uid avatar:(NSArray *)data tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/user/bgimg",API_URL] type:2 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:data withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
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

- (BOOL)editUserInfoWithUid:(NSString *)uid name:(NSString *)name nickname:(NSString *)nickname hasBaby:(NSString *)hasBaby desc:(NSString *)desc district:(NSString *)district address:(NSString *)address phone:(NSString *)phone bbId:(NSString *)bbId bbName:(NSString *)bbName bbGender:(NSString *)bbGender bbBirthday:(NSString *)bbBirthday bbAvatar:(NSString *)bbAvatar userAvatar:(NSString *)userAvatar dueDate:(NSString *)dueDate hospital:(NSString *)hospital tag:(int)tag{
    
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
    if (hasBaby) {
        [params setObject:hasBaby forKey:@"hasbaby"];
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
    if (phone) {
        [params setObject:phone forKey:@"phone"];
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
    if (dueDate) {
        [params setObject:dueDate forKey:@"due_date"];
    }
    if (hospital) {
        [params setObject:hospital forKey:@"hospital"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/user/edit",API_URL] type:0 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
    
}

- (BOOL)editBabyInfoWithUserId:(NSString *)uid bbId:(NSString *)bbId bbName:(NSString *)bbName bbGender:(NSString *)bbGender bbBirthday:(NSString *)bbBirthday bbAvatar:(NSString *)bbAvatar acquiesce:(NSString *)acquiesce tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (uid) {
        [params setObject:uid forKey:@"userid"];
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
    //是否默认宝宝
    if (acquiesce) {
        [params setObject:acquiesce forKey:@"acquiesce"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/baby/save",API_URL] type:0 parameters:params];
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

//获取服务器版本信息
- (BOOL)getAppNewVersionWithTag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/version/ios/check",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

#pragma mark - home
- (BOOL)getBannerWithTag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/index/banner",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getHomepageInfosWithUid:(NSString *)uid tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/index/userinfos",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getTrainIngosWithUid:(NSString *)uid tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:uid forKey:@"userid"];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/index/train",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getInfoWithBabyId:(NSString *)bbId tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/index/info/tab",API_URL] type:1 parameters:params];
    if (bbId) {
        [params setObject:bbId forKey:@"babyid"];
    }
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getListInfoWithNum:(NSUInteger)pagenum stage:(NSUInteger)stage cat:(int)cat tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/index/info/list",API_URL] type:1 parameters:params];
    if (pagenum) {
        [params setObject:[NSNumber numberWithInteger:pagenum] forKey:@"pagenum"];
    }
    [params setObject:[NSNumber numberWithInteger:stage] forKey:@"stage"];
    [params setObject:[NSNumber numberWithInteger:cat] forKey:@"cat"];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)collectInfoWithInfoId:(NSString *)infoId uid:(NSString *)uid tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (infoId) {
        [params setObject:infoId forKey:@"id"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/info/fav",API_URL] type:0 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)unCollectInfoWithInfoId:(NSString *)infoId uid:(NSString *)uid tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (infoId) {
        [params setObject:infoId forKey:@"id"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/info/unfav",API_URL] type:0 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

//查询资讯是否被当前用户收藏
- (BOOL)getRecipesStatusWithUid:(NSString *)uid rid:(NSString *)rid tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    if (rid) {
        [params setObject:rid forKey:@"id"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/info/faved",API_URL] type:0 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getExpertListWithPage:(int)page tag:(int)tag{
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (page > 0 ) {
        [params setObject:[NSNumber numberWithInt:page] forKey:@"pagenum"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/index/expert",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getExpertDetailWithUid:(NSString *)uid expertId:(NSString *)expertId tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (expertId) {
        [params setObject:expertId forKey:@"expertid"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/expert/detail",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)collectExpertWithExpertId:(NSString *)expertId uid:(NSString *)uid tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (expertId) {
        [params setObject:expertId forKey:@"id"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/expert/fav",API_URL] type:0 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)unCollectExpertWithExpertId:(NSString *)expertId uid:(NSString *)uid tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (expertId) {
        [params setObject:expertId forKey:@"id"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/expert/unfav",API_URL] type:0 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)shareExpertWithExpertId:(NSString *)expertId uid:(NSString *)uid tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (expertId) {
        [params setObject:expertId forKey:@"id"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/expert/share",API_URL] type:0 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getNurserListWithPage:(int)page uid:(NSString *)uid tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (page > 0 ) {
        [params setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/eva/nursers",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)bindNurserWithNurserId:(NSString *)nurserid uid:(NSString *)uid tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (nurserid) {
        [params setObject:nurserid forKey:@"nurserid"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/eva/bindnurser",API_URL] type:0 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getApplyActivityListWithPage:(int)page uid:(NSString *)uid type:(int)type tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (page > 0 ) {
        [params setObject:[NSNumber numberWithInt:page] forKey:@"pagenum"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    if (type > 0) {
        [params setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/index/activity/all",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getApplyActivityDetailWithActivityId:(NSString *)activityId uid:(NSString *)uid type:(int)type tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (activityId) {
        [params setObject:activityId forKey:@"id"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    if (type > 0) {
        [params setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/activity/detail",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)applyActivityWithActivityId:(NSString *)activityId uid:(NSString *)uid type:(int)type tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (activityId) {
        [params setObject:activityId forKey:@"id"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    if (type > 0) {
        [params setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    }
//    if (nickname) {
//        [params setObject:nickname forKey:@"nickname"];
//    }
//    if (title) {
//        [params setObject:title forKey:@"title"];
//    }
//    if (phone) {
//        [params setObject:phone forKey:@"phone"];
//    }
//    if (district) {
//        [params setObject:district forKey:@"district"];
//    }
//    if (address) {
//        [params setObject:address forKey:@"address"];
//    }
//    if (remark) {
//        [params setObject:remark forKey:@"remark"];
//    }
//    if (stage > 0) {
//        [params setObject:[NSNumber numberWithInt:stage] forKey:@"stage"];
//    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/activity/reg",API_URL] type:0 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)applyActivityAddInfoWithActivityId:(NSString *)activityId name:(NSString *)name  remark:(NSString *)remark tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (activityId) {
        [params setObject:activityId forKey:@"id"];
    }
    if (name) {
        [params setObject:name forKey:@"name"];
    }
    if (remark) {
        [params setObject:remark forKey:@"remark"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/activity/reg/addinfo",API_URL] type:0 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)collectActivityWithActivityId:(NSString *)activityId uid:(NSString *)uid type:(int)type tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (activityId) {
        [params setObject:activityId forKey:@"id"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    if (type > 0) {
        [params setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/activity/fav",API_URL] type:0 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)unCollectActivityWithActivityId:(NSString *)activityId uid:(NSString *)uid type:(int)type tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (activityId) {
        [params setObject:activityId forKey:@"id"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    if (type > 0) {
        [params setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/activity/unfav",API_URL] type:0 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)shareActivityWithActivityId:(NSString *)activityId uid:(NSString *)uid type:(int)type tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (activityId) {
        [params setObject:activityId forKey:@"id"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    if (type > 0) {
        [params setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/activity/share",API_URL] type:0 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getHistoryActivityListWithPage:(int)page tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (page > 0 ) {
        [params setObject:[NSNumber numberWithInt:page] forKey:@"pagenum"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/index/activity/his",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

//- (BOOL)getTopicListWithExpertId:(NSString *)expertId page:(int)page tag:(int)tag{
//    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
//    if (expertId) {
//        [params setObject:expertId forKey:@"id"];
//    }
//    if (page > 0) {
//        [params setObject:[NSNumber numberWithInt:page] forKey:@"pagenum"];
//    }
//    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/topic/list",API_URL] type:1 parameters:params];
//    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
//}

#pragma mark - expertChat
//获取热门话题
- (BOOL)getHotTopicWithWithPagenum:(int)page tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (page > 0 ) {
        [params setObject:[NSNumber numberWithInt:page] forKey:@"pagenum"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/topic/all",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
//获取热门话题20条
- (BOOL)getHotTopicWithWithTag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/topic/hot",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

//获取专家问答list
- (BOOL)getQuestionListWithPagenum:(int)page tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (page > 0 ) {
        [params setObject:[NSNumber numberWithInt:page] forKey:@"pagenum"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/qa/publist",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

//获取专家问答20条
- (BOOL)getHotQuestionWithTag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/qa/hot",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

//获取类别话题list
- (BOOL)getHotTopicListWithCat:(int)cat pagenum:(int)page tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSNumber numberWithInt:cat] forKey:@"cat"];
    if (page > 0 ) {
        [params setObject:[NSNumber numberWithInt:page] forKey:@"pagenum"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/topic/cat",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

//用户问答列表list
- (BOOL)getQuestionListWithUid:(NSString *)uid pagenum:(int)page tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:uid forKey:@"userid"];
    if (page > 0 ) {
        [params setObject:[NSNumber numberWithInt:page] forKey:@"pagenum"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/qa/asklist",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getTopicDetailsInfoWithTopicId:(NSString *)tid uid:(NSString *)uid tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (tid) {
        [params setObject:tid forKey:@"id"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/topic/detail",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)collectTopicWithTopicId:(NSString *)tid uid:(NSString *)uid tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (tid) {
        [params setObject:tid forKey:@"id"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/topic/fav",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)unCollectTopicWithTopicId:(NSString *)tid uid:(NSString *)uid tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (tid) {
        [params setObject:tid forKey:@"id"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/topic/unfav",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)shareTopicWithTopicId:(NSString *)tid uid:(NSString *)uid tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (tid) {
        [params setObject:tid forKey:@"id"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/topic/share",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)deleteTopicWithTopicId:(NSString *)tid uid:(NSString *)uid tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (tid) {
        [params setObject:tid forKey:@"id"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/topic/del",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)commitCommentTopicWithTopicId:(NSString *)tid uid:(NSString *)uid content:(NSString *)content tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (tid) {
        [params setObject:tid forKey:@"topicid"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    if (content) {
        [params setObject:content forKey:@"content"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/comment/commit",API_URL] type:2 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)deleteCommentTopicWithCommentId:(NSString *)cid uid:(NSString *)uid topicId:(NSString *)topicId tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (cid) {
        [params setObject:cid forKey:@"id"];
    }
    if (topicId) {
        [params setObject:topicId forKey:@"topicid"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/comment/del",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}


- (BOOL)getTopicCommentListWithWithTopicId:(NSString *)tid pagenum:(int)page tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (tid) {
        [params setObject:tid forKey:@"topicid"];
    }
    if (page > 0 ) {
        [params setObject:[NSNumber numberWithInt:page] forKey:@"pagenum"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/comment/list",API_URL] type:1 parameters:params];

    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)publishTopicWithUserId:(NSString *)uid title:(NSString *)title content:(NSString *)content cat:(int)cat imgs:(NSString *)imgs tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    if (title) {
        [params setObject:title forKey:@"title"];
    }
    if (content) {
        [params setObject:content forKey:@"content"];
    }
    if (cat) {
        [params setObject:[NSNumber numberWithInt:cat] forKey:@"cat"];
    }
    if (imgs) {
        [params setObject:imgs forKey:@"img"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/topic/send",API_URL] type:2 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)updateTopicWithImgs:(NSArray *)imgs index:(int)index tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (index >= 0) {
        [params setObject:[NSNumber numberWithInt:index] forKey:@"index"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/topic/img",API_URL] type:2 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:imgs withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)publishQuestionWithExpertId:(NSString *)expertId uid:(NSString *)uid title:(NSString *)title content:(NSString *)content overt:(NSString *)overt imgs:(NSString *)imgs tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (expertId) {
        [params setObject:expertId forKey:@"expertid"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    if (title) {
        [params setObject:title forKey:@"title"];
    }
    if (content) {
        [params setObject:content forKey:@"content"];
    }
    if (overt) {
        [params setObject:overt forKey:@"overt"];
    }
    if (imgs) {
        [params setObject:imgs forKey:@"imgs"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/qa/ask",API_URL] type:2 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)updateExpertQuestionWithImgs:(NSArray *)imgs index:(int)index tag:(int)tag{
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (index >= 0) {
        [params setObject:[NSNumber numberWithInt:index] forKey:@"index"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/qa/img",API_URL] type:2 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:imgs withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getQuestionDetailsWithQuestionId:(NSString *)questionId uid:(NSString *)uid  tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (questionId) {
        [params setObject:questionId forKey:@"id"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/qa/detail",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)deleteQuestionWithQuestionId:(NSString *)questionId uid:(NSString *)uid tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (questionId) {
        [params setObject:questionId forKey:@"id"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/qa/del",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

#pragma mark - mine
//我的卡包list
- (BOOL)getCardListWithUid:(NSString *)uid pagenum:(int)page tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:uid forKey:@"userid"];
    if (page > 0 ) {
        [params setObject:[NSNumber numberWithInt:page] forKey:@"pagenum"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/cp/list",API_URL] type:1 parameters:params];
    
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
//卡包详情
- (BOOL)getCardDetailInfoWithUid:(NSString *)uid cid:(NSString *)cid tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:uid forKey:@"userid"];
    [params setObject:cid forKey:@"id"];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/cp/info",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
//领取卡包
- (BOOL)receiveCardWithUid:(NSString *)uid cid:(NSString *)cid tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:uid forKey:@"userid"];
    [params setObject:cid forKey:@"id"];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/cp/receive",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)receiveCardAddInfoWithInfoId:(NSString *)infoId name:(NSString *)name remark:(NSString *)remark tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (infoId) {
        [params setObject:infoId forKey:@"id"];
    }
    if (name) {
        [params setObject:name forKey:@"name"];
    }
    if (remark) {
        [params setObject:remark forKey:@"remark"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/cp/receive/addinfo",API_URL] type:0 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getMyApplyActivityListWithUid:(NSString *)uid page:(int)page tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (page > 0) {
        [params setObject:[NSNumber numberWithInt:page] forKey:@"pagenum"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/activity/myreg",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)getMyCollectActivityListWithUid:(NSString *)uid page:(int)page tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (page > 0) {
        [params setObject:[NSNumber numberWithInt:page] forKey:@"pagenum"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/activity/myfav",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getMyPublishTopicListWithUid:(NSString *)uid page:(int)page tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (page > 0) {
        [params setObject:[NSNumber numberWithInt:page] forKey:@"pagenum"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/topic/mypub",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)getMyCollectTopicListWithUid:(NSString *)uid page:(int)page tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (page > 0) {
        [params setObject:[NSNumber numberWithInt:page] forKey:@"pagenum"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/topic/myfav",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getMyCollectInfoListWithUid:(NSString *)uid page:(int)page tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (page > 0) {
        [params setObject:[NSNumber numberWithInt:page] forKey:@"pagenum"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/info/myfav",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)getMyCollectExpertListWithUid:(NSString *)uid page:(int)page tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (page > 0) {
        [params setObject:[NSNumber numberWithInt:page] forKey:@"pagenum"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/expert/myfav",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)getNoticeMessagesListWithUid:(NSString *)uid page:(int)page tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (page > 0) {
        [params setObject:[NSNumber numberWithInt:page] forKey:@"pagenum"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/notice/list",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getQuestionMessagesListWithUid:(NSString *)uid page:(int)page tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (page > 0) {
        [params setObject:[NSNumber numberWithInt:page] forKey:@"pagenum"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/qa/answers",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

#pragma mark - evaluation
//评测页默认宝宝的信息
- (BOOL)getEvaInfoWithUid:(NSString *)uid tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:uid forKey:@"userid"];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/eva/baby",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

//关键期道具信息和购买链接信息
- (BOOL)getEvaToolWithStage:(int)stage tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSNumber numberWithInt:stage] forKey:@"stage"];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/eva/tool",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getAllEvaHistoryWithBabyId:(NSString *)babyId uid:(NSString *)uid tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (babyId) {
        [params setObject:babyId forKey:@"babyid"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/eva/history",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getStageEvaHistoryWithBabyId:(NSString *)babyId uid:(NSString *)uid stage:(NSString *)stage tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (babyId) {
        [params setObject:babyId forKey:@"babyid"];
    }
    if (uid) {
        [params setObject:uid forKey:@"userid"];
    }
    if (stage) {
        [params setObject:stage forKey:@"stage"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/eva/stage/history",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)activityEastCardWithKabaoid:(NSString*)kabaoid userid:(NSString *)userid eno:(NSString *)eno ekey:(NSString *)ekey tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];

    [params setObject:kabaoid forKey:@"kabaoid"];
    [params setObject:userid forKey:@"userid"];
    [params setObject:eno forKey:@"eno"];
    [params setObject:ekey forKey:@"ekey"];
     NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/cp/acteast",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)getEastCardInfomaitonWithuserid:(NSString *)userid kabaoid:(NSString *)kabaoid tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:userid forKey:@"userid"];
    

    [params setObject:kabaoid forKey:@"kabaoid"];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/cp/geteast",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];

}
- (BOOL)getMotherLookListWithTag:(int)tag{
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/mumLook/list",API_URL] type:1 parameters:nil];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)getOneWeekListWith:(int )cweek Tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSNumber numberWithInt:cweek] forKey:@"cweek"];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/weekExe/list",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getOneWeekScrollviewInfomationWith:(NSString *)userID tag:(int)tag{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:userID forKey:@"userid"];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/weekExe/index",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

#pragma mark 商品系列

//获取商品主页信息 （只有今日上新）
- (BOOL)getShopMainListInfomationWith:(int)tag types:(NSString *)types pageNum:(NSString *)pageNum{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:types forKey:@"types"];
    [params setObject:pageNum forKey:@"pagenum"];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/shopHome/list",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
    
}
//获取商品主页的信息 （选择性输入types）
- (BOOL)getShopMainListInfomationWith:(int)tag types:(NSString *)types{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:types forKey:@"types"];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/shopHome/list",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}


/**
 *  商品系列列表
 *
 */
- (BOOL)getShopSeriousInfomationWithType:(NSString *)type tag:(int)tag category:(NSString *)category pagenum:(NSString *)pagenum{
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:type  forKey:@"type"];
    [params setObject:category forKey:@"category"];
    [params setObject:pagenum forKey:@"pagenum"];
    
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/serie/list",API_URL] type:1 parameters:params];
    
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}


/**
 *  获取商品列表
 */
- (BOOL)getShopListInfoMationWith:(int)tag category:(NSString *)category pagenum:(NSString *)pagenum type:(NSString *)typeStr name:(NSString *)name serieid:(NSString *)serieid{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:typeStr forKey:@"type"];
    [params setObject:category forKey:@"category"];
    [params setObject:pagenum forKey:@"pagenum"];
    if ([name isEqualToString:@""]) {
        
    }else{
        [params setObject:name forKey:@"name"];
    }
    [params setObject:serieid forKey:@"serieid"];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/goods/list",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}


//获取收获地址列表
- (BOOL)getAddressListWithTag:(int)tag userId:(NSString *)userid{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:userid forKey:@"userid"];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/userAddress/list",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

//保存修改地址
- (BOOL)saveEditorAddressWith:(int)tag userid:(NSString *)userid provinceid:(NSString *)provinceid cityid:(NSString *)cityid districtid:(NSString *)districtid name:(NSString *)name phone:(NSString *)phone address:(NSString *)address tel:(NSString *)tel def:(NSString *)def del:(NSString *)del idnum:(NSString *)idnum{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    
    [params setObject:userid forKey:@"userid"];
    [params setObject:provinceid forKey:@"provinceid"];
    [params setObject:cityid forKey:@"cityid"];
    [params setObject:districtid forKey:@"districtid"];
    [params setObject:name forKey:@"name"];
    [params setObject:phone forKey:@"phone"];
    [params setObject:address forKey:@"address"];
    
    if ([tel isEqualToString:@""]) {
    }else{
        [params setObject:tel forKey:@"tel"];
    }
    
    if ([def isEqualToString:@""]) {
    } else {
        [params setObject:def forKey:@"def"];
    }
    
//    if ([del isEqualToString:@"0"]) {
        [params setObject:del forKey:@"del"];
//
//    } else {
//        [params setObject:del forKey:@"del"];
//    }
    
    if([idnum isEqualToString:@""]){
        
    }else{
        [params setObject:idnum forKey:@"id"];
    }
    
    
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/userAddress/addOrUpdateOrDel",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)getShopDetailInfomationWithTag:(int)tag shopId:(NSString *)shopId userId:(NSString *)userId{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:shopId forKey:@"id"];
    if ([userId isEqualToString:@""]) {
        
    }else{
        [params setObject:userId forKey:@"userId"];
    }
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/goods/detail",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}
- (BOOL)refreshShopCarWithTag:(int)tag del:(NSString *)del idNum:(NSString *)idNum num:(NSString *)num userid:(NSString *)userid goodsid:(NSString *)goodsid standard:(NSString *)standard{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:del forKey:@"del"];
    
    if ([idNum isEqualToString:@""]) {
        
    }else{
        [params setObject:idNum forKey:@"id"];
    }
    
    if ([num isEqualToString:@""]) {
        
    }else{
        [params setObject:num forKey:@"num"];
    }
    
    if ([userid isEqualToString:@""]) {
        
    }else{
        [params setObject:userid forKey:@"userid"];
    }
    
    if ([goodsid isEqualToString:@""]) {
        
    }else{
        [params setObject:goodsid forKey:@"goodsid"];
    }
    
    if ([standard isEqualToString:@""]) {
        
    }else{
        [params setObject:standard forKey:@"standard"];
    }

    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/cart/addOrUpdateOrDel",API_URL] type:1 parameters:params];
    
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
    
}
- (BOOL)getShopCarListInfomationWith:(int)tag userid:(NSString *)userid onlygoods:(NSString *)onlygoods pagenum:(NSString *)pagenum{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:userid forKey:@"userid"];
    [params setObject:onlygoods forKey:@"onlygoods"];
    [params setObject:pagenum forKey:@"pagenum"];
    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/cart/list",API_URL] type:1 parameters:params];
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
}

- (BOOL)getCouponListInfomationWith:(int)tag userid:(NSString *)userid pagenum:(NSString *)pagenum goodsids:(NSString *)goodsids{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    
    [params setObject:userid forKey:@"userid"];
    
    if ([pagenum isEqualToString:@""]) {
        
    }else{
        [params setObject:pagenum forKey:@"pagenum"];
    }
    
    if ([goodsids isEqualToString:@""]) {
        
    }else{
        [params setObject:goodsids forKey:@"goodsid"];
    }

    NSDictionary* formatDic = [self getRequestJsonWithUrl:[NSString stringWithFormat:@"%@/coupon/list",API_URL] type:1 parameters:params];
    
    return [self reDirectXECommonWithFormatDic:formatDic withData:nil withTag:tag withTimeout:CONNECT_TIMEOUT error:nil];
    
}
@end
