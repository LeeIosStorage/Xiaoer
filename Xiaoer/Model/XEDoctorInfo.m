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
