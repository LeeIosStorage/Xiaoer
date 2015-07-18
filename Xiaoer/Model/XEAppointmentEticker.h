//
//  XEAppointmentEticker.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/18.
//
//

#import <Foundation/Foundation.h>

@interface XEAppointmentEticker : NSObject
/**
 *  预约时间
 */
@property (nonatomic,strong)NSString *appointTime;
/**
 *  电子预约券Id
 */
@property (nonatomic,strong)NSString *eticketId;
/**
 *  电子预约券预约记录唯一标识码
 */
@property (nonatomic,strong)NSString *id;
/**
 *  联系地址
 */
@property (nonatomic,strong)NSString *linkAddress;
/**
 *  联系人姓名
 */
@property (nonatomic,strong)NSString *linkName;
/**
 *  联系手机号
 */
@property (nonatomic,strong)NSString *linkPhone;
/**
 *  服务内容
 */
@property (nonatomic,strong)NSString *sercontent;
/**
 *  用户Id
 */
@property (nonatomic,strong)NSString *userId;
@end
