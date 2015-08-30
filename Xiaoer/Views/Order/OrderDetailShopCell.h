//
//  OrderDetailShopCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/16.
//
//

#import <UIKit/UIKit.h>
#import "XEOrderGoodInfo.h"
#import "XEOrderDetailInfo.h"
#import "XEOrderSeriesInfo.h"
@interface OrderDetailShopCell : UITableViewCell
/**
 *  上方 显示类型
 */
@property (weak, nonatomic) IBOutlet UILabel *topTypeName;
/**
 *  上方的描述
 */
@property (weak, nonatomic) IBOutlet UILabel *topTitle;

/**
 *  主图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *mainImg;

/**
 *  描述
 */
@property (weak, nonatomic) IBOutlet UILabel *title;

/**
 *  规格
 */
@property (weak, nonatomic) IBOutlet UILabel *stanader;
/**
 *  左边 数量
 */
@property (weak, nonatomic) IBOutlet UILabel *leNum;
/**
 *  右边数量
 */
@property (weak, nonatomic) IBOutlet UILabel *reNum;
/**
 *  现价
 */
@property (weak, nonatomic) IBOutlet UILabel *price;
/**
 *  原价
 */
@property (weak, nonatomic) IBOutlet UILabel *orignalPric;

@property (weak, nonatomic) IBOutlet UIImageView *setLineA;
@property (weak, nonatomic) IBOutlet UIImageView *setLineB;

- (void)confugireShopCellWith:(XEOrderGoodInfo *)info
                   detailInfo:(XEOrderDetailInfo *)detalInfo;

@end
