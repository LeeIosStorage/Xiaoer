//
//  BabyImpressCollectCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/25.
//
//

#import "BabyImpressCollectCell.h"
#import "UIButton+WebCache.h"
@implementation BabyImpressCollectCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configureCellWith:(XEBabyImpressMonthListInfo *)info{
    [self.mainBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:info.sma] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"首页默认头像"]];
    
}
- (void)configureCellWithImage:(UIImage *)image{
    [self.mainBtn setBackgroundImage:image forState:UIControlStateNormal];
}
- (IBAction)mainBtnTouched:(id)sender {
    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
    if (self.delegate && [self.delegate respondsToSelector:@selector(babyImpressShowBtnTouchedWith:)]) {
        [self.delegate babyImpressShowBtnTouchedWith:cell.tag];
    }
}

@end
