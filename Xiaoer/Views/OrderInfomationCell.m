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
- (void)configurcellwithIndexPath:(NSIndexPath *)indexPath leftStr:(NSString *)leftStr{
    self.textField.delegate = self;
    self.leftLab.text = leftStr;
    
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
            self.rightImg.hidden = YES;
            break;
        default:
            break;
    }
    
    

}

#pragma mark textField delagate


- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.delegate || [self.delegate respondsToSelector:@selector(passOrderInfocellLeftLableText:textFieldtext:)]) {
        [self.delegate passOrderInfocellLeftLableText:self.leftLab.text textFieldtext:self.textField.text];
    }
    
}
@end
