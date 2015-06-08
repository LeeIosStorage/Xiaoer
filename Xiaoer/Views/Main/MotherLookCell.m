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
    if (indexpath.section == 0) {
        CGRect fram = self.titleLab.frame;
        CGFloat height = fram.size.height;
        fram.size.height = height + 30;
        self.numLab.hidden = YES;
        self.numBehindLab.hidden = YES;
        self.titleLab.frame = fram;
        
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
