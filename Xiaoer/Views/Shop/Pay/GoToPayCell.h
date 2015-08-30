//
//  GoToPayCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/21.
//
//

#import <UIKit/UIKit.h>

@interface GoToPayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightDescribe;
- (void)configureCellWith:(NSIndexPath *)indexpath;
@end
