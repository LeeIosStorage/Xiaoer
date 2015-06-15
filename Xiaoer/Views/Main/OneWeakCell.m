//
//  OneWeakCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/8.
//
//

#import "OneWeakCell.h"
#import "UIImageView+WebCache.h"
@implementation OneWeakCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWithModel:(XEOneWeekInfo *)model{
    [self.leftImage sd_setImageWithURL:model.totalImageUrl placeholderImage:nil];
    self.title.text = model.title;
    self.belowTitle.text = model.des;
}
@end
