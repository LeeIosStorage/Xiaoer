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
#import "XEUIUtils.h"

@implementation XETopicInfo

- (void)doSetTopicInfoByJsonDic:(NSDictionary*)dic {
    if ([dic stringObjectForKey:@"title"]) {
        _title = [dic stringObjectForKey:@"title"];
    }
    _clicknum = [dic intValueForKey:@"clicknum"];
    _favnum = [dic intValueForKey:@"favnum"];
    _cat = [dic intValueForKey:@"cat"];
    
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
    if ([dic objectForKey:@"imgnum"]) {
        _imgnum = [dic intValueForKey:@"imgnum"];
    }
    NSDateFormatter *dateFormatter = [XEUIUtils dateFormatterOFUS];
    if ([dic objectForKey:@"time"] && [[dic objectForKey:@"time"] isKindOfClass:[NSString class]]) {
        _time = [dateFormatter dateFromString:[dic objectForKey:@"time"]];
    }
    
    id objectForKey = [dic objectForKey:@"content"];
    if (objectForKey) {
        _content = [objectForKey description];
    }
    
    objectForKey = [dic objectForKey:@"name"];
    if (objectForKey) {
        _userName = [objectForKey description];
    }
    
    objectForKey = [dic objectForKey:@"avatar"];
    if (objectForKey) {
        _avatar = [objectForKey description];
    }
    
    objectForKey = [dic objectForKey:@"utitle"];
    if (objectForKey) {
        _utitle = [objectForKey description];
    }
    
    objectForKey = [dic objectForKey:@"faved"];
    if (objectForKey) {
        _faved = [objectForKey intValue];
    }
    
    objectForKey = [dic arrayObjectForKey:@"imgs"];
    if (objectForKey) {
        _picIds = [NSMutableArray array];
        for (NSString *urlStr in objectForKey) {
            [_picIds addObject:urlStr];
        }
    }
}

-(void)setTopicInfoByJsonDic:(NSDictionary *)dic{
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _topicInfoByJsonDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    _tId = [[dic objectForKey:@"id"] description];
    _uId = [[dic objectForKey:@"uid"] description];
    
    @try {
        [self doSetTopicInfoByJsonDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####XETopicInfo setDopicInfoByJsonDic exception:%@", exception);
    }
    
    self.jsonString = [_topicInfoByJsonDic JSONString];
    
}

- (NSURL *)smallAvatarUrl {
    if (_avatar == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], @"small", _avatar]];
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
