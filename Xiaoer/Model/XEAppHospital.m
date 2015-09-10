//
//  XEAppHospital.m
//  Xiaoer
//
//  Created by 王鹏 on 15/9/7.
//
//

#import "XEAppHospital.h"
#import "XEAppSubHospital.h"

@implementation XEAppHospital
- (NSArray *)subHospital{
    if (self.hospitalDepartments) {
        NSMutableArray *sub = [NSMutableArray array];
        for (NSDictionary *dic in self.hospitalDepartments) {
            XEAppSubHospital *subHos = [XEAppSubHospital objectWithKeyValues:dic];
            [sub addObject:subHos];
            
        }
        return sub;
    }
    return nil;
}

@end
