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
//    height += 35;
//    return height;
    return 90;
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


    
    //1教育2营养3入园4心理

    int catInt = topicInfo.cat;
    NSString *catStr = [NSString stringWithFormat:@"%d",catInt];
    if ([catStr isEqualToString:@"1"]) {
        self.typeLab.text = [NSString stringWithFormat:@"[教育]"];
    }
    if ([catStr isEqualToString:@"2"]) {
        self.typeLab.text = [NSString stringWithFormat:@"[营养]"];
    }
    if ([catStr isEqualToString:@"3"]) {
        self.typeLab.text = [NSString stringWithFormat:@"[入园]"];
    }
    if ([catStr isEqualToString:@"4"]) {
        self.typeLab.text = [NSString stringWithFormat:@"[心理]"];
    }
    

    self.numChatLab.text = [NSString stringWithFormat:@"%d+评论",topicInfo.commentnum];
    self.userTitleLabel.text = topicInfo.utitle;

//    self.nickNameLabel.text = topicInfo.uname;
    
//    CGRect frame = self.nickNameLabel.frame;
//    frame.size.width = [XECommonUtils widthWithText:self.nickNameLabel.text font:self.nickNameLabel.font lineBreakMode:self.nickNameLabel.lineBreakMode];
//    self.nickNameLabel.frame = frame;
//    
//    frame = self.userTitleLabel.frame;
//    frame.origin.x = self.nickNameLabel.frame.origin.x + self.nickNameLabel.frame.size.width + 10;
//    self.userTitleLabel.frame = frame;
    
//    frame = self.topicNameLabel.frame;
//    CGSize textSize = [XECommonUtils sizeWithText:self.topicNameLabel.text font:self.topicNameLabel.font width:self.topicNameLabel.frame.size.width];
//    if (textSize.height > 18) {
//        frame.origin.y = 9;
//    }else{
//        frame.origin.y = frame.origin.y;
//    }
//    self.topicNameLabel.frame = frame;
    
    if (![topicInfo.thumbnailUrl isEqual:[NSNull null]]) {
        [self.topicImageView sd_setImageWithURL:topicInfo.thumbnailUrl placeholderImage:[UIImage imageNamed:@"recipes_load_icon"]];
    }else{
        [self.topicImageView sd_setImageWithURL:nil];
        [self.topicImageView setImage:[UIImage imageNamed:@"recipes_load_icon"]];
    }
}

@end
