//
//  ShopActivityCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/25.
//
//

#import <UIKit/UIKit.h>

#import "XEShopListInfo.h"

@interface ShopActivityCell : UITableViewCell
/**
 *  主图片右上角的图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *addImage;
/**
 *  主图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;

@property (weak, nonatomic) IBOutlet UILabel *shopName;

/**
 *  显示是卡券的小图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *cardImage;
/**
 *  显示描述的lable
*/
@property (weak, nonatomic) IBOutlet UILabel *desLab;

/**
 *  已经支付的人数
 */
@property (weak, nonatomic) IBOutlet UILabel *payedNum;
/**
 *  现价
 */
@property (weak, nonatomic) IBOutlet UILabel *afterPric;
/**
 *  原价
 */
@property (weak, nonatomic) IBOutlet UILabel *fomerPric;
/**
 *  下划线lable
 */
@property (weak, nonatomic) IBOutlet UILabel *lineLab;

- (void)configureCellWith:(ShopActivityCell *)info;
@end
