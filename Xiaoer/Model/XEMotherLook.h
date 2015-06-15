//
//  XEMotherLook.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/15.
//
//

#import "BaseModel.h"

@interface XEMotherLook : BaseModel
/**
 * 妈妈必看的ID
 */
@property (nonatomic,strong)NSString *IDNum;
/**
 *  缩略图的地址
 */
@property (nonatomic,strong)NSString *imageUrl;
@property (nonatomic,strong)NSString *title;
/**
 *  类型 1:抢票；2:活动 3:商品
 */
@property (nonatomic,strong)NSString *type;
/**
 *  该条妈妈必看所关联内容的Id
 */
@property (nonatomic,strong)NSString *objid;
/**
 *  总名额数
 */
@property (nonatomic,strong)NSString *totalNum;
@property (nonatomic,strong)NSURL *totalImageUrl;
@end
