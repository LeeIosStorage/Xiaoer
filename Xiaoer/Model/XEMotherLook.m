//
//  XEMotherLook.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/15.
//
//

#import "XEMotherLook.h"
#import "XEEngine.h"
@implementation XEMotherLook
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self == [super initWithDictionary:dictionary]) {
        self.imageUrl = dictionary[@"imgUrl"] ;
        self.IDNum = [dictionary[@"id"] stringValue];
        self.title = dictionary[@"totalNum"];
        self.objid = [dictionary[@"objId"] stringValue];
        self.title = dictionary[@"title"];
        self.type = [dictionary[@"type"] stringValue];
    }
    return self;
}
- (NSURL *)totalImageUrl{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], self.imageUrl]];
}

@end
