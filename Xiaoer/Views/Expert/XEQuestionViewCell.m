//
//  XEQuestionViewCell.m
//  Xiaoer
//
//  Created by KID on 15/1/26.
//
//

#import "XEQuestionViewCell.h"
#import "XECommonUtils.h"

@implementation XEQuestionViewCell

+ (float)heightForTopicInfo:(XEQuestionInfo *)questionInfo{
    NSString* topicText = questionInfo.title;
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

-(void)setQuestionInfo:(XEQuestionInfo *)questionInfo{
    _questionInfo = questionInfo;
    self.questionLabel.text = questionInfo.title;
    [self.commentLabel setTitle:[NSString stringWithFormat:@" %d",questionInfo.favnum] forState:0];
    [self.collectLabel setTitle:[NSString stringWithFormat:@" %d",questionInfo.clicknum] forState:0];
}

@end
