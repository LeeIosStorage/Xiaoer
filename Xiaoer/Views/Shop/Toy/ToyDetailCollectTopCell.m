//
//  ToyDetailCollectTopCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/9.
//
//

#import "ToyDetailCollectTopCell.h"
#import "UIImageView+WebCache.h"
@implementation ToyDetailCollectTopCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configureCellWithmodel:(XEShopDetailInfo *)info chooseStr:(NSMutableString *)chooserStr{
    self.imageView.layer.cornerRadius = 10;
    self.imageView.layer.masksToBounds = YES;
    [self.imageView sd_setImageWithURL:info.totalImageUrl placeholderImage:[UIImage imageNamed:@"shopCellHolder"]];
    NSString *price = [NSString stringWithFormat:@"¥%@",info.resultPrice];
    self.priceLab.text = price;
    self.choosedLab.text = chooserStr;
}

- (IBAction)cancleBtnTouched:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(TopCancleBtnTouched)]) {
        [self.delegate TopCancleBtnTouched];
    }
}


@end
