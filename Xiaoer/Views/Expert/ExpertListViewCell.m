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
    
    height = 145;
    return height;
}

- (void)awakeFromNib {
    // Initialization code
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDoctorInfo:(XEDoctorInfo *)doctorInfo{
    _doctorInfo = doctorInfo;
    
    [_avatarImageView sd_setImageWithURL:doctorInfo.smallAvatarUrl placeholderImage:[UIImage imageNamed:@"topic_load_icon"]];
    
    
    float titleLength = [XECommonUtils widthWithText:_doctorInfo.title font:_doctorNameLabel.font lineBreakMode:NSLineBreakByCharWrapping]/16;
    float maxTitleWidth = SCREEN_WIDTH-90-[XECommonUtils widthWithText:_doctorInfo.doctorName font:_doctorNameLabel.font lineBreakMode:NSLineBreakByCharWrapping]-[XECommonUtils widthWithText:[NSString stringWithFormat:@"%d岁",_doctorInfo.age] font:_doctorNameLabel.font lineBreakMode:NSLineBreakByCharWrapping];
    int maxTitleLength = maxTitleWidth/16;
    NSString *title = doctorInfo.title;
    if (titleLength > maxTitleLength) {
        title = [NSString stringWithFormat:@"%@...",[XECommonUtils getHanziTextWithText:doctorInfo.title maxLength:maxTitleLength-1]];
    }
    
    
    _doctorNameLabel.text = [NSString stringWithFormat:@"%@ %@ %d岁",doctorInfo.doctorName,title,doctorInfo.age];
//    _doctorCollegeLabel.text = doctorInfo.hospital;
    _doctorIntroLabel.text = doctorInfo.professional;
    _doctorAgeLabel.text = doctorInfo.hospital;
    
    CGRect frame = _doctorIntroLabel.frame;
    CGSize topicTextSize = [XECommonUtils sizeWithText:doctorInfo.professional font:_doctorIntroLabel.font width:SCREEN_WIDTH-12-86];
    if (topicTextSize.height > 56) {
        topicTextSize.height = 56;
    }
    frame.size.height = topicTextSize.height;
    _doctorIntroLabel.frame = frame;
    
    frame = _whiteBgView.frame;
    frame.size.height = self.bounds.size.height - 7;
    _whiteBgView.frame = frame;
}

@end
