//
//  ActivityApplyViewCell.m
//  Xiaoer
//
//  Created by KID on 15/2/3.
//
//

#import "ActivityApplyViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ActivityApplyViewCell

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
    
    
    [self.activityImageView sd_setImageWithURL:activityInfo.picUrl placeholderImage:[UIImage imageNamed:@"activity_load_icon"]];
    
    _titleLabel.text = activityInfo.title;
    
    _stateButton.hidden = NO;
    [_stateButton setBackgroundImage:[UIImage imageNamed:@"my_activity_state_bg_gray"] forState:0];
    int status = activityInfo.status;
    if (status == 1) {
        [_stateButton setTitle:@"未发布" forState:0];
    }else if (status == 2){
        [_stateButton setTitle:@"可报名" forState:0];
        [_stateButton setBackgroundImage:[UIImage imageNamed:@"my_activity_state_bg_bule"] forState:0];
    }else if (status == 3){
        [_stateButton setTitle:@"已报名" forState:0];
        [_stateButton setBackgroundImage:[UIImage imageNamed:@"my_activity_state_bg_bule"] forState:0];
    }else if (status == 4){
        [_stateButton setTitle:@"已截止" forState:0];
    }else if (status == 5){
        [_stateButton setTitle:@"未开始" forState:0];
        [_stateButton setBackgroundImage:[UIImage imageNamed:@"my_activity_state_bg_bule"] forState:0];
    }else if (status == 6){
        [_stateButton setTitle:@"已开始" forState:0];
        [_stateButton setBackgroundImage:[UIImage imageNamed:@"my_activity_state_bg_bule"] forState:0];
    }else if (status == 7){
        [_stateButton setTitle:@"已结束" forState:0];
    }else{
        _stateButton.hidden = YES;
    }
}

@end
