//
//  XEOrderWillPassInfo.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/18.
//
//

#import <Foundation/Foundation.h>

@interface XEOrderWillPassInfo : NSObject
/**
 *  有效期开始时间
 */
@property (nonatomic,strong)NSString *beginTime;
/**
 *  购买时间
 */
@property (nonatomic,strong)NSString *buyTime;
/**
 *  卡号
 */
@property (nonatomic,strong)NSString *cardNo;
/**
 *  失效时间
 */
@property (nonatomic,strong)NSString *endTime;
/**
 *  电子券的唯一标识码
 */
@property (nonatomic,strong)NSString *id;
/**
 *  购买后几天后失效
 */
@property (nonatomic,strong)NSString *len;
/**
 *  价值
 */
@property (nonatomic,strong)NSString *price;
/**
 *  剩余使用次数
 */
@property (nonatomic,strong)NSString *remain;
/**
 *  服务内容
 */
@property (nonatomic,strong)NSString *sercontent;
/**
 *  状态 1未绑定 2已绑定 3作废 4已使用
 */
@property (nonatomic,strong)NSString *status;
/**
 *  总共可使用次数
 */
@property (nonatomic,strong)NSString *total;
/**
 *  类型 1固定 2电子
 */
@property (nonatomic,strong)NSString *type;
@end
