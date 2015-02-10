//
//  XECateTopicViewCell.m
//  Xiaoer
//
//  Created by KID on 15/1/28.
//
//

#import "XECateTopicViewCell.h"
#import "XECommonUtils.h"
#import "XEUIUtils.h"
#import "UIImageView+WebCache.h"

@implementation XECateTopicViewCell

+ (float)heightForTopicInfo:(XETopicInfo *)topicInfo{
//    NSString* topicText = topicInfo.title;
//    if (!topicText) {
//        topicText = @"";
//    }
//    CGSize topicTextSize = [XECommonUtils sizeWithText:topicText font:[UIFont systemFontOfSize:15] width:SCREEN_WIDTH-11-26];
//    
//    if (topicTextSize.height < 16) {
//        topicTextSize.height = 16;
//    }
//    float height = topicTextSize.height;
//    height += 68;
//    return height;
    return 70;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setTopicInfo:(XETopicInfo *)topicInfo{
    _topicInfo = topicInfo;
    self.nickNameLabel.text = topicInfo.uname;
    self.titleLabel.text = topicInfo.utitle;
    self.topicTitleLabel.text = topicInfo.title;
    if (topicInfo.cat == 1) {
        self.topicTitleLabel.text = [NSString stringWithFormat:@"【养育】%@",self.topicTitleLabel.text];
    }else if (topicInfo.cat == 2) {
        self.topicTitleLabel.text = [NSString stringWithFormat:@"【营养】%@",self.topicTitleLabel.text];
    }else if (topicInfo.cat == 3) {
        self.topicTitleLabel.text = [NSString stringWithFormat:@"【入园】%@",self.topicTitleLabel.text];
    }else if (topicInfo.cat == 4) {
        self.topicTitleLabel.text = [NSString stringWithFormat:@"【心理】%@",self.topicTitleLabel.text];
    }
    if (topicInfo.isRec) {
        self.hotLabel.hidden = NO;
        self.hotLabel.layer.cornerRadius = 2;
        self.hotLabel.clipsToBounds = YES;
        self.topicTitleLabel.text = [NSString stringWithFormat:@"      %@",self.topicTitleLabel.text];
    }else{
        self.hotLabel.hidden = YES;
    }
    
    CGSize textSize = [XECommonUtils sizeWithText:self.topicTitleLabel.text font:self.topicTitleLabel.font width:self.topicTitleLabel.frame.size.width];
        
    CGRect frame = self.picImage.frame;
    CGRect frame2 = self.topicTitleLabel.frame;
    if (textSize.height < 18) {
//         frame.origin.x = self.topicTitleLabel.frame.origin.x + textSize.width + 5;
    }else {
//        frame.origin.x = [XECommonUtils widthWithText:self.topicTitleLabel.text font:self.topicTitleLabel.font lineBreakMode:1] - self.topicTitleLabel.frame.size.width + self.topicTitleLabel.frame.origin.x + 5 - (SCREEN_WIDTH==320?0:(SCREEN_WIDTH - 320 - 10));
//        frame.origin.y = frame.origin.y + 8;
        frame2.origin.y = frame2.origin.y ;
    }
    self.picImage.frame = frame;
    self.topicTitleLabel.frame = frame2;
    
    if (topicInfo.imgnum > 0) {
        self.picImage.hidden = NO;
        self.picImage.layer.cornerRadius = 2;
        self.picImage.clipsToBounds = YES;
    }else{
        self.picImage.hidden = YES;
    }
    
    frame = self.nickNameLabel.frame;
    frame.size.width = [XECommonUtils widthWithText:self.nickNameLabel.text font:self.nickNameLabel.font lineBreakMode:self.nickNameLabel.lineBreakMode];
    self.nickNameLabel.frame = frame;
    
    frame = self.titleLabel.frame;
    frame.origin.x = self.nickNameLabel.frame.origin.x + self.nickNameLabel.frame.size.width + 10;
    self.titleLabel.frame = frame;
    
//    [self.commentLabel setTitle:[NSString stringWithFormat:@" %d",topicInfo.favnum] forState:0];
//    [self.collectLabel setTitle:[NSString stringWithFormat:@" %d",topicInfo.commentnum] forState:0];
//    if (![topicInfo.smallAvatarUrl isEqual:[NSNull null]]) {
//        [self.avatarImageView sd_setImageWithURL:topicInfo.smallAvatarUrl placeholderImage:[UIImage imageNamed:@"topic_avatar_icon"]];
//    }else{
//        [self.avatarImageView sd_setImageWithURL:nil];
//        [self.avatarImageView setImage:[UIImage imageNamed:@"topic_avatar_icon"]];
//    }
//    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2;
//    self.avatarImageView.layer.masksToBounds = YES;
//    self.avatarImageView.clipsToBounds = YES;
//    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
//    if (_topicInfo.isTop) {
//        self.topImageView.hidden = NO;
//        [self.topImageView setImage:[UIImage imageNamed:@"info_top_icon"]];
//    }else{
//        self.topImageView.hidden = YES;
//    }
    self.topicDateLabel.text = [XEUIUtils dateDiscriptionFromNowBk:topicInfo.time];
}

@end
