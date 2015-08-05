//
//  BabyImpressMyPicturerCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/25.
//
//

#import "BabyImpressMyPicturerCell.h"
#import "UIImageView+WebCache.h"
@implementation BabyImpressMyPicturerCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWith:(XEBabyImpressPhotoListInfo *)info{
    [self.mainImg sd_setImageWithURL:[NSURL URLWithString:info.sma] placeholderImage:[UIImage imageNamed:@"首页默认头像"]];
    self.monthLab.text = [NSString stringWithFormat:@"%@月份照片",info.month];
    self.numLab.text = [NSString stringWithFormat:@"%@张",info.total];
}

@end
