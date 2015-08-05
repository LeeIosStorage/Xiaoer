//
//  XEBabyImpressMonthListInfo.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/31.
//
//

#import <Foundation/Foundation.h>

@interface XEBabyImpressMonthListInfo : NSObject
/**
 *  图片唯一标识号
 */
@property (nonatomic,strong)NSString *id;
/**
 *  对象Id cat=1时表示用户id
 */
@property (nonatomic,strong)NSString *objId;
/**
 *  1 宝宝印象
 */
@property (nonatomic,strong)NSString *cat;
/**
 *  缩略图
 */
@property (nonatomic,strong)NSString *sma;
/**
 *  状态 1涉嫌违规(则展示涉嫌违规图片而非原图)
 */
@property (nonatomic,strong)NSString *status;
/**
 *  原图
 */
@property (nonatomic,strong)NSString *url;
/**
 *  上传时间
 */
@property (nonatomic,strong)NSString *addTime;

@end
