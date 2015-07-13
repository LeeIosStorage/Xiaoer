//
//  ToyListCollectionCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/19.
//
//

#import "ToyListCollectionCell.h"

#import "UIImageView+WebCache.h"

@implementation ToyListCollectionCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configureOtherCellWith:(XEShopListInfo *)info{
    
    [self.imageView sd_setImageWithURL:[info totalImageUrl] placeholderImage:[UIImage imageNamed:@"shopCellHolder"]];
    self.titleLab.text = info.name;
    self.afterPrice.text = info.resultPrice;
    self.formerPrice.text = [NSString stringWithFormat:@"￥%@",info.resultOrigPric];
    /**
     *  让linelabd的宽度子使用字符串长度
     */
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:self.formerPrice.font forKey:NSFontAttributeName];
    CGSize rect = [self.formerPrice.text sizeWithAttributes:attributes];
    CGRect formerrect = self.lineLab.frame;
    formerrect.size.width = rect.width;
    self.lineLab.frame = formerrect;

    
}
@end
