//
//  InfomationViewCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/3.
//
//

#import "InfomationViewCell.h"
#define InfoMationCellwidth   self.contentView.frame.size.width/2

@implementation InfomationViewCell
- (UILabel *)titleLable{
    if (!_titleLable) {
        self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(InfoMationCellwidth - 30, InfoMationCellwidth - 20, 60, 40)];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLable];
    }
    
    return _titleLable;
}

- (void)configureInfoMationCellWith:(NSString *)string{
    self.titleLable.text = string;
}
- (void)awakeFromNib {
    // Initialization code
}

@end
