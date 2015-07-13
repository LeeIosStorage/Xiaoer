//
//  XEShopSerieInfo.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/28.
//
//

#import "BaseModel.h"

@interface XEShopSerieInfo : BaseModel

/**
 *  图片地址
 */
@property (nonatomic,strong)NSString *imgUrl;

/**
 *  简介
 */
@property (nonatomic,strong)NSString *des;

/**
 *  标题
 */
@property (nonatomic,strong)NSString *title;

/**
 *  开始时间
 */
@property (nonatomic,strong)NSString *beginTime;

/**
 *  结束时间
 */
@property (nonatomic,strong)NSString *endTime;

/**
 *  标识 1 new 2 hot
 */
@property (nonatomic,strong)NSString *tip;

/**
 *  限购次数
 */
@property (nonatomic,strong)NSString *lmt;
/**
 *  series的Id 唯一标识号
 */
@property (nonatomic,strong)NSString *id;

/**
 *  完整的图片地址
 */
- (NSURL *)totalImageUrl;

/**
 *  剩余时间
 */
@property (nonatomic,strong)NSString *leftDay;


@end
