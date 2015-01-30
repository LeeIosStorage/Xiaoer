//
//  XEQuestionViewCell.m
//  Xiaoer
//
//  Created by KID on 15/1/26.
//
//

#import "XEQuestionViewCell.h"
#import "XECommonUtils.h"
#import "XEUIUtils.h"

@implementation XEQuestionViewCell

+ (float)heightForQuestionInfo:(XEQuestionInfo *)questionInfo{
    NSString* topicText = questionInfo.title;
    if (!topicText) {
        topicText = @"";
    }
//    CGSize topicTextSize = [XECommonUtils sizeWithText:topicText font:[UIFont systemFontOfSize:15] width:SCREEN_WIDTH-11-26];
//    
//    if (topicTextSize.height < 16) {
//        topicTextSize.height = 16;
//    }
//    float height = topicTextSize.height;
//    height += 55;
    float height = 70;
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
    if (questionInfo.status == 2) {
        self.questionLabel.text = [NSString stringWithFormat:@"【已答】%@",questionInfo.title];
    }else if(questionInfo.status == 1) {
        self.questionLabel.text = [NSString stringWithFormat:@"【未答】%@",questionInfo.title];
    }
    
    self.expertLabel.text = [NSString stringWithFormat:@"向%@教授提问",questionInfo.expertName];
    
    self.topicDateLabel.text = [XEUIUtils dateDiscriptionFromNowBk:questionInfo.beginTime];
}

@end
