//
//  BabyImpressMainCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/8/7.
//
//

#import <UIKit/UIKit.h>

@interface BabyImpressMainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
- (void)configureCellWithDesStr:(NSString *)desStr
                       imageStr:(NSString *)imageStr;

+ (CGFloat)contentHeightWith:(NSString *)desStr;
@end
