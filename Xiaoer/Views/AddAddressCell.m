//
//  AddAddressCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/21.
//
//

#import "AddAddressCell.h"

@implementation AddAddressCell

- (void)awakeFromNib {
    // Initialization code
}
- (UILabel *)Chooselable{
    if (!_Chooselable) {
        self.Chooselable = [[UILabel alloc]init];
    }
    return _Chooselable;
}
- (void)configureCellWith:(NSIndexPath *)indexPath AndString:(NSString *)string{

    if (indexPath.row == 4) {
        self.rightTextField.frame = CGRectMake(125, 10, SCREEN_WIDTH -125, 30);
        self.leftLable.frame = CGRectMake(15, 5, 120, 30);
    }
    switch (indexPath.row) {
        case 0:
            self.rightImage.hidden = YES;

            break;
        case 1:
//            self.rightTextField.hidden = YES;
//            CGRect fram = self.rightTextField.frame;
//            fram = self.Chooselable.frame;
//            [self.contentView addSubview:self.Chooselable];
            self.rightImage.hidden = NO;
            self.rightTextField.userInteractionEnabled = NO;
            break;
        case 2:
            self.rightImage.hidden = YES;

            break;
        case 3:
            self.rightImage.hidden = YES;

            self.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 4:
            self.rightImage.hidden = YES;

            self.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
            
        default:
            break;
    }
    self.rightTextField.delegate = self;
    self.leftLable.text = string;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    
    if (self.delegate || [self.delegate respondsToSelector:@selector(passLeftLableText:textFieldtext:)]) {
        [self.delegate passLeftLableText:self.leftLable.text textFieldtext:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
