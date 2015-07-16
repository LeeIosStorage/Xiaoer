//
//  XEOrderInfo.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/14.
//
//

#import "XEOrderInfo.h"
#import "XEEngine.h"

#import "MJExtension.h"

@implementation XEOrderInfo

- (NSMutableArray *)returnSeriesInfoArray{
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
- (NSMutableArray *)SeriousReturnGoodsArray{
    NSMutableArray *array = [NSMutableArray array];
    if ([self returnSeriesInfoArray]) {
        
        for (XEOrderSeriesInfo *seriousInfo in [self returnSeriesInfoArray]) {
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




@end
