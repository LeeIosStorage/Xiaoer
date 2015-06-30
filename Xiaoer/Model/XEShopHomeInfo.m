//
//  XEShopHomeInfo.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/28.
//
//

#import "XEShopHomeInfo.h"
#import "XEEngine.h"
@implementation XEShopHomeInfo
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self == [super initWithDictionary:dictionary]) {
        if ([dictionary[@"imgUrl"] isKindOfClass:[NSNull class]]) {
            self.imgUrl = @"";

        }else{
            self.imgUrl = dictionary[@"imgUrl"];

        }
        self.type = [dictionary[@"type"] stringValue];
        self.sortNo = [dictionary[@"sortNo"] stringValue];
        self.objType = [dictionary[@"objType"] stringValue];
        if ([dictionary[@"objId"] isKindOfClass:[NSNull class]]) {
            
        }else{
            self.objId = [dictionary[@"objId"] stringValue];
        }
        self.IdNum = [dictionary[@"id"] stringValue];
    }
    return self;
}

- (NSURL *)totalImageUrl{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], self.imgUrl]];
}
@end
