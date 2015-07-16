//
//  XEShopCarInfo.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/10.
//
//

#import <Foundation/Foundation.h>

@interface XEShopCarInfo : NSObject
/**
 *  购物车的唯一标识码
 */
@property (nonatomic,strong)NSString *id;
/**
 *  商品Id
 */
@property (nonatomic,strong)NSString *goodsId;
/**
 *  数量
 */
@property (nonatomic,strong)NSString *num;
/**
 *  现价
 */
@property (nonatomic,strong)NSString *price;
/**
 *  
 */
@property (nonatomic,strong)NSString *orderNo;
/**
 *  购物车内所选商品规格
 */
@property (nonatomic,strong)NSString *standard;
/**
 *  系列Id
 */
@property (nonatomic,strong)NSString *serieId;
/**
 *  商品名称
 */
@property (nonatomic,strong)NSString *name;
/**
 *  用户Id
 */
@property (nonatomic,strong)NSString *userId;
/**
 *  原价
 */
@property (nonatomic,strong)NSString *origPrice;
/**
 *  该商品的规格
 */
@property (nonatomic,strong)NSString *goodsStandard;
/**
 *  商品图片
 */
@property (nonatomic,strong)NSString *url;
/**
 *  添加时间
 */
@property (nonatomic,strong)NSString *addTime;
/**
 *  运费
 */
@property (nonatomic,strong)NSString *carriage;
/**
 *  供货商id
 */
@property (nonatomic,strong)NSString *providerId;

/**
 *  返回原价
 * */
- (NSString *)resultOrigPric;


/**
 * 返回现价
 */
- (NSString *)resultPrice;
/**
 *  返回图片完成的地址
 */
- (NSURL *)totalImageUrl;
/**
 *  返回运费
 */
- (NSString *)resultCarriage;
@end
