//
//  XEItemInfo.m
//  xiaoer
//
//  Created by KID on 15/3/9.
//
//

#import "XEItemInfo.h"
#import "XEEngine.h"

@implementation XEItemInfo

- (void)doSetItemInfoByJsonDic:(NSDictionary*)dic {
    if ([dic objectForKey:@"imgurl"]) {
        _imgurl = [dic objectForKey:@"imgurl"];
    }
    if ([dic objectForKey:@"mallurl"]) {
        _mallurl = [dic objectForKey:@"mallurl"];
        if ([_mallurl isEqual:[NSNull null]]) {
            _mallurl = @"";
        }
    }
    if ([dic stringObjectForKey:@"name"]) {
        _name = [dic stringObjectForKey:@"name"];
    }
    if ([dic objectForKey:@"purchase"]) {
        _purchase = [dic boolValueForKey:@"purchase"];
    }
}

-(void)setItemInfoByJsonDic:(NSDictionary *)dic{
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _itemInfoByJsonDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    
    @try {
        [self doSetItemInfoByJsonDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####XEItemInfo setItemInfoByJsonDic exception:%@", exception);
    }
}

- (NSURL *)imageUrl{
    if (_imgurl == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], _imgurl]];
}

@end
