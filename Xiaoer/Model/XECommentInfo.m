//
//  XECommentInfo.m
//  Xiaoer
//
//  Created by KID on 15/1/27.
//
//

#import "XECommentInfo.h"
#import "JSONKit.h"
#import "XEEngine.h"
#import "XEUIUtils.h"

@implementation XECommentInfo

-(void)doSetCommentInfoByJsonDic:(NSDictionary *)dic{
    
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
    
    objectForKey = [dic objectForKey:@"title"];
    if (objectForKey) {
        _title = [objectForKey description];
    }
    
    NSDateFormatter *dateFormatter = [XEUIUtils dateFormatterOFUS];
    objectForKey = [dic objectForKey:@"time"];
    if (objectForKey && [objectForKey isKindOfClass:[NSString class]]) {
        _time = [dateFormatter dateFromString:objectForKey];
    }
    
    objectForKey = [dic arrayObjectForKey:@"imgs"];
    if (objectForKey) {
        _picIds = [NSMutableArray array];
        for (NSString *urlStr in objectForKey) {
            [_picIds addObject:urlStr];
        }
    }
}

-(void)setCommentInfoByJsonDic:(NSDictionary *)dic{
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _commentInfoByJsonDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    _cId = [[dic objectForKey:@"cid"] description];
    _uId = [[dic objectForKey:@"uid"] description];
    
    @try {
        [self doSetCommentInfoByJsonDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####XECommentInfo setCommentInfoByJsonDic exception:%@", exception);
    }
    
    self.jsonString = [_commentInfoByJsonDic JSONString];
    
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
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], @"small" ,picID]];
        if (url) {
            [urls addObject:url];
        }
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
