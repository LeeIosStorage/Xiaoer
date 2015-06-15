//
//  XEOneWeekInfo.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/15.
//
//

#import "XEOneWeekInfo.h"
#import "XEEngine.h"
@implementation XEOneWeekInfo
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self == [super initWithDictionary:dictionary]) {
        self.IDNum = [dictionary[@"id"] stringValue];
        self.imageUrl = dictionary[@"imgUrl"];
        self.title = dictionary[@"title"];
        self.cweek = [dictionary[@"cweek"] stringValue];
        self.type = [dictionary[@"type"] stringValue];
        self.objid = [dictionary[@"objId"] stringValue];
        self.des = dictionary[@"des"];
    }
    return self;
}
- (NSURL *)totalImageUrl{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], self.imageUrl]];
}
@end
