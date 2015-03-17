//
//  TicketListViewCell.m
//  Xiaoer
//
//  Created by KID on 15/3/17.
//
//

#import "TicketListViewCell.h"
#import "UIImageView+WebCache.h"
#import "XECommonUtils.h"

@implementation TicketListViewCell

- (void)awakeFromNib {
    // Initialization code
    self.infoImageView.clipsToBounds = YES;
    self.infoImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setActivityInfo:(XEActivityInfo *)activityInfo{
    _activityInfo = activityInfo;
    [self.infoImageView sd_setImageWithURL:activityInfo.picUrl placeholderImage:[UIImage imageNamed:@"recipes_load_icon"]];
    self.titleLabel.text = activityInfo.title;
    _addressLabel.text = activityInfo.address;
    _rushNumLabel.text = [NSString stringWithFormat:@"%d人已抢",activityInfo.totalnum];
    
    CGRect frame = self.titleLabel.frame;
    CGSize textSize = [XECommonUtils sizeWithText:activityInfo.title font:self.titleLabel.font width:SCREEN_WIDTH-165];
    if (textSize.height > 37) {
        textSize.height = 37;
    }
    frame.size.height = textSize.height;
    self.titleLabel.frame = frame;
    
    _rushNumLabel.hidden = YES;
    _rushButton.hidden = YES;
    _rushButton.enabled = NO;
    _stateImageView.hidden = YES;
    _stateImageView.image = [UIImage imageNamed:@""];
    int status = activityInfo.status;//1未发布 2可报名 3已报名 4已报满  5已截止 6已结束
    if (status == 2){
        _rushButton.hidden = NO;
        _rushNumLabel.hidden = NO;
        _rushButton.enabled = YES;
    }else if (status == 3){
        _stateImageView.hidden = NO;
        _stateImageView.image = [UIImage imageNamed:@"ticket_state_has_rush"];
    }else if (status == 4){
        _stateImageView.hidden = NO;
        _stateImageView.image = [UIImage imageNamed:@"ticket_state_full"];
    }else if (status == 5){
        _stateImageView.hidden = NO;
        _stateImageView.image = [UIImage imageNamed:@"ticket_state_close"];
    }else if (status == 6){
        _stateImageView.hidden = NO;
        _stateImageView.image = [UIImage imageNamed:@""];
    }else{
        _rushButton.hidden = NO;
        _rushNumLabel.hidden = NO;
    }
}

@end
