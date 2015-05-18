//
//  CardInfoVerifyCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/5/18.
//
//

#import <UIKit/UIKit.h>

@interface CardInfoVerifyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLable;
@property (weak, nonatomic) IBOutlet UITextField *infoField;
- (void)configureCellWith:(NSIndexPath *)indexPath;
@end
