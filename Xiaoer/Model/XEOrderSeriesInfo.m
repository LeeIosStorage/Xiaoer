//
//  XEOrderSeriesInfo.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/15.
//
//

#import "XEOrderSeriesInfo.h"
#import "MJExtension.h"

#import "XEEngine.h"

@implementation XEOrderSeriesInfo
- (NSMutableArray *)returnGoodsInfo{
    NSMutableArray *array = [NSMutableArray array];
    if (self.goodses) {
        for (NSDictionary *dic in self.goodses) {
            XEOrderGoodInfo *info = [XEOrderGoodInfo objectWithKeyValues:dic];
            [array addObject:info];
        }
        return array;
    }
    return nil;
}

- (NSURL *)totalImageUrl{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload/%@", [[XEEngine shareInstance] baseUrl], self.imgUrl]];
}

@end
