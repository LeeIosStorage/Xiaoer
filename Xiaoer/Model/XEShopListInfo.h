//
//  XEShopListInfo.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/29.
//
//

#import "BaseModel.h"

@interface XEShopListInfo : BaseModel

/**
 *  是否推荐 1是 0否
 */
@property (nonatomic,strong)NSString *isrec;


/**
 *  排序号 从大到小
*/
@property (nonatomic,strong)NSString *sortno;


/**
*  简介
*/
@property (nonatomic,strong)NSString *des;

/**
 *  series的Id 唯一标识号

*/
@property (nonatomic,strong)NSString *idNum;

/**
 *  价格单位分

*/
@property (nonatomic,strong)NSString *price;

/**
 *  原价单位分
 */
@property (nonatomic,strong)NSString *origPrice;

/**
 *  销量
 */
@property (nonatomic,strong)NSString *sales;

/**
 *  名称
 */
@property (nonatomic,strong)NSString *name;
/**
 *  图片地址
 */
@property (nonatomic,strong)NSString *url;


/**
 *  图片完整url
 */
@property (nonatomic,strong)NSURL *totalImageUrl;


/**
 *  处理之后的原价
 */
@property (nonatomic,strong)NSString *resultOrigPric;
/**
 *  处理之后的现价
 */
@property (nonatomic,strong)NSString *resultPrice;
@end
