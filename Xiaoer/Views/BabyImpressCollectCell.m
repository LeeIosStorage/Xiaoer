//
//  BabyImpressCollectCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/25.
//
//

#import "BabyImpressCollectCell.h"

@implementation BabyImpressCollectCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configureCellWith:(UIImage *)image{
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
