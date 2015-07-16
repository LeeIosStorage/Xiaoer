//
//  XEOrderDetailInfo.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/16.
//
//

#import "XEOrderDetailInfo.h"
#import "XEOrderSeriesInfo.h"
#import "MJExtension.h"
@implementation XEOrderDetailInfo
- (NSMutableArray *)detailReturnAllGoodsesInfo{
    NSMutableArray *array = [NSMutableArray array];
    if ([self detailReturenSeriesInfo]) {
        
        for (XEOrderSeriesInfo *seriousInfo in [self detailReturenSeriesInfo]) {
            NSArray *goodsArr = [seriousInfo returnGoodsInfo];
            for (XEOrderGoodInfo *good in goodsArr) {
                [array addObject:good];
            }
        }
        
        return array;
        
    } else {
        return nil;
    }
}
- (NSMutableArray *)detailReturenSeriesInfo{
    NSMutableArray *array = [NSMutableArray array];
    if (self.series) {
        for (NSDictionary *dic in self.series) {
            XEOrderSeriesInfo *info = [XEOrderSeriesInfo objectWithKeyValues:dic];
            [array addObject:info];
        }
        return array;
    }
    return nil;
}
@end
