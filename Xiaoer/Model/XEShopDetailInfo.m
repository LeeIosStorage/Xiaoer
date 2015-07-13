//
//  XEShopDetailInfo.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/8.
//
//

#import "XEShopDetailInfo.h"
#import "XEEngine.h"
@implementation XEShopDetailInfo
- (NSString *)resultOrigPric{
    if (self.origPrice) {
        CGFloat orige = [self.origPrice floatValue];
        return [NSString stringWithFormat:@"原价%.2f",orige/100];
    }
    return @"";
}
- (NSString *)resultPrice{
    if (self.price) {
        CGFloat price = [self.price floatValue];
        return [NSString stringWithFormat:@"%.2f",price/100];
    }
    return @"";
}
- (NSURL *)totalImageUrl{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], self.url]];
}
@end
