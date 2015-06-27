//
//  ShopActivityCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/25.
//
//

#import "ShopActivityCell.h"

@implementation ShopActivityCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWith:(NSIndexPath *)indexPath{
    self.bottomLab.backgroundColor =  [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
}
@end
