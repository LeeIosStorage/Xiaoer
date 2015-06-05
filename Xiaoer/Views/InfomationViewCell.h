//
//  InfomationViewCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/3.
//
//

#import <UIKit/UIKit.h>

@interface InfomationViewCell : UICollectionViewCell
@property (nonatomic,strong)UILabel *titleLable;
- (void)configureInfoMationCellWith:(NSString *)string;
@end
