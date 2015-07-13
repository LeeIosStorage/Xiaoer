//
//  XEShopSerieInfo.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/28.
//
//

#import "XEShopSerieInfo.h"

@implementation XEShopSerieInfo
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self == [super initWithDictionary:dictionary]) {
        self.imgUrl = dictionary[@"imgUrl"];
        self.des = dictionary[@"des"];
        self.title = dictionary[@"title"];
        self.beginTime = dictionary[@"beginTime"] ;
        self.endTime = dictionary[@"endTime"] ;
        self.tip = [dictionary[@"tip"] stringValue];
        self.lmt = [dictionary[@"lmt"] stringValue];
        self.id = [dictionary[@"id"] stringValue];
        self.leftDay = [dictionary[@"leftDay"] stringValue];
    }
    return self;
}
- (NSURL *)totalImageUrl{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], self.imgUrl]];
}
@end
