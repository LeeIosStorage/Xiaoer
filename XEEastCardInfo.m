//
//  XEEastCardInfo.m
//  Xiaoer
//
//  Created by 王鹏 on 15/5/21.
//
//

#import "XEEastCardInfo.h"

@implementation XEEastCardInfo
- (id)initWithDictionary:(NSDictionary *)dictionary{
    if (self == [super initWithDictionary:dictionary]) {
        self.uid = dictionary[@"userId"];
        self.kabaoId = dictionary[@"kabaoId"];
        self.exchangeKey = dictionary[@"exchangeKey"];
        self.exchangeNo = dictionary[@"exchangeNo"];
        self.eastcardNo = dictionary[@"eastcardNo"];
        self.eastcardKey = dictionary[@"eastcardKey"];
        self.activeTime = dictionary[@"activeTime"];
        self.addTime = dictionary[@"addTime"];
    }
    return self;
}
@end
