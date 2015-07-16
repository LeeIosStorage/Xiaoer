//
//  XEOrderInfo.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/14.
//
//

#import <Foundation/Foundation.h>
#import "XEOrderSeriesInfo.h"

@interface XEOrderInfo : NSObject


/**
 *  订单的唯一标识码
 */
@property (nonatomic,strong)NSString *id;

/**
 *  实际支付该订单金额
 */
@property (nonatomic,strong)NSString *money;

/**
 *  下单时间
 */
@property (nonatomic,strong)NSString *orderTime;

/**
 *
 */
@property (nonatomic,strong)NSArray *series;


/**
 *  订单状态（1 待付款 2 已失效 3 已付款（待发货）4 已发货 5 未发货的申请退款（待审核） 6 已发货的申请退款退货（待审核）7 审核退款 8 审核不退款 9 关闭交易）
 */
@property (nonatomic,strong)NSString *status;

/**
 *  订单中购买商品总量
 */
@property (nonatomic,strong)NSString *total;

/**
 *  用户Id
 */
@property (nonatomic,strong)NSString *userId;


/**
 *  运费
 */
@property (nonatomic,strong)NSString *carriage;
/**
 *  母单单号
 */
@property (nonatomic,strong)NSString *orderNo;
- (NSMutableArray *)returnSeriesInfoArray;

- (NSMutableArray *)SeriousReturnGoodsArray;

@end
