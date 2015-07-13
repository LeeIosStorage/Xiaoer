//
//  XEShopHomeInfo.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/28.
//
//

#import "BaseModel.h"

@interface XEShopHomeInfo : BaseModel
/**
 *  图片地址
 */
@property (nonatomic,strong)NSString *imgUrl;
/**
 *  shopName的Id 唯一标识号
 */
@property (nonatomic,strong)NSString *id;

/**
 *  对应于objType的类型的对象的id(如 objType == 2 objId=1 则表示 id为1的商品)
 */
@property (nonatomic,strong)NSString *objId;
/**
 *  排序号 大数在前
 */
@property (nonatomic,strong)NSString *sortNo;
/**
 *  关联对象类型 1商品系列 2商品
 */
@property (nonatomic,strong)NSString *objType;
/**
 *  类型 1banner(横幅) 2今日活动 3今日上新
 */
@property (nonatomic,strong)NSString *type;


/**
 *  完整的图片地址
 */
- (NSURL *)totalImageUrl;
@end
