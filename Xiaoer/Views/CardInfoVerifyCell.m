//
//  CardInfoVerifyCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/5/18.
//
//

#import "CardInfoVerifyCell.h"



@implementation CardInfoVerifyCell


- (void)configureCellWith:(NSArray *)array{
    self.leftLable.text = [array objectAtIndex:0];
    self.infoField.delegate = self;
    if ([[array objectAtIndex:0] isEqualToString:@"卡号"]) {
        self.infoField.placeholder = @"请输入卡号";
    }else if ([[array objectAtIndex:0] isEqualToString:@"密码"]){
        self.infoField.placeholder = @"请输入密码";
    }else{
        self.infoField.text = [array objectAtIndex:1];
    }
}

#pragma mark textField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.delegate || [self.delegate respondsToSelector:@selector(passLeftLableText:textFieldtext:)]) {
        [self.delegate passLeftLableText:self.leftLable.text textFieldtext:self.infoField.text];
    }

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
