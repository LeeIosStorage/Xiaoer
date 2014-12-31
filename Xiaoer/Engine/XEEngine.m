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
#import "NSDictionary+objectForKey.h"

#define CONNECT_TIMEOUT 20

static XEEngine* s_ShareInstance = nil;

@interface XEEngine (){

    //....
    EGOCache* _cacheInstance;
    
    NSDictionary* _globalDefaultConfig;
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
    _uid = nil;
    
    _userInfo = [[XEUserInfo alloc] init];
    _userInfo.uid = _uid;
    
    return self;
}


@end
