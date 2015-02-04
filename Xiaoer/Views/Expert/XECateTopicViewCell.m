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
    NSString* topicText = topicInfo.title;
    if (!topicText) {
        topicText = @"";
    }
    CGSize topicTextSize = [XECommonUtils sizeWithText:topicText font:[UIFont systemFontOfSize:15] width:SCREEN_WIDTH-11-26];
    
    if (topicTextSize.height < 16) {
        topicTextSize.height = 16;
    }
    float height = topicTextSize.height;
    height += 78;
    return height;
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
    self.topicTitleLabel.text = topicInfo.title;
    self.nickNameLabel.text = topicInfo.uname;
    self.titleLabel.text = topicInfo.utitle;
    [self.commentLabel setTitle:[NSString stringWithFormat:@" %d",topicInfo.favnum] forState:0];
    [self.collectLabel setTitle:[NSString stringWithFormat:@" %d",topicInfo.commentnum] forState:0];
    if (![topicInfo.smallAvatarUrl isEqual:[NSNull null]]) {
        [self.avatarImageView sd_setImageWithURL:topicInfo.smallAvatarUrl placeholderImage:[UIImage imageNamed:@"topic_avatar_icon"]];
    }else{
        [self.avatarImageView sd_setImageWithURL:nil];
        [self.avatarImageView setImage:[UIImage imageNamed:@"topic_avatar_icon"]];
    }
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    if (_topicInfo.isTop) {
        self.topImageView.hidden = NO;
        [self.topImageView setImage:[UIImage imageNamed:@"info_top_icon"]];
    }else{
        self.topImageView.hidden = YES;
    }
    self.topicDateLabel.text = [XEUIUtils dateDiscriptionFromNowBk:topicInfo.time];
}

@end
