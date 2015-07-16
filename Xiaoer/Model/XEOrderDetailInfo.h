//
//  XEOrderDetailInfo.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/16.
//
//

#import <Foundation/Foundation.h>

@interface XEOrderDetailInfo : NSObject
/**
 *  运费
 */
@property (nonatomic,strong)NSString *carriage;
/**
 *  <#Description#>
 */
@property (nonatomic,strong)NSString *id;
/**
 *  <#Description#>
 */
@property (nonatomic,strong)NSString *linkAddress;
/**
 *  <#Description#>
 */
@property (nonatomic,strong)NSString *linkName;
/**
 *  <#Description#>
 */
@property (nonatomic,strong)NSString *linkPhone;
/**
 *  实际支付该订单金额
 */
@property (nonatomic,strong)NSString *money;
/**
 *  子订单号
 */
@property (nonatomic,strong)NSString *orderProviderNo;
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


- (NSMutableArray *)detailReturnAllGoodsesInfo;
- (NSMutableArray *)detailReturenSeriesInfo;
@end
