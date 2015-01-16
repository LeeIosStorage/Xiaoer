//
//  XEThemeInfo.m
//  Xiaoer
//
//  Created by KID on 15/1/14.
//
//

#import "XEThemeInfo.h"
#import "JSONKit.h"

@implementation XEThemeInfo

- (void)setThemeInfoByDic:(NSDictionary*)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _themeInfoByJsonDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    _tid = [[dic objectForKey:@"id"] description];
    
    @try {
        [self doSetThemeInfoByJsonDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####XEThemeInfo setThemeInfoByJsonDic exception:%@", exception);
    }
    
    self.jsonString = [_themeInfoByJsonDic JSONString];

}

- (void)doSetThemeInfoByJsonDic:(NSDictionary*)dic {
    if ([dic objectForKey:@"url"]) {
        _themeImageUrl = [dic objectForKey:@"url"];
    }
    if ([dic objectForKey:@"cat"]) {
        _cat = [dic objectForKey:@"cat"];
    }
}

@end
