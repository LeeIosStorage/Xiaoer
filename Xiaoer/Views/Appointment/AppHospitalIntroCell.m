//
//  AppHospitalIntroCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/9/7.
//
//

#import "AppHospitalIntroCell.h"
#define introFont 15

@implementation AppHospitalIntroCell
- (UILabel *)introLab{
    if (!_introLab) {
        self.introLab = [[UILabel alloc]init];
        _introLab.numberOfLines = 0;
        _introLab.font = [UIFont systemFontOfSize:introFont];
        [self.contentView addSubview:_introLab];
    }
    return _introLab;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureIntroCellWith:(XEAppHospital *)info hideStr:(NSString *)hideStr {
    /**
     *   0 隐藏 1 不隐藏
     */
    
    self.nameLable.text = @"医院简介";
    if ([hideStr isEqualToString:@"0"])
    {
        self.introLab.hidden = YES;
        self.setLine.hidden = YES;
        
        [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"addRight"] forState:UIControlStateNormal];

    }
    else
    {
        [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"addDown"] forState:UIControlStateNormal];

        self.introLab.hidden = NO;
        self.setLine.hidden = NO;
    }
    self.info = info;
    self.backLable.backgroundColor = LGrayColor;
    self.introLab.text = info.intro;
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:introFont],NSFontAttributeName, nil];
    CGRect rect = [info.intro boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    self.introLab.frame = CGRectMake(15, 40, SCREEN_WIDTH - 30, rect.size.height);
   
}

+ (CGFloat)cellHeightWith:(NSString *)string{
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:introFont],NSFontAttributeName, nil];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height + 50;
}
- (void)configureIntroCellWithSub:(XEAppSubHospital *)info{
    self.nameLable.text = info.name;
    self.backLable.backgroundColor = LGrayColor;
    self.introLab.text = info.des;
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:introFont],NSFontAttributeName, nil];
    CGRect rect = [info.des boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    self.introLab.frame = CGRectMake(15, 40, SCREEN_WIDTH - 30, rect.size.height);
}
- (void)appAppHospitalIntroCellTarget:(id)target action:(SEL)action{
    [self.rightBigBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
@end
