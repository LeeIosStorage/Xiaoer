//
//  XECouponsInfo.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/12.
//
//

#import <Foundation/Foundation.h>

@interface XECouponsInfo : NSObject
/**
 *  优惠券号
 */
@property (nonatomic,strong)NSString *cardNo;
/**
 *  优惠券唯一标识
 */
@property (nonatomic,strong)NSString *id;
/**
 *  抵用价格（分）
 */
@property (nonatomic,strong)NSString *price;
/**
 *  优惠券状态（1未绑定 2已绑定 3作废 4已使用）
 */
@property (nonatomic,strong)NSString *status;
/**
 *  优惠券适用（如果type=1则表示适用系列，如果type=2则表示适用商品）id
 */
@property (nonatomic,strong)NSString *objId;
/**
 *  供货商Id
 */
@property (nonatomic,strong)NSString *providerId;
/**
 *  优惠券适用类型 1系列 2商品
 */
@property (nonatomic,strong)NSString *type;
/**
 *  使用时间
 */
@property (nonatomic,strong)NSString *useTime;
/**
 *  子订单Id
 */
@property (nonatomic,strong)NSString *orderProviderId;
/**
 *  商品id
 */
@property (nonatomic,strong)NSString *goodsId;

@end
