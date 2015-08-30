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

- (void)configureCellWithLeftStr:(NSString *)leftStr model:(XEAddressListInfo *)info indexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 4) {
        self.rightTextField.frame = CGRectMake(125, 10, SCREEN_WIDTH -125, 30);
        self.leftLable.frame = CGRectMake(15, 5, 120, 30);
    }
    switch (indexPath.row) {
        case 0:
            self.rightImage.hidden = YES;
            self.rightTextField.text = info.name;
            
            break;
        case 1:
            self.rightImage.hidden = NO;
            self.rightTextField.userInteractionEnabled = NO;
            if (info.provinceName) {
            self.rightTextField.text = [NSString stringWithFormat:@"%@ %@ %@ ",info.provinceName,info.cityName,info.districtName];
            }

            break;
        case 2:
            self.rightImage.hidden = YES;
            self.rightTextField.text = info.address;
            break;
        case 3:
            self.rightImage.hidden = YES;
            self.rightTextField.text = info.phone;
            self.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 4:
            self.rightImage.hidden = YES;
            if (info.tel) {
                self.rightTextField.text = @"";
            }else{
                self.rightTextField.text = info.tel;
            }
            self.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
            
        default:
            break;
    }
    self.rightTextField.delegate = self;
    self.leftLable.text = leftStr;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    
    if (self.delegate || [self.delegate respondsToSelector:@selector(passLeftLableText:textFieldtext:)]) {
        [self.delegate passLeftLableText:self.leftLable.text textFieldtext:textField.text];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkAddAddressViewPickviewState)]) {
        [self.delegate checkAddAddressViewPickviewState];
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
