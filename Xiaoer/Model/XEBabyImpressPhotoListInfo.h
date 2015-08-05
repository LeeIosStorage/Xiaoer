//
//  XEBabyImpressPhotoListInfo.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/31.
//
//

#import <Foundation/Foundation.h>

@interface XEBabyImpressPhotoListInfo : NSObject
/**
 * 该月照片总量
 */
@property (nonatomic,strong)NSString *total;
/**
 * 缩略图
 */
@property (nonatomic,strong)NSString *sma;
/**
 * 月
 */
@property (nonatomic,strong)NSString *month;
/**
 * 年
 */
@property (nonatomic,strong)NSString *year;

@end
