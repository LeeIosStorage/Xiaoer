//
//  OrderInfomationCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/2.
//
//

#import "OrderInfomationCell.h"

@implementation OrderInfomationCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configurcellwithIndexPath:(NSIndexPath *)indexPath leftStr:(NSString *)leftStr rightStr:(NSString *)rightStr{
    self.textField.delegate = self;
    self.leftLab.text = leftStr;
    self.textField.text = rightStr;
    switch (indexPath.section) {
        case 0:
            
            break;
            
        case 1:
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 2:
            
            break;
        case 3:
            self.textField.userInteractionEnabled = NO;
            break;
        case 4:
            self.textField.userInteractionEnabled = NO;
            break;
        case 5:
            self.rightImg.hidden = YES;
            self.textField.userInteractionEnabled = NO;
            break;
        default:
            break;
    }
    
    

}

#pragma mark textField delagate


- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%@  %ld",textField.superview.superview,textField.superview.superview.tag);
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    if (self.delegate || [self.delegate respondsToSelector:@selector(passOrderInfocellLeftLableText:textFieldtext:textFieldTag:)]) {
        [self.delegate passOrderInfocellLeftLableText:self.leftLab.text textFieldtext:self.textField.text textFieldTag:cell.tag];
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkOrderInfomationPickerViewState)]) {
        [self.delegate checkOrderInfomationPickerViewState];
    }
}
@end
