//
//  InfomationViewCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/3.
//
//

#import <UIKit/UIKit.h>

@interface InfomationViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//@property (nonatomic,strong)UILabel *titleLable;
- (void)configureInfoMationCellWith:(NSIndexPath *)indexPath;
@end
