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
#import "UIImageView+WebCache.h"

@implementation XEQuestionViewCell

+ (float)heightForQuestionInfo:(XEQuestionInfo *)questionInfo{
//    NSString* topicText = questionInfo.title;
//    if (!topicText) {
//        topicText = @"";
//    }
//    CGSize topicTextSize = [XECommonUtils sizeWithText:topicText font:[UIFont systemFontOfSize:15] width:SCREEN_WIDTH-11-26];
//    
//    if (topicTextSize.height < 16) {
//        topicTextSize.height = 16;
//    }
//    float height = topicTextSize.height;
//    height += 55;
    float height = 80;
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
    if (questionInfo.status == 2) {
        self.questionLabel.text = [NSString stringWithFormat:@"【已答】%@",self.questionLabel.text];
    }else if(questionInfo.status == 1) {
        self.questionLabel.text = [NSString stringWithFormat:@"【未答】%@",self.questionLabel.text];
    }
    
    CGRect frame = self.questionLabel.frame;;
    CGSize textSize = [XECommonUtils sizeWithText:self.questionLabel.text font:self.questionLabel.font width:self.questionLabel.frame.size.width];
    if (textSize.height < 18) {
        
    }else {
        frame.origin.y = frame.origin.y + 9;
    }
    self.questionLabel.frame = frame;
    
    if (self.isMineChat) {
        self.nickNameLabel.hidden = YES;
        self.titleLabel.hidden = YES;
//        if (self.isExpertChat) {
//            self.expertLabel.hidden = YES;
//        }else{
//            self.expertLabel.hidden = NO;
//            self.expertLabel.text = [NSString stringWithFormat:@"向%@教授提问",questionInfo.expertName];
//        }
        //问答内容移下
        frame = self.questionLabel.frame;
        frame.origin.x = 13;
        self.questionLabel.frame = frame;
    }else {
        self.nickNameLabel.text = questionInfo.expertName;
        self.titleLabel.text = questionInfo.utitle;
        
        //蛋疼，专家聊tab才显示头像
        if (self.isExpertChat) {
            if (![questionInfo.smallAvatarUrl isEqual:[NSNull null]]) {
                [self.avatarImageView sd_setImageWithURL:questionInfo.smallAvatarUrl placeholderImage:[UIImage imageNamed:@"topic_avatar_icon"]];
            }else{
                [self.avatarImageView sd_setImageWithURL:nil];
                [self.avatarImageView setImage:[UIImage imageNamed:@"topic_avatar_icon"]];
            }
            self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2;
            self.avatarImageView.layer.masksToBounds = YES;
            self.avatarImageView.clipsToBounds = YES;
            self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        }else{
            //问答内容移下
            frame = self.questionLabel.frame;
            frame.origin.x = 13;
            self.questionLabel.frame = frame;
        }
        
        frame = self.nickNameLabel.frame;
        frame.size.width = [XECommonUtils widthWithText:self.nickNameLabel.text font:self.nickNameLabel.font lineBreakMode:self.nickNameLabel.lineBreakMode];
        self.nickNameLabel.frame = frame;
        
        frame = self.titleLabel.frame;
        frame.origin.x = self.nickNameLabel.frame.origin.x + self.nickNameLabel.frame.size.width + 10;
        self.titleLabel.frame = frame;
    }
    
    self.topicDateLabel.text = [XEUIUtils dateDiscriptionFromNowBk:questionInfo.beginTime];
}

@end
