//
//  OrderDetailShopCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/16.
//
//

#import "OrderDetailShopCell.h"
#import "UIImageView+WebCache.h"

@implementation OrderDetailShopCell



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)confugireShopCellWith:(XEOrderGoodInfo *)info detailInfo:(XEOrderDetailInfo *)detalInfo{
    CGFloat height = self.contentView.frame.size.height;
    
    if (height == 150) {
        self.topTitle.alpha = 1;
        self.topTypeName.alpha = 1;
        self.setLineA.alpha = 1;
    }
    if (height == 110) {
        self.topTitle.alpha = 0;
        self.topTypeName.alpha = 0;
        self.setLineA.alpha = 0;
    }
    
    for (XEOrderSeriesInfo * seir in [detalInfo detailReturenSeriesInfo]) {
        XEOrderGoodInfo *good = [seir returnGoodsInfo][0];
        if ([info.id isEqualToString:good.id]) {
            self.topTitle.text = seir.title;
        }
    }

    
    [self.mainImg sd_setImageWithURL:[info totalImageUrl] placeholderImage:[UIImage imageNamed:@"shopCellHolder"]];
    self.title.text = info.name;
    self.reNum.text = [NSString stringWithFormat:@"×%@",info.num];
    self.price.text = [info resultPrice];
    self.orignalPric.text = [info resultOrigPric];
    if (info.standard) {
        self.stanader.text = info.standard;
    }else{
        self.stanader.text = @"";
    }
}
@end
