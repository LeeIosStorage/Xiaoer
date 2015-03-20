//
//  XEDoctorInfo.m
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import "XEDoctorInfo.h"
#import "JSONKit.h"
#import "XEEngine.h"

@implementation XEDoctorInfo

- (void)doSetDoctorInfoByJsonDic:(NSDictionary*)dic {
    if ([dic objectForKey:@"name"]) {
        _doctorName = [dic objectForKey:@"name"];
        if ([_doctorName isEqual:[NSNull null]]) {
            _doctorName = @"";
        }
    }
    if ([dic stringObjectForKey:@"hospital"]) {
        _hospital = [dic stringObjectForKey:@"hospital"];
    }
    if ([dic objectForKey:@"title"]) {
        _title = [dic objectForKey:@"title"];
    }
    if ([dic objectForKey:@"professional"]) {
        _professional = [[dic objectForKey:@"professional"] description];
    }
    if ([dic objectForKey:@"des"]) {
        _des = [dic objectForKey:@"des"];
        if ([_des isEqual:[NSNull null]]) {
            _des = @"";
        }
    }
    if ([dic objectForKey:@"avatar"]) {
        _avatar = [dic objectForKey:@"avatar"];
    }
    _age = [[dic objectForKey:@"age"] intValue];
    _topicnum = [[dic objectForKey:@"topicnum"] intValue];
    _favnum = [[dic objectForKey:@"favnum"] intValue];
    _faved = [[dic objectForKey:@"faved"] intValue];
    _popularscore = [[dic objectForKey:@"popularscore"] intValue];
}

-(void)setDoctorInfoByJsonDic:(NSDictionary *)dic{
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _doctorInfoByJsonDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    _doctorId = [[dic objectForKey:@"id"] description];
    
    @try {
        [self doSetDoctorInfoByJsonDic:dic];
    }
    @catch (NSException *exception) {
        NSLog(@"####XEDoctorInfo setDoctorInfoByJsonDic exception:%@", exception);
    }
    
    self.jsonString = [_doctorInfoByJsonDic JSONString];
    
}

- (NSURL *)smallAvatarUrl {
    if (_avatar == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], @"small", _avatar]];
}

- (NSURL *)mediumAvatarUrl{
    if (_avatar == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], @"middle", _avatar]];
}

- (NSURL *)largeAvatarUrl{
    if (_avatar == nil) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@/%@", [[XEEngine shareInstance] baseUrl], @"large", _avatar]];
}

@end
