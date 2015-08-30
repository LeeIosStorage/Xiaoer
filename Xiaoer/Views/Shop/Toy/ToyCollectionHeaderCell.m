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
- (void)configureHeaderCellWith:(XEShopSerieInfo *)info{
    [self.imageView sd_setImageWithURL:[info totalImageUrl] placeholderImage:[UIImage imageNamed:@"shopCellHolder"]];
    self.titleLable.text = info.des;
    self.surplusday.text = [NSString stringWithFormat:@"剩%@天",info.leftDay];
}
@end
