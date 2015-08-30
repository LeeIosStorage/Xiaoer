//
//  ShopHeaderCollectCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/18.
//
//

#import <UIKit/UIKit.h>

@interface ShopHeaderCollectCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerCollectImg;
@property (weak, nonatomic) IBOutlet UILabel *headerCollecLab;

- (void)configuehHeaderCollectCellWith:(NSIndexPath *)indexPath;
@end
