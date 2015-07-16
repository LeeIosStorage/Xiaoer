//
//  XEOrderSeriesInfo.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/15.
//
//

#import <Foundation/Foundation.h>

#import "XEOrderGoodInfo.h"
@interface XEOrderSeriesInfo : NSObject
/**
 *  系列有效时间开始
 */
@property (nonatomic,strong)NSString *beginTime;
/**
 *  简介
 */
@property (nonatomic,strong)NSString *des;
/**
 *  系列有效时间结束
 */
@property (nonatomic,strong)NSString *endTime;
/**
 *   商品
 */
@property (nonatomic,strong)NSArray *goodses;
/**
 *  商品系列唯一标识码
 */
@property (nonatomic,strong)NSString *id;
/**
 *  系列图片
 */
@property (nonatomic,strong)NSString *imgUrl;
/**
 *  限购数量
 */
@property (nonatomic,strong)NSString *lmt;
/**
 *  1hot 2new
 */
@property (nonatomic,strong)NSString *tip;

- (NSMutableArray *)returnGoodsInfo;

- (NSURL *)totalImageUrl;


@end
