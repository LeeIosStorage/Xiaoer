//
//  XEMsgInfo.m
//  Xiaoer
//
//  Created by KID on 15/2/4.
//
//

#import "XEMsgInfo.h"
#import "JSONKit.h"
#import "XEUIUtils.h"
#import "XEEngine.h"

@implementation XEMsgInfo

-(void)doSetMsgInfoByJsonDic:(NSDictionary *)dic{
    id objectForKey = [dic objectForKey:@"name"];
    if (objectForKey) {
        _userName = [objectForKey description];
    }
    
    objectForKey = [dic objectForKey:@"title"];
    if (objectForKey) {
        _title = [objectForKey description];
    }
    
    NSDateFormatter *dateFormatter = [XEUIUtils dateFormatterOFUS];
    objectForKey = [dic objectForKey:@"time"];
    if (objectForKey && [objectForKey isKindOfClass:[NSString class]]) {
        _time = [dateFormatter dateFromString:objectForKey];
    }
    
    if ([dic objectForKey:@"istop"]) {
        _isTop = [dic boolValueForKey:@"istop"];
    }
    
    if ([dic objectForKey:@"status"]) {
        _readStatus = [dic boolValueForKey:@"status"];
    }
}
-(void)setMsgInfoByJsonDic:(NSDictionary *)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _msgInfoByJsonDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    _msgId = [[dic objectForKey:@"id"] description];
    
    @try {
        [self doSetMsgInfoByJsonDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####XEMsgInfo setMsgInfoByJsonDic exception:%@", exception);
    }
    
    self.jsonString = [_msgInfoByJsonDic JSONString];
}

- (NSString *)detailsActionUrl{
    if (_msgId == nil) {
        return nil;
    }
//    if ([XEEngine shareInstance].uid == nil) {
//        return nil;
//    }
    
    return [NSString stringWithFormat:@"%@/notice/detail?id=%@&userid=%@", [[XEEngine shareInstance] baseUrl], _msgId,[XEEngine shareInstance].uid];
}

@end
