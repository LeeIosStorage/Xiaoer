//
//  OrderApplyReimburseCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/3.
//
//

#import <UIKit/UIKit.h>

@interface OrderApplyReimburseCell : UITableViewCell
/**
 *  左边的描述
 */
@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
/**
 *  中间的具体描述
 */
@property (weak, nonatomic) IBOutlet UILabel *desLab;
/**
 *  右边的选择按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
- (void)configureCellWith:(NSIndexPath *)indexPath
                  desText:(NSString *)desText;
@end
