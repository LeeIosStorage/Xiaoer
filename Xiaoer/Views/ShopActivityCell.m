//
//  ShopActivityCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/25.
//
//

#import "ShopActivityCell.h"

#import "UIImageView+WebCache.h"

@implementation ShopActivityCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWith:(XEShopListInfo *)info{
#warning 此处暂时隐藏小图片
    self.addImage.hidden = YES;
    self.mainImage.layer.cornerRadius = 10;
    self.mainImage.layer.masksToBounds = YES;
    [self.mainImage sd_setImageWithURL:info.totalImageUrl placeholderImage:[UIImage imageNamed:@"shopCellHolder"]];
    self.desLab.text = info.des;
    self.shopName.text = [NSString stringWithFormat:@"%@人付款",info.sales];
    self.afterPric.text = info.resultPrice;
    self.fomerPric.text = [NSString stringWithFormat:@"%@元",info.resultOrigPric];
    
    /**
     *  让linelabd的宽度自适应字符串长度
     */
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:self.fomerPric.font forKey:NSFontAttributeName];
    CGSize rect = [self.fomerPric.text sizeWithAttributes:attributes];
    CGRect formerrect = self.lineLab.frame;
    formerrect.size.width = rect.width;
    self.lineLab.frame = formerrect;
    
}

@end
