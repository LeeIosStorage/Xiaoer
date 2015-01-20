//
//  ExpertListViewCell.m
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import "ExpertListViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ExpertListViewCell

+ (float)heightForDoctorInfo:(XEDoctorInfo *)doctorInfo{
    NSString* topicText = doctorInfo.des;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize topicTextSize = [topicText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-12-86, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    
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
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:_doctorIntroLabel.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize topicTextSize = [_doctorIntroLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-12-86, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    frame.size.height = topicTextSize.height;
    _doctorIntroLabel.frame = frame;
    
    frame = _whiteBgView.frame;
    frame.size.height = self.bounds.size.height - 7;
    _whiteBgView.frame = frame;
}

@end
