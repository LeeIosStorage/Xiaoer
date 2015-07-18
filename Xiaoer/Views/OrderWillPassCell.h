//
//  OrderWillPassCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/18.
//
//

#import <UIKit/UIKit.h>
#import "XEOrderWillPassInfo.h"
@interface OrderWillPassCell : UITableViewCell
/**
 *  券号
 */

@property (weak, nonatomic) IBOutlet UILabel *cardNum;

/**
 *  失效时间
 */
@property (weak, nonatomic) IBOutlet UILabel *willPassTime;

/**
 *  购买时间
 */
@property (weak, nonatomic) IBOutlet UILabel *buyTime;


/**
 *  预约内容
 */
@property (weak, nonatomic) IBOutlet UILabel *content;
/**
 *  剩余次数
 */
@property (weak, nonatomic) IBOutlet UILabel *remain;

- (void)configureCellWith:(XEOrderWillPassInfo *)info;

@end
