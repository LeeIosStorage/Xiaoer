//
//  XEQuestionInfo.m
//  Xiaoer
//
//  Created by KID on 15/1/26.
//
//

#import "XEQuestionInfo.h"
#import "JSONKit.h"
#import "XEUIUtils.h"
#import "XEEngine.h"

@implementation XEQuestionInfo

- (void)doSetQuestionInfoByJsonDic:(NSDictionary*)dic {
    if ([dic stringObjectForKey:@"title"]) {
        _title = [dic stringObjectForKey:@"title"];
    }
    _clicknum = [dic intValueForKey:@"clicknum"];
    _favnum = [dic intValueForKey:@"favnum"];
    _status = [dic intValueForKey:@"status"];
    
    id objectForKey = [dic objectForKey:@"content"];
    if (objectForKey) {
        _content = [objectForKey description];
    }
    _userName = [dic stringObjectForKey:@"uname"];
    _expertName = [dic stringObjectForKey:@"name"];
    NSDateFormatter *dateFormatter = [XEUIUtils dateFormatterOFUS];
    objectForKey = [dic objectForKey:@"time"];
    if (objectForKey && [objectForKey isKindOfClass:[NSString class]]) {
        _beginTime = [dateFormatter dateFromString:objectForKey];
    }
    _faved = [dic intValueForKey:@"faved"];
    
    objectForKey = [dic arrayObjectForKey:@"imgs"];
    if (objectForKey) {
        _picIds = [NSMutableArray array];
        for (NSString *urlStr in objectForKey) {
            [_picIds addObject:urlStr];
        }
    }
}

-(void)setQuestionInfoByJsonDic:(NSDictionary *)dic{
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _questionInfoByJsonDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    _sId = [[dic objectForKey:@"id"] description];
    _uId = [[dic objectForKey:@"uid"] description];
    
    @try {
        [self doSetQuestionInfoByJsonDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####XEQuestionInfo setQuestionInfoByJsonDic exception:%@", exception);
    }
    
    self.jsonString = [_questionInfoByJsonDic JSONString];
}

- (NSArray *)picURLs{
    NSMutableArray* urls = [[NSMutableArray alloc] init];
    for (NSString* picID in _picIds) {
        [urls addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], @"small" ,picID]]];
    }
    return urls;
}

- (NSArray *)originalPicURLs{
    NSMutableArray* urls = [[NSMutableArray alloc] init];
    for (NSString* picID in _picIds) {
        [urls addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl],picID]]];
    }
    return urls;
}

@end
