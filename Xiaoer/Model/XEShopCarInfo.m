//
//  XEShopCarInfo.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/10.
//
//

#import "XEShopCarInfo.h"
#import "XEEngine.h"
@implementation XEShopCarInfo
- (NSString *)resultOrigPric{
    if (self.origPrice) {
        CGFloat orige = [self.origPrice floatValue];
        return [NSString stringWithFormat:@"¥%.2f",orige/100];
    }
    return @"";
}
- (NSString *)resultPrice{
    if (self.price) {
        CGFloat price = [self.price floatValue];
        return [NSString stringWithFormat:@"¥%.2f",price/100];
    }
    return @"";
}
- (NSURL *)totalImageUrl{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], self.url]];
}
- (NSString *)resultCarriage{
    if (self.carriage) {
        CGFloat carriage = [self.carriage floatValue];
        return [NSString stringWithFormat:@"¥%.2f",carriage/100];
    }
    return @"";
}
@end
