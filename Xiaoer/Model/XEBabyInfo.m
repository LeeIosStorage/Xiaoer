//
//  XEBabyInfo.m
//  xiaoer
//
//  Created by KID on 15/3/6.
//
//

#import "XEBabyInfo.h"
#import "XEEngine.h"

@implementation XEBabyInfo

- (void)doSetBabyInfoByJsonDic:(NSDictionary*)dic {
    if ([dic objectForKey:@"name"]) {
        _babyName = [dic objectForKey:@"name"];
    }
    if ([dic stringObjectForKey:@"img"]) {
        _img = [dic stringObjectForKey:@"img"];
    }
    if ([dic objectForKey:@"preimg"]) {
        _preimg = [dic objectForKey:@"preimg"];
    }
    if ([dic objectForKey:@"afterimg"]) {
        _afterimg = [dic objectForKey:@"afterimg"];
    }
    if ([dic objectForKey:@"month"]) {
        _month = [dic objectForKey:@"month"];
    }
    if ([dic objectForKey:@"avatar"]) {
        _avatar = [dic objectForKey:@"avatar"];
    }
    _stage = [[dic objectForKey:@"stage"] intValue];
    _preday = [[dic objectForKey:@"preday"] intValue];
    _afterday = [[dic objectForKey:@"afterday"] intValue];
}

-(void)setBabyInfoByJsonDic:(NSDictionary *)dic{
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _babyInfoByJsonDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    
    @try {
        [self doSetBabyInfoByJsonDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####XEBabyInfo setBabyInfoByJsonDic exception:%@", exception);
    }
    
//    self.jsonString = [_babyInfoByJsonDic JSONString];
    
}

- (NSURL *)babyAvatarUrl {
    if (_avatar == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], _avatar]];
}

//- (NSURL *)mediumAvatarUrl{
//    if (_avatar == nil) {
//        return nil;
//    }
//    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], @"middle", _avatar]];
//}
//
//- (NSURL *)largeAvatarUrl{
//    if (_avatar == nil) {
//        return nil;
//    }
//    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], @"large", _avatar]];
//}

@end
