//
//  XECardInfo.m
//  Xiaoer
//
//  Created by KID on 15/2/3.
//
//

#import "XECardInfo.h"
#import "JSONKit.h"
#import "XEEngine.h"

@implementation XECardInfo

-(void)doSetCardInfoByJsonDic:(NSDictionary *)dic{
    
    id objectForKey = [dic objectForKey:@"title"];
    if (objectForKey) {
        _title = objectForKey;
    }
    
    objectForKey = [dic objectForKey:@"id"];
    if (objectForKey) {
        _cid = objectForKey;
    }
    
    objectForKey = [dic objectForKey:@"price"];
    if (objectForKey) {
        _price = objectForKey;
    }

    objectForKey = [dic objectForKey:@"des"];
    if (objectForKey) {
        _des = objectForKey;
    }
    
    objectForKey = [dic objectForKey:@"status"];
    if (objectForKey) {
        _status = [objectForKey intValue];
    }
    
    objectForKey = [dic objectForKey:@"img"];
    if (objectForKey) {
        _img = objectForKey;
    }
    
    objectForKey = [dic objectForKey:@"leftnum"];
    if (objectForKey) {
        _leftNum = [objectForKey intValue];
    }
}

-(void)setCardInfoByJsonDic:(NSDictionary *)dic{
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _cardInfoByJsonDic = [[NSMutableDictionary alloc] initWithDictionary:dic];

    @try {
        [self doSetCardInfoByJsonDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####XECardInfo setCardInfoByJsonDic exception:%@", exception);
    }
    
    self.jsonString = [_cardInfoByJsonDic JSONString];
}

- (NSString *)cardActionUrl{
    if (_cid == nil) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"%@/cp/detail?id=%@", [[XEEngine shareInstance] baseUrl], _cid];
}

@end
