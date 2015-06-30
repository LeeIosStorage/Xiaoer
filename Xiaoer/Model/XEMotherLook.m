//
//  XEMotherLook.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/15.
//
//

#import "XEMotherLook.h"
@implementation XEMotherLook
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self == [super initWithDictionary:dictionary]) {
        self.imageUrl = dictionary[@"imgUrl"] ;
        self.IDNum = [dictionary[@"id"] stringValue];
        if ([dictionary[@"objId"] isKindOfClass:[NSNull class]]) {
            self.objid = @"0";
        }else{
            self.objid = dictionary[@"objId"];
        }
        if ([dictionary[@"totalNum"] isKindOfClass:[NSNull class]]) {
            self.totalNum = @"0";
        }else{
            self.totalNum = [dictionary[@"totalNum"] stringValue];
        }
        self.title = dictionary[@"title"];
        self.type = [dictionary[@"type"] stringValue];
    }
    return self;
}
- (NSURL *)totalImageUrl{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], self.imageUrl]];
}

@end
