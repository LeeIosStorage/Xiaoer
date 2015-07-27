//
//  BabyImpressPayWayCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/25.
//
//

#import "BabyImpressPayWayCell.h"

@implementation BabyImpressPayWayCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)chooseBtnTouched:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    if ([button.backgroundColor isEqual:[UIColor redColor]]) {
        
        [button  setBackgroundColor:[UIColor purpleColor]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(payWayCellBtnTouchedWithTag:stateStr:)]) {
            [self.delegate payWayCellBtnTouchedWithTag:button.superview.superview.tag stateStr:@"1"];
        }
    }else{
        [button  setBackgroundColor:[UIColor redColor]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(payWayCellBtnTouchedWithTag:stateStr:)]) {
            [self.delegate payWayCellBtnTouchedWithTag:button.superview.superview.tag stateStr:@"0"];
        }
    }

    
}
@end
