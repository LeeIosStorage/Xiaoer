//
//  ToyListCollectionCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/19.
//
//

#import <UIKit/UIKit.h>
#import "XEShopListInfo.h"


@interface ToyListCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *afterPrice;
@property (weak, nonatomic) IBOutlet UILabel *formerPrice;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
- (void)configureOtherCellWith:(XEShopListInfo *)info;
@end
