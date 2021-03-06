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
    _codeLabel.text = [NSString stringWithFormat:@"抢票码：%@",activityInfo.regcode];
    _codeLabel.hidden = YES;
    if (activityInfo.aType == 1 && activityInfo.status == 3) {
        _codeLabel.hidden = NO;
    }
    
    _stateButton.hidden = NO;
    [_stateButton setBackgroundImage:[UIImage imageNamed:@"card_staus_hover_bg"] forState:0];
    int status = activityInfo.status;//0未发布 1报名未开始 2可报名 3已报名 4已报满  5已截止 6已结束
    if (status == 1) {
        [_stateButton setTitle:@"未开始" forState:0];
    }else if (status == 2){
        [_stateButton setTitle:@"可报名" forState:0];
        [_stateButton setBackgroundImage:[UIImage imageNamed:@"card_status_bg"] forState:0];
    }else if (status == 3){
        [_stateButton setTitle:@"已报名" forState:0];
//        [_stateButton setBackgroundImage:[UIImage imageNamed:@"card_status_bg"] forState:0];
    }else if (status == 4){
        [_stateButton setTitle:@"已报满" forState:0];
    }else if (status == 5){
        [_stateButton setTitle:@"已截止" forState:0];
    }else if (status == 6){
        [_stateButton setTitle:@"已结束" forState:0];
    }else{
        _stateButton.hidden = YES;
    }
}

@end
