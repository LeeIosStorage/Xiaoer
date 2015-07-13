//
//  ToyCollectionHeaderCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/19.
//
//

#import <UIKit/UIKit.h>
#import "XEShopListInfo.h"
#import "XEShopSerieInfo.h"

@interface ToyCollectionHeaderCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *surplusday;
- (void)configureHeaderCellWith:(XEShopSerieInfo *)info;
@end
