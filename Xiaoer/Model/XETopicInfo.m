//
//  XETopicInfo.m
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import "XETopicInfo.h"
#import "JSONKit.h"
#import "XEEngine.h"

@implementation XETopicInfo

- (void)doSetTopicInfoByJsonDic:(NSDictionary*)dic {
    if ([dic stringObjectForKey:@"title"]) {
        _title = [dic stringObjectForKey:@"title"];
    }
    _clicknum = [dic intValueForKey:@"clicknum"];
    _favnum = [dic intValueForKey:@"favnum"];
    if ([dic objectForKey:@"commentnum"]) {
        _commentnum = [dic intValueForKey:@"commentnum"];
    }
    if ([dic objectForKey:@"uname"]) {
        _uname = [dic stringObjectForKey:@"uname"];
    }
    if ([dic objectForKey:@"utitle"]) {
        _utitle = [dic stringObjectForKey:@"utitle"];
    }
    if ([dic objectForKey:@"istop"]) {
        _isTop = [dic boolValueForKey:@"istop"];
    }
    if ([dic objectForKey:@"time"]) {
        _dateString = [dic stringObjectForKey:@"time"];
    }
}

-(void)setTopicInfoByJsonDic:(NSDictionary *)dic{
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _topicInfoByJsonDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    _tId = [[dic objectForKey:@"id"] description];
    
    @try {
        [self doSetTopicInfoByJsonDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####XETopicInfo setDopicInfoByJsonDic exception:%@", exception);
    }
    
    self.jsonString = [_topicInfoByJsonDic JSONString];
    
}

@end
