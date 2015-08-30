//
//  ToyDetailCollectHeaderView.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/9.
//
//

#import "ToyDetailCollectHeaderView.h"

@implementation ToyDetailCollectHeaderView
- (UILabel *)titleLab{
    if (!_titleLab) {
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, 30)];
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
- (void)awakeFromNib {
    // Initialization code
}
- (void)configureHeaderViewWith:(NSString *)str{
    NSLog(@"str%@",str);
//    self.titleLab.text = str;
}
@end
