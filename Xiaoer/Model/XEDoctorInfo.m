//
//  XEDoctorInfo.m
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import "XEDoctorInfo.h"
#import "JSONKit.h"

@implementation XEDoctorInfo

- (void)doSetDoctorInfoByJsonDic:(NSDictionary*)dic {
    if ([dic objectForKey:@"name"]) {
        _doctorName = [dic objectForKey:@"name"];
    }
    if ([dic objectForKey:@"hospital"]) {
        _hospital = [dic objectForKey:@"hospital"];
    }
    if ([dic objectForKey:@"title"]) {
        _title = [dic objectForKey:@"title"];
    }
    if ([dic objectForKey:@"des"]) {
        _des = [dic objectForKey:@"des"];
    }
    if ([dic objectForKey:@"avatar"]) {
        _avatar = [dic objectForKey:@"avatar"];
    }
    _age = [[dic objectForKey:@"age"] intValue];
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

@end
