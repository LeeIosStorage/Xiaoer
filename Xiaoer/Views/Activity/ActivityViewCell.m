//
//  ActivityViewCell.m
//  Xiaoer
//
//  Created by KID on 15/1/16.
//
//

#import "ActivityViewCell.h"
#import "XEUIUtils.h"
#import "UIImageView+WebCache.h"

@implementation ActivityViewCell

- (void)awakeFromNib {
    // Initialization code
    self.activityImageView.clipsToBounds = YES;
    self.activityImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setActivityInfo:(XEActivityInfo *)activityInfo{
    _activityInfo = activityInfo;
    
    
    [self.activityImageView sd_setImageWithURL:activityInfo.picUrl placeholderImage:[UIImage imageNamed:@"activity_pic_default"]];
    
    _titleLabel.text = activityInfo.title;
//    XELog(@"_activityInfo.begintime%@",_activityInfo.begintime);
    _dateAndAddressLabel.text = [NSString stringWithFormat:@"%@ %@",[XEUIUtils dateDiscriptionFromDate:_activityInfo.begintime],activityInfo.address];
    _totalnumLabel.text = [NSString stringWithFormat:@"%d人",activityInfo.totalnum];
    
    _statusLabel.hidden = NO;
    int status = activityInfo.status;
    if (status == 1) {
        _statusLabel.text = @"未发布";
    }else if (status == 2){
        _statusLabel.text = @"可报名";
    }else if (status == 3){
        _statusLabel.text = @"已报名";
    }else if (status == 4){
        _statusLabel.text = @"已截止";
    }else if (status == 5){
        _statusLabel.text = @"未开始";
    }else if (status == 6){
        _statusLabel.text = @"已开始";
    }else if (status == 7){
        _statusLabel.text = @"已结束";
    }else{
        _statusLabel.hidden = YES;
    }
}

@end
