//
//  XEOrderGoodInfo.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/15.
//
//

#import "XEOrderGoodInfo.h"
#import "XEEngine.h"
#import "XEDetailEticketsInfo.h"
#import "MJExtension.h"
@implementation XEOrderGoodInfo

- (NSURL *)totalImageUrl{
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], self.url]];
    
}

- (NSString *)resultOrigPric{
    if (self.origPrice) {
        CGFloat orige = [self.origPrice floatValue];
        return [NSString stringWithFormat:@"原价%.2f元",orige/100];
    }
    return @"";
}
- (NSString *)resultPrice{
    if (self.price) {
        CGFloat price = [self.price floatValue];
        return [NSString stringWithFormat:@"%.2f元",price/100];
    }
    return @"";
}
- (NSMutableArray *)goodReturnEticketsArray{
    NSMutableArray *array = [NSMutableArray array];
    if (self.etickets) {
        for (NSDictionary *dic in self.etickets) {
            XEDetailEticketsInfo *info = [XEDetailEticketsInfo objectWithKeyValues:dic];
            [array addObject:info];
        }
        
        return array;
    }
    return nil;
}

@end
