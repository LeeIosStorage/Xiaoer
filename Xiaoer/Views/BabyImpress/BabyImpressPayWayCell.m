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

- (void)configureCellBtnWith:(NSString *)str{
    self.chooseBtn.titleLabel.font = [UIFont systemFontOfSize:0];
    self.chooseBtn.titleLabel.text = str;
}
- (IBAction)chooseBtnTouched:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    if ([button.titleLabel.text isEqualToString:@"0"]) {
        //未选择
        [button setBackgroundImage:[UIImage imageNamed:@"babyPayWayUse"] forState:UIControlStateNormal];
        if (self.delegate && [self.delegate respondsToSelector:@selector(payWayCellBtnTouchedWithTag:stateStr:)]) {
            [self.delegate payWayCellBtnTouchedWithTag:button.superview.superview.tag stateStr:@"1"];
        }
    }else{
        //已经选择
        [button setBackgroundImage:[UIImage imageNamed:@"babyPayWayNoUse"] forState:UIControlStateNormal];
        if (self.delegate && [self.delegate respondsToSelector:@selector(payWayCellBtnTouchedWithTag:stateStr:)]) {
            [self.delegate payWayCellBtnTouchedWithTag:button.superview.superview.tag stateStr:@"0"];
        }
    }
    
//    if (button.selected == YES) {
//        [button setBackgroundImage:[UIImage imageNamed:@"babyPayWayUse"] forState:UIControlStateNormal];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(payWayCellBtnTouchedWithTag:stateStr:)]) {
//            [self.delegate payWayCellBtnTouchedWithTag:button.superview.superview.tag stateStr:@"1"];
//        }
//
//    }else{
//        [button setBackgroundImage:[UIImage imageNamed:@"babyPayWayNoUse"] forState:UIControlStateNormal];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(payWayCellBtnTouchedWithTag:stateStr:)]) {
//            [self.delegate payWayCellBtnTouchedWithTag:button.superview.superview.tag stateStr:@"0"];
//        }
//
//    }
//    if (button.imageView.image == [UIImage imageNamed:@"babyPayWayNoUse"]) {
//        NSLog(@"babyPayWayNoUse");
//    }
//    if (button.imageView.image == [UIImage imageNamed:@"babyPayWayUse"]) {
//        NSLog(@"babyPayWayUse");
//    }
    
//    if ([button.backgroundColor isEqual:[UIColor redColor]]) {
//        
//        [button  setBackgroundColor:[UIColor purpleColor]];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(payWayCellBtnTouchedWithTag:stateStr:)]) {
//            [self.delegate payWayCellBtnTouchedWithTag:button.superview.superview.tag stateStr:@"1"];
//        }
//    }else{
//        [button  setBackgroundColor:[UIColor redColor]];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(payWayCellBtnTouchedWithTag:stateStr:)]) {
//            [self.delegate payWayCellBtnTouchedWithTag:button.superview.superview.tag stateStr:@"0"];
//        }
//    }
//    button.selected =! button.selected;

    
}
@end
