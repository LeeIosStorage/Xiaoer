//
//  XEDetailEticketsInfo.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/16.
//
//

#import <Foundation/Foundation.h>

@interface XEDetailEticketsInfo : NSObject
/**
 *  电子券编号
 */
@property (nonatomic,strong)NSString *cardNo;
/**
 *  剩余使用次数
 */
@property (nonatomic,strong)NSString *remain;
/**
 *  服务内容
 */
@property (nonatomic,strong)NSString *sercontent;

@end
