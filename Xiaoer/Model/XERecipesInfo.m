//
//  XERecipesInfo.m
//  Xiaoer
//
//  Created by KID on 15/1/16.
//
//

#import "XERecipesInfo.h"
#import "JSONKit.h"

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
        _favNum = [dic objectForKey:@"favnum"];
    }
    if ([dic objectForKey:@"clicknum"]) {
        _readNum = [dic objectForKey:@"clicknum"];
    }
    if ([dic objectForKey:@"imgurl"]) {
        _recipesImageUrl = [dic objectForKey:@"imgurl"];
    }
    if ([dic objectForKey:@"istop"]) {
        _isTop = [dic objectForKey:@"istop"];
    }
    
}


@end