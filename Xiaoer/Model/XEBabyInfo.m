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
    if ([dic objectForKey:@"id"]) {
        _babyId = [dic objectForKey:@"id"];
    }
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
    if ([dic objectForKey:@"content"]) {
        _content = [dic objectForKey:@"content"];
    }
    if ([dic objectForKey:@"precontent"]) {
        _precontent = [dic objectForKey:@"precontent"];
    }
    if ([dic objectForKey:@"aftercontent"]) {
        _aftercontent = [dic objectForKey:@"aftercontent"];
    }
    if ([dic objectForKey:@"stagestatus"]) {
        _status = [dic boolValueForKey:@"stagestatus"];
    }
    if ([dic objectForKey:@"prestagestatus"]) {
        _pStatus = [dic boolValueForKey:@"prestagestatus"];
    }
    if ([dic objectForKey:@"afterstagestatus"]) {
        _aStatus = [dic boolValueForKey:@"afterstagestatus"];
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

- (NSURL *)smallAvatarUrl {
    if (_avatar == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], @"small", _avatar]];
}

- (NSURL *)originalAvatarUrl {
    if (_avatar == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], _avatar]];
}

- (NSURL *)imgUrl{
    if (_img == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], _img]];
}

- (NSURL *)preimgUrl{
    if (_preimg == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], _preimg]];
}

- (NSURL *)afterimgUrl{
    if (_afterimg == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], _afterimg]];
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
