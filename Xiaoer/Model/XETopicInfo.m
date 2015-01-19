//
//  XETopicInfo.m
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import "XETopicInfo.h"
#import "JSONKit.h"

@implementation XETopicInfo

- (void)doSetTopicInfoByJsonDic:(NSDictionary*)dic {
    if ([dic objectForKey:@"title"]) {
        _title = [dic objectForKey:@"title"];
    }
    _clicknum = [[dic objectForKey:@"clicknum"] intValue];
    _favnum = [[dic objectForKey:@"favnum"] intValue];
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
