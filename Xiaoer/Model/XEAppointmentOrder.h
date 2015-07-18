//
//  XEAppointmentOrder.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/18.
//
//

#import <Foundation/Foundation.h>
#import "XEAppointmentEticker.h"
@interface XEAppointmentOrder : NSObject
/**
 *  电子券有效期开始时间
 */
@property (nonatomic,strong)NSString *beginTime;
/**
 *  购买时间
 */
@property (nonatomic,strong)NSString *buyTime;
/**
 *  电子券号码
 */
@property (nonatomic,strong)NSString *cardNo;
/**
 *  电子券有效期结束时间
 */
@property (nonatomic,strong)NSString *endTime;
/**
 *  电子券列表数组
 */
@property (nonatomic,strong)NSArray *eticketAppointList;
/**
 *  电子券对应商品id
 */
@property (nonatomic,strong)NSString *goodsId;
/**
 *  电子券的唯一标识码
 */
@property (nonatomic,strong)NSString *id;
/**
 *  电子券购买后的有效期长
 */
@property (nonatomic,strong)NSString *len;
/**
 *  所属子订单Id
 */
@property (nonatomic,strong)NSString *orderProviderId;
/**
 *  面值
 */
@property (nonatomic,strong)NSString *price;
/**
 *  供货商Id
 */
@property (nonatomic,strong)NSString *providerId;
/**
 *  剩余使用次数
 */
@property (nonatomic,strong)NSString *remain;
/**
 *  电子券状态 1未绑定 2已绑定 3作废 4已使用
 */
@property (nonatomic,strong)NSString *status;
/**
 *  电子券总共可使用的次数
 */
@property (nonatomic,strong)NSString *total;
/**
 *  用户Id
 */
@property (nonatomic,strong)NSString *userId;

- (NSMutableArray *)appointmentReturenSelfEticker;
@end
