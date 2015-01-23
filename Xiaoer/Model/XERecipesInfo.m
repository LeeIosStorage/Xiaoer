//
//  XERecipesInfo.m
//  Xiaoer
//
//  Created by KID on 15/1/16.
//
//

#import "XERecipesInfo.h"
#import "JSONKit.h"
#import "XEEngine.h"

@implementation XERecipesInfo

- (void)setRecipesInfoByDic:(NSDictionary*)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _recipesInfoByJsonDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    _rid = [[dic objectForKey:@"id"] description];
    
    @try {
        [self doSetUserInfoByJsonDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####XERecipesInfo setRecipesInfoByJsonDic exception:%@", exception);
    }
    
    self.jsonString = [_recipesInfoByJsonDic JSONString];
    
}

- (void)doSetUserInfoByJsonDic:(NSDictionary*)dic {
    if ([dic objectForKey:@"title"]) {
        _title = [dic objectForKey:@"title"];
    }
    if ([dic objectForKey:@"favnum"]) {
        _favNum = [dic intValueForKey:@"favnum"];
    }
    if ([dic objectForKey:@"clicknum"]) {
        _readNum = [dic intValueForKey:@"clicknum"];
    }
    if ([dic objectForKey:@"imgurl"]) {
        _recipesImageUrl = [dic objectForKey:@"imgurl"];
    }
    if ([dic objectForKey:@"istop"]) {
        _isTop = [dic boolValueForKey:@"istop"];
    }
    
}

- (NSString *)recipesActionUrl{
    if (_rid == nil) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"%@/info/detail?id=%@", [[XEEngine shareInstance] baseUrl], _rid];
}

+ (NSString*)getRecipesUrlWithRecipes:(NSString*)recipes size:(int)size{
    
    return [NSString stringWithFormat:@"%@/upload/%d/%@", [[XEEngine shareInstance] baseUrl], size, recipes];
}

- (NSString*)getRecipesUrlWithType:(NSString*)type{
    if (_recipesImageUrl == nil) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], type, _recipesImageUrl];
}

- (NSURL *)smallRecipesImageUrl {
    if (_recipesImageUrl == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], @"small", _recipesImageUrl]];
}

- (NSURL *)mediumRecipesImageUrl{
    if (_recipesImageUrl == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], @"middle", _recipesImageUrl]];
}

- (NSURL *)largeRecipesImageUrl{
    if (_recipesImageUrl == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], @"large", _recipesImageUrl]];
}

- (NSURL *)originalRecipesImageUrl {
    if (_recipesImageUrl == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], _recipesImageUrl]];
}

- (NSString*)getSmallRecipesImageUrl{
    return [self getRecipesUrlWithType:@"small"];
}

- (NSString*)getMediumRecipesImageUrl{
    return [self getRecipesUrlWithType:@"middle"];
}

- (NSString*)getLargeRecipesImageUrl{
    return [self getRecipesUrlWithType:@"large"];
}

@end
