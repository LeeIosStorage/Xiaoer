//
//  XEAppSubHospital.m
//  Xiaoer
//
//  Created by 王鹏 on 15/9/7.
//
//

#import "XEAppSubHospital.h"

@implementation XEAppSubHospital
- (NSURL *)totalImageUrl{
    if (self.imgUrl) {
    return [ NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], self.imgUrl]];
    }
    return nil;
}
@end
