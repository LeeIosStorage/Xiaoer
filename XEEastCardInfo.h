//
//  XEEastCardInfo.h
//  Xiaoer
//
//  Created by 王鹏 on 15/5/21.
//
//

#import "BaseModel.h"

@interface XEEastCardInfo : BaseModel
/**
 *  用户ID
 */
@property (nonatomic,strong)NSString *uid;
/**
 *  卡包标示的ID与其他卡区别
 */
@property (nonatomic,strong)NSString *kabaoId;
/**
 *  输入的卡号
 */
@property (nonatomic,strong)NSString *exchangeNo;
/**
 *  输入的卡钥
 */
@property (nonatomic,strong)NSString *exchangeKey;
/**
 *  返回的卡号
 */
@property (nonatomic,strong)NSString *eastcardNo;
/**
 *  返回的卡密码
 */
@property (nonatomic,strong)NSString *eastcardKey;
/**
 *  添加时间
 */
@property (nonatomic,strong)NSString *addTime;
/**
 *  激活时间
 */
@property (nonatomic,strong)NSString *activeTime;

@end
