//
//  ShopActivityCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/25.
//
//

#import <UIKit/UIKit.h>

@interface ShopActivityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bottomLab;
- (void)configureCellWith:(NSIndexPath *)indexPath;
@end
