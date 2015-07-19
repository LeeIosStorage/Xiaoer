//
//  XEShopListInfo.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/29.
//
//

#import "XEShopListInfo.h"
#import "XEEngine.h"
@implementation XEShopListInfo
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self == [super initWithDictionary:dictionary]) {
        self.isrec = [dictionary[@"isrec"]stringValue];
        self.id = [dictionary[@"id"]stringValue];
        if ([dictionary[@"sortno"] isKindOfClass:[NSNull class]]) {
            
        }else{
            self.sortno = [dictionary[@"sortno"] stringValue];

        }
        self.des = dictionary[@"des"];
        self.price = [dictionary[@"price"]stringValue];
        self.sales = [dictionary[@"sales"] stringValue];
        self.name = dictionary[@"name"];
        self.origPrice = [dictionary[@"origPrice"] stringValue];
        self.url = dictionary[@"url"];
    }
    return self;
}
- (NSURL *)totalImageUrl{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], self.url]];
}
- (NSString *)resultOrigPric{
    if (self.origPrice) {
        CGFloat orige = [self.origPrice floatValue];
        return [NSString stringWithFormat:@"%.2f",orige/100];
    }
    return @"";
}
- (NSString *)resultPrice{
    if (self.price) {
        CGFloat price = [self.price floatValue];
        return [NSString stringWithFormat:@"￥%.2f",price/100];
    }
    return @"";
}
@end
