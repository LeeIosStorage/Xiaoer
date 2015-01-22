//
//  ExpertListViewCell.m
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import "ExpertListViewCell.h"
#import "UIImageView+WebCache.h"
#import "XECommonUtils.h"

@implementation ExpertListViewCell

+ (float)heightForDoctorInfo:(XEDoctorInfo *)doctorInfo{
    NSString* topicText = doctorInfo.des;
    
    CGSize topicTextSize = [XECommonUtils sizeWithText:topicText font:[UIFont systemFontOfSize:15] width:SCREEN_WIDTH-12-86];
    
    
    if (topicTextSize.height < 16) {
        topicTextSize.height = 16;
    }
    float height = topicTextSize.height;
    height += 66;
    height += 25;
    if (height < 145) {
        height = 145;
    }
    return height;
}

- (void)awakeFromNib {
    // Initialization code
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2;
    self.avatarImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDoctorInfo:(XEDoctorInfo *)doctorInfo{
    
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:doctorInfo.avatar] placeholderImage:[UIImage imageNamed:@"user_avatar_default"]];
    _doctorNameLabel.text = doctorInfo.doctorName;
    _doctorCollegeLabel.text = doctorInfo.hospital;
    _doctorIntroLabel.text = doctorInfo.des;
    _doctorAgeLabel.text = [NSString stringWithFormat:@"%d岁",doctorInfo.age];
    
    CGRect frame = _doctorIntroLabel.frame;
    CGSize topicTextSize = [XECommonUtils sizeWithText:doctorInfo.des font:_doctorIntroLabel.font width:SCREEN_WIDTH-12-86];
    frame.size.height = topicTextSize.height;
    _doctorIntroLabel.frame = frame;
    
    frame = _whiteBgView.frame;
    frame.size.height = self.bounds.size.height - 7;
    _whiteBgView.frame = frame;
}

@end
