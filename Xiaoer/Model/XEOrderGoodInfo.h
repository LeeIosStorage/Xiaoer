//
//  XEOrderGoodInfo.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/15.
//
//

#import <Foundation/Foundation.h>

@interface XEOrderGoodInfo : NSObject
/**
 *  运费
 */
@property (nonatomic,strong)NSString *carriage;
/**
 *  商品唯一标识码
 */
@property (nonatomic,strong)NSString *id;
/**
 *  名称
 */
@property (nonatomic,strong)NSString *name;
/**
 *  购买数量
 */
@property (nonatomic,strong)NSString *num;
/**
 *  子订单Id
 */
@property (nonatomic,strong)NSString *orderProviderId;
/**
 *  系列id
 */
@property (nonatomic,strong)NSString *serieId;
/**
 *  购买商品的规格
 */
@property (nonatomic,strong)NSString *standard;
/**
 *  商品状态 0下架 1上架
 */
@property (nonatomic,strong)NSString *status;
/**
 *  类型（1玩具, 2卡券, 3祈福）
 */
@property (nonatomic,strong)NSString *type;
/**
 *  商品图片地址
 */
@property (nonatomic,strong)NSString *url;
/**
 * 是否已使用 0否 1是（全部已使用才视为已使用）
 */
@property (nonatomic,strong)NSString *isUsed;

//卡券数组
@property (nonatomic,strong)NSArray *etickets;


- (NSURL *)totalImageUrl;

/**
 *  原价
 */
@property (nonatomic,strong)NSString *origPrice;
/**
 *  现价
 */
@property (nonatomic,strong)NSString *price;

/**
 *  系列名称
 */
@property (nonatomic,strong)NSString *serieName;
/**
 *  商品服务内容
 */
@property (nonatomic,strong)NSString *sercontent;

/**
 *  返回原价
 * */
- (NSString *)resultOrigPric;


/**
 * 返回现价
 */
- (NSString *)resultPrice;


/**
 *  返回卡券的数组
 */
- (NSMutableArray *)goodReturnEticketsArray;
@end
