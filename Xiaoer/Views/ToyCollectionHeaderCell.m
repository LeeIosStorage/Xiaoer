//
//  ToyCollectionHeaderCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/19.
//
//

#import "ToyCollectionHeaderCell.h"
#import "UIImageView+WebCache.h"
@implementation ToyCollectionHeaderCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configureHeaderCellWith:(XEShopListInfo *)info leftDay:(NSString *)leftDay{
    [self.imageView sd_setImageWithURL:info.totalImageUrl placeholderImage:[UIImage imageNamed:@"shopCellHolder"]];
    self.titleLable.text = info.name;
    self.surplusday.text = [NSString stringWithFormat:@"剩%@天",leftDay];
}
@end
