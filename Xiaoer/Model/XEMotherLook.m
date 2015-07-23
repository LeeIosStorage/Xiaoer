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
        
        if ([dictionary[@"imgUrl"] isKindOfClass:[NSNull class]]) {
            self.imageUrl = @"";
        }else{
            self.imageUrl = dictionary[@"imgUrl"];
        }
        
        
        if ([dictionary[@"id"] isKindOfClass:[NSNull class]]) {
            self.IDNum = @"";
        }else{
            self.IDNum = [dictionary[@"id"] stringValue];
        }
        
        if ([dictionary[@"objId"] isKindOfClass:[NSNull class]]) {
            self.objid = @"";
        }else{
            self.objid = [dictionary[@"objId"] stringValue];
        }
        if ([dictionary[@"totalNum"] isKindOfClass:[NSNull class]]) {
            self.totalNum = @"0";
        }else{
            self.totalNum = [dictionary[@"totalNum"] stringValue];
        }
        if ([dictionary[@"title"] isKindOfClass:[NSNull class]]) {
            self.title = @"";
        }else{
            self.title = dictionary[@"title"];
        }
        self.type = [dictionary[@"type"] stringValue];
    }
    return self;
}
- (NSURL *)totalImageUrl{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], self.imageUrl]];
}

@end
