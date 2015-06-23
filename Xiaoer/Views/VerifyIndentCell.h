//
//  VerifyIndentCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/23.
//
//

#import <UIKit/UIKit.h>

@interface VerifyIndentCell : UITableViewCell
- (void)configureCellWith:(UIView *)view andIndesPath:(NSIndexPath *)indexPath;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIImageView *imageVie;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic,strong)UILabel *describe;
@end
