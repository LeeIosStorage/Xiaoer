//
//  MotherLookCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/8.
//
//

#import "MotherLookCell.h"

@implementation MotherLookCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configureCellWith:(NSIndexPath *)indexpath{


    self.btn.layer.cornerRadius = 10;
    self.btn.layer.borderWidth = 1;
    self.btn.layer.borderColor = [UIColor colorWithRed:43/255.0 green:186/255.0 blue:230/255.0 alpha:1].CGColor;
    self.btn.tintColor = [UIColor colorWithRed:43/255.0 green:186/255.0 blue:230/255.0 alpha:1];
    self.btn.titleLabel.textColor = [UIColor colorWithRed:43/255.0 green:186/255.0 blue:230/255.0 alpha:1];
    switch (indexpath.section) {
        case 0:
        {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                CGRect fram = self.titleLab.frame;
                CGFloat height = fram.size.height;
                fram.size.height = height + 30;
                self.titleLab.frame = fram;
            });
            self.numLab.hidden = YES;
            self.numBehindLab.hidden = YES;
            [self.btn setTitle:@"去抢票" forState:UIControlStateNormal];
            [self.btn setTitle:@"去抢票" forState:UIControlStateHighlighted];
        }
            break;
         case 1:
        {
            [self.btn setTitle:@"去看看" forState:UIControlStateNormal];
            [self.btn setTitle:@"去看看" forState:UIControlStateHighlighted];
        }
            
            break;
        case 2:
        {
            [self.btn setTitle:@"去逛逛" forState:UIControlStateNormal];
            [self.btn setTitle:@"去逛逛" forState:UIControlStateHighlighted];
        }
        default:
            break;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
