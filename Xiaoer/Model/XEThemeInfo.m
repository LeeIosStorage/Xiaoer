//
//  XEThemeInfo.m
//  Xiaoer
//
//  Created by KID on 15/1/14.
//
//

#import "XEThemeInfo.h"
#import "JSONKit.h"
#import "XEEngine.h"

@implementation XEThemeInfo

- (void)setThemeInfoByDic:(NSDictionary*)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _themeInfoByJsonDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    
    @try {
        [self doSetThemeInfoByJsonDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####XEThemeInfo setThemeInfoByJsonDic exception:%@", exception);
    }
    
    self.jsonString = [_themeInfoByJsonDic JSONString];

}

- (void)doSetThemeInfoByJsonDic:(NSDictionary*)dic {
    if ([dic objectForKey:@"id"]) {
        _themeActionUrl = [dic objectForKey:@"id"];
    }
    
    if ([dic objectForKey:@"url"]) {
        _themeImageUrl = [dic objectForKey:@"url"];
    }
    if ([dic objectForKey:@"cat"]) {
        _cat = [dic objectForKey:@"cat"];
    }
}

//- (NSString *)themeActionUrl{
//    if (_tid == nil) {
//        return nil;
//    }
//
//    return [NSString stringWithFormat:@"%@/info/detail?id=%@", [[XEEngine shareInstance] baseUrl], _tid];
//}

+ (NSString*)getThemeImageUrlWithUrl:(NSString*)url size:(int)size{
    
    return [NSString stringWithFormat:@"%@/upload/%d/%@", [[XEEngine shareInstance] baseUrl], size, url];
}

- (NSString*)getThemeImageUrlWithType:(NSString*)type{
    if (_themeImageUrl == nil) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], type, _themeImageUrl];
}

- (NSString *)smallThemeImageUrl {
    if (_themeImageUrl == nil) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], @"small", _themeImageUrl];
}

- (NSString *)mediumThemeImageUrl{
    if (_themeImageUrl == nil) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], @"middle", _themeImageUrl];
}

- (NSString *)largeThemeImageUrl{
    if (_themeImageUrl == nil) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], @"large", _themeImageUrl];
}

- (NSString *)originalThemeImageUrl {
    if (_themeImageUrl == nil) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], _themeImageUrl];
}

- (NSString*)getSmallThemeImageUrl{
    return [self getThemeImageUrlWithType:@"small"];
}

- (NSString*)getMediumThemeImageUrl{
    return [self getThemeImageUrlWithType:@"middle"];
}

- (NSString*)getLargeThemeImageUrl{
    return [self getThemeImageUrlWithType:@"large"];
}


@end
