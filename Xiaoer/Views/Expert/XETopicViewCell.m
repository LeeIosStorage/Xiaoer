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
#import "UIImageView+WebCache.h"

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

//    self.topicDateLabel.text = [XEUIUtils dateDiscriptionFromNowBk:topicInfo.time];
    self.topicDateLabel.text =  [NSString stringWithFormat:@"%d条评论",topicInfo.commentnum];
    
    self.nickNameLabel.text = topicInfo.uname;
    self.userTitleLabel.text = topicInfo.utitle;
    
    CGRect frame = self.nickNameLabel.frame;
    frame.size.width = [XECommonUtils widthWithText:self.nickNameLabel.text font:self.nickNameLabel.font lineBreakMode:self.nickNameLabel.lineBreakMode];
    self.nickNameLabel.frame = frame;
    
    frame = self.userTitleLabel.frame;
    frame.origin.x = self.nickNameLabel.frame.origin.x + self.nickNameLabel.frame.size.width + 10;
    self.userTitleLabel.frame = frame;
    
    if (![topicInfo.thumbnailUrl isEqual:[NSNull null]]) {
        [self.topicImageView sd_setImageWithURL:topicInfo.thumbnailUrl placeholderImage:[UIImage imageNamed:@"recipes_load_icon"]];
    }else{
        [self.topicImageView sd_setImageWithURL:nil];
        [self.topicImageView setImage:[UIImage imageNamed:@"recipes_load_icon"]];
    }
}

@end
