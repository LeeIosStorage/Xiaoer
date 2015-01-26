//
//  XEQuestionInfo.m
//  Xiaoer
//
//  Created by KID on 15/1/26.
//
//

#import "XEQuestionInfo.h"
#import "JSONKit.h"

@implementation XEQuestionInfo

- (void)doSetQuestionInfoByJsonDic:(NSDictionary*)dic {
    if ([dic stringObjectForKey:@"title"]) {
        _title = [dic stringObjectForKey:@"title"];
    }
    _clicknum = [dic intValueForKey:@"clicknum"];
    _favnum = [dic intValueForKey:@"favnum"];
    _status = [dic intValueForKey:@"status"];
}

-(void)setTopicInfoByJsonDic:(NSDictionary *)dic{
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _questionInfoByJsonDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    _sId = [[dic objectForKey:@"id"] description];
    
    @try {
        [self doSetQuestionInfoByJsonDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####XEQuestionInfo setQuestionInfoByJsonDic exception:%@", exception);
    }
    
    self.jsonString = [_questionInfoByJsonDic JSONString];
}

@end
