//
//  CardInfoVerifyCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/5/18.
//
//

#import "CardInfoVerifyCell.h"



@implementation CardInfoVerifyCell


- (void)configureCellWith:(NSString *)string{
    self.infoField.backgroundColor = [UIColor blackColor];
    self.leftLable.text = string;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
