//
//  AppHospitalListCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/9/7.
//
//

#import "AppHospitalListCell.h"
#import "UIImageView+WebCache.h"
@implementation AppHospitalListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWith:(XEAppSubHospital *)info{
    self.info = info;
    self.backLab.backgroundColor = LGrayColor;
    self.nameLab.text = info.name;
    self.introLab.text = info.intro;
    self.desLab.text = info.des;
    [self.image sd_setImageWithURL:info.totalImageUrl placeholderImage:[UIImage imageNamed:@"appOffice"]];
    self.image.layer.cornerRadius = self.image.frame.size.width/2;
    self.image.layer.masksToBounds = YES;
    
    self.getIn.layer.cornerRadius = 5;
    self.getIn.layer.masksToBounds = YES;
    
    
}
- (IBAction)getInBtnClick:(id)sender {
    NSLog(@"aqwdqwd  %@",self.info.name);
    if (self.delegate && [self.delegate respondsToSelector:@selector(getInBtnTouchedWith:)]) {
        [self.delegate getInBtnTouchedWith:self.info];
    }
}

@end
