//
//  MineTabCell.m
//  Xiaoer
//
//  Created by KID on 15/1/8.
//
//

#import "MineTabCell.h"

@implementation MineTabCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setbottomLineWithType:(int)type{
    //1 为320，0为短线
    if (type == 1) {
        CGRect frame = CGRectMake(-4, 43.5, 328, 1);
        _sepline.frame = frame;
        
    }else if (type == 0){
        CGRect frame = CGRectMake(59, 43, 328 - 59, 1);
        _sepline.frame = frame;
    }
}

@end
