//
//  ToyMainTabCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/18.
//
//

#import "ToyMainTabCell.h"
#import "UIImageView+WebCache.h"
@implementation ToyMainTabCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)configureCellWithModel:(XEShopSerieInfo *)model{
    self.bottomSmalLab.layer.cornerRadius = 5;
    self.bottomSmalLab.layer.borderWidth = 1;
    self.bottomSmalLab.layer.borderColor = [UIColor orangeColor].CGColor;
    self.bottomSmalLab.layer.masksToBounds = YES;
    
    self.bottonLab.layer.cornerRadius = 12;
    self.bottonLab.layer.masksToBounds = YES;
    
    
    [self.mainImage sd_setImageWithURL:[model totalImageUrl] placeholderImage:[UIImage imageNamed:@"shopCellHolder"]];
    
    self.titleLab.text = model.des;
    
    if ([model.tip isEqualToString: @"1"]) {
        self.bottomSmalLab.text = @"NEW";
    }else if ([model.tip isEqualToString:@"2"]){
        self.bottomSmalLab.text = @"HOT";
    }
    
    //剩余几天
    self.dayLable.text = [NSString stringWithFormat:@"剩%@天",model.leftDay];
    
}
@end
