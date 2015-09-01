//
//  ExpectSearchCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/8/31.
//
//

#import <UIKit/UIKit.h>

@interface ExpectSearchCell : UITableViewCell
/**
 *  描述
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
/**
 *  类型A
 */
@property (weak, nonatomic) IBOutlet UILabel *typeA;
/**
 *  类型B
 */
@property (weak, nonatomic) IBOutlet UILabel *typeB;

/**
 * 描述
 */
@property (weak, nonatomic) IBOutlet UILabel *desLab;
/**
 *  时间
 */
@property (weak, nonatomic) IBOutlet UILabel *titmeLab;

@end
