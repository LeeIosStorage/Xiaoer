//
//  BabyImpressPayWayOtherCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/25.
//
//

#import "BabyImpressPayWayOtherCell.h"

@implementation BabyImpressPayWayOtherCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)leftBtnTouched:(id)sender {
    UIButton *button = (UIButton *)sender;
    if ([button.currentBackgroundImage isEqual:[UIImage imageNamed:@"arrowheadToDown"]]) {
        [button setBackgroundImage:[UIImage imageNamed:@"babyPayWayUp"] forState:UIControlStateNormal];
        if (self.delegate && [self.delegate respondsToSelector:@selector(ifNumIsZeroWith:)]) {
            [self.delegate ifNumIsZeroWith:YES];
        }
    }else{
        [button setBackgroundImage:[UIImage imageNamed:@"arrowheadToDown"] forState:UIControlStateNormal];
        if (self.delegate && [self.delegate respondsToSelector:@selector(ifNumIsZeroWith:)]) {
            [self.delegate ifNumIsZeroWith:NO];
        }
    }
}
@end
