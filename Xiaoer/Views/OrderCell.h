//
//  OrderCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/27.
//
//

#import <UIKit/UIKit.h>



@interface OrderCell : UITableViewCell
/**
 *  申请退款
 */


- (void)configureCellWith:(NSIndexPath *)indexPath addHeaderViewWith:(UIView *)HeaderView;
@end
