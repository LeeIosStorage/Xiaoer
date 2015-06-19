//
//  XEOneWeekInfo.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/15.
//
//

#import "BaseModel.h"

@interface XEOneWeekInfo : BaseModel
@property (nonatomic,strong)NSString *IDNum;
@property (nonatomic,strong)NSString *imageUrl;
@property (nonatomic,strong)NSString *title;
/**
 *  第几周
 */
@property (nonatomic,strong)NSString *cweek;
/**
 *  类型 1评测 2商城 3资讯
 */
@property (nonatomic,strong)NSString *type;
/**
 *  该条每周一练所关联内容的Id
 */
@property (nonatomic,strong)NSString *objid;
/**
 *  简介
 */

@property (nonatomic,strong)NSString *des;
@property (nonatomic,strong)NSURL *totalImageUrl;

@property (nonatomic,strong)NSString *objCat;
@property (nonatomic,strong)NSString *objName;

@end
