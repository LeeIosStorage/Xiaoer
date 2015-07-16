//
//  XEShopDetailInfo.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/8.
//
//

#import <Foundation/Foundation.h>

@interface XEShopDetailInfo : NSObject
/**
 * 剩余量
 */
@property (nonatomic,strong)NSString *total;
/**
 * 适用月龄
 */
@property (nonatomic,strong)NSString *forAge;
/**
 * 简介
 */
@property (nonatomic,strong)NSString *des;
/**
 * 商品规格的字符串形式
 */
@property (nonatomic,strong)NSString *standard;
/**
 * 状态 0下架 1上架
 */
@property (nonatomic,strong)NSString *status;
/**
 * 所属系列id
 */
@property (nonatomic,strong)NSString *serieId;
/**
 * 开放购买时间
 */
@property (nonatomic,strong)NSString *beginTime;
/**
 * 排序号
 */
@property (nonatomic,strong)NSString *sortNo;
/**
 * 是否推荐 0否 1是
 */
@property (nonatomic,strong)NSString *isRec;
/**
 * 原价单位分
 */
@property (nonatomic,strong)NSString *origPrice;
/**
 * 结束购买时间
 */
@property (nonatomic,strong)NSString *endTime;
/**
 * 类型 1玩具, 2卡券, 3祈福
 */
@property (nonatomic,strong)NSString *type;
/**
 * 图片地址
 */
@property (nonatomic,strong)NSString *url;
/**
 * 材质
 */
@property (nonatomic,strong)NSString *material;
/**
 * 商品唯一标识号
 */
@property (nonatomic,strong)NSString *id;
/**
 * 二级分类（玩具：测评玩具、训练玩具、另购玩具 ；卡券：活动 家政服务； 其他：祈福）
 */
@property (nonatomic,strong)NSString *category;
/**
 * 价格单位分
 */
@property (nonatomic,strong)NSString *price;
/**
 * 销量
 */
@property (nonatomic,strong)NSString *sales;
/**
 * 名称
 */
@property (nonatomic,strong)NSString *name;
/**
 * 品牌
 */
@property (nonatomic,strong)NSString *brand;
/**
 * 功能
 */
@property (nonatomic,strong)NSString *func;
/**
 * 限购数量
 */
@property (nonatomic,strong)NSString *lmt;

/**
 *  运费
 */
@property (nonatomic,strong)NSString *carriage;


/**
 *  供货商ID
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
@end
