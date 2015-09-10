//
//  XEAppOfficeAppointmentInfo.h
//  Xiaoer
//
//  Created by 王鹏 on 15/9/8.
//
//

#import <Foundation/Foundation.h>

#import "XEUIUtils.h"

@interface XEAppOfficeAppointmentInfo : NSObject
/**
 *  剩余名额
 */
@property (nonatomic,strong)NSString *total;
/**
 *  专家坐诊id
 */
@property (nonatomic,strong)NSString *id;
/**
 *  坐诊开始时间
 */
@property (nonatomic,strong)NSString *beginTime;
/**
 *  晓儿价
 */
@property (nonatomic,strong)NSString *xrprice;
/**
 *  门诊名称
 */
@property (nonatomic,strong)NSString *dname;

@property (nonatomic,strong)NSDate *resultBeginTime;

@property (nonatomic,strong)NSString *weekStr;
@end
