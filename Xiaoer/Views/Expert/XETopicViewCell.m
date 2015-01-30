//
//  XETopicViewCell.m
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import "XETopicViewCell.h"
#import "XECommonUtils.h"
#import "XEUIUtils.h"

@implementation XETopicViewCell

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
    height += 35;
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
    self.topicNameLabel.text = topicInfo.title;
    [self.commentLabel setTitle:[NSString stringWithFormat:@" %d",topicInfo.favnum] forState:0];
    [self.collectLabel setTitle:[NSString stringWithFormat:@" %d",topicInfo.clicknum] forState:0];
    if (_isExpertChat) {
        [self.collectLabel setImage:[UIImage imageNamed:@"topic_collect_icon"] forState:UIControlStateNormal];
        [self.commentLabel setImage:[UIImage imageNamed:@"topic_comment_icon"] forState:UIControlStateNormal];
        if (_topicInfo.isTop) {
            self.topImageView.hidden = NO;
            [self.topImageView setImage:[UIImage imageNamed:@"info_top_icon"]];
        }else{
            self.topImageView.hidden = YES;
        }
        self.topicDateLabel.hidden = NO;
        self.topicDateLabel.text = [XEUIUtils dateDiscriptionFromNowBk:topicInfo.time];
    }
}

@end
