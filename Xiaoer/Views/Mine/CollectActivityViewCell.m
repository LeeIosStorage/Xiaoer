//
//  CollectActivityViewCell.m
//  Xiaoer
//
//  Created by KID on 15/2/3.
//
//

#import "CollectActivityViewCell.h"
#import "UIImageView+WebCache.h"

@implementation CollectActivityViewCell

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
    _doctorNameLabel.text = [NSString stringWithFormat:@"%@ %@",_doctorInfo.doctorName,_doctorInfo.title];
    _doctorCollegeLabel.text = doctorInfo.hospital;
}

@end
