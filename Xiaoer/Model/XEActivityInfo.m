//
//  XEActivityInfo.m
//  Xiaoer
//
//  Created by KID on 15/1/16.
//
//

#import "XEActivityInfo.h"
#import "JSONKit.h"
#import "XEUIUtils.h"
#import "XEEngine.h"

@implementation XEActivityInfo

- (void)doSetActivityInfoByJsonDic:(NSDictionary*)dic {
    
    id objectForKey = [dic objectForKey:@"title"];
    if (objectForKey) {
        _title = objectForKey;
    }
    
    objectForKey = [dic objectForKey:@"address"];
    if (objectForKey) {
        _address = objectForKey;
    }
    objectForKey = [dic objectForKey:@"latitude"];
    if (objectForKey) {
        _latitude = [objectForKey floatValue];
    }
    objectForKey = [dic objectForKey:@"longitude"];
    if (objectForKey) {
        _longitude = [objectForKey floatValue];
    }
    
    NSDateFormatter *dateFormatter = [XEUIUtils dateFormatterOFUS];
    objectForKey = [dic objectForKey:@"begintime"];
    if (objectForKey && [objectForKey isKindOfClass:[NSString class]]) {
        _begintime = [dateFormatter dateFromString:objectForKey];
    }
    
    objectForKey = [dic objectForKey:@"endtime"];
    if (objectForKey && [objectForKey isKindOfClass:[NSString class]]) {
        _endtime = [dateFormatter dateFromString:objectForKey];
    }
    
    objectForKey = [dic objectForKey:@"totalnum"];
    if (objectForKey) {
        _totalnum = [objectForKey intValue];
    }
    
    objectForKey = [dic objectForKey:@"status"];
    if (objectForKey) {
        _status = [objectForKey intValue];
    }
    
    objectForKey = [dic objectForKey:@"istop"];
    if (objectForKey) {
        _istop = [objectForKey boolValue];
    }
    
    
    
    
    objectForKey = [dic objectForKey:@"faved"];
    if (objectForKey) {
        _faved = [objectForKey intValue];
    }
    
    objectForKey = [dic objectForKey:@"regnum"];
    if (objectForKey) {
        _regnum = [objectForKey intValue];
    }
    
    objectForKey = [dic objectForKey:@"minnum"];
    if (objectForKey) {
        _minnum = [objectForKey intValue];
    }
    
    objectForKey = [dic objectForKey:@"des"];
    if (objectForKey) {
        _des = objectForKey;
    }
    
    objectForKey = [dic objectForKey:@"phone"];
    if (objectForKey) {
        _phone = objectForKey;
    }
    
    objectForKey = [dic objectForKey:@"contact"];
    if (objectForKey) {
        _contact = objectForKey;
    }
    
    objectForKey = [dic objectForKey:@"url"];
    if (objectForKey && [objectForKey isKindOfClass:[NSString class]]) {
        _picUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], objectForKey]];
    }
    objectForKey = [dic arrayObjectForKey:@"imgs"];
    if (objectForKey) {
        _picIds = [NSMutableArray array];
        for (NSString *urlStr in objectForKey) {
            [_picIds addObject:urlStr];
        }
    }
}

-(void)setActivityInfoByJsonDic:(NSDictionary *)dic{
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _activityInfoByJsonDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    _aId = [[dic objectForKey:@"id"] description];
    
    @try {
        [self doSetActivityInfoByJsonDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####XEActivityInfo setActivityInfoByJsonDic exception:%@", exception);
    }
    
    self.jsonString = [_activityInfoByJsonDic JSONString];
}

- (NSArray *)picURLs{
    NSMutableArray* urls = [[NSMutableArray alloc] init];
    for (NSString* picID in _picIds) {
        [urls addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], picID]]];
    }
    return urls;
}

@end
