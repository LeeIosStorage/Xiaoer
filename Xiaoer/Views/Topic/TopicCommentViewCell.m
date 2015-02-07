//
//  TopicCommentViewCell.m
//  Xiaoer
//
//  Created by KID on 15/1/27.
//
//

#import "TopicCommentViewCell.h"
#import "UIImageView+WebCache.h"
#import "XECommonUtils.h"
#import "XEUIUtils.h"

@implementation TopicCommentViewCell

+ (float)heightForCommentInfo:(XECommentInfo *)commentInfo{
    NSString* content = commentInfo.content;
    if (!content) {
        content = @"";
    }
    CGSize topicTextSize = [XECommonUtils sizeWithText:content font:[UIFont systemFontOfSize:14] width:SCREEN_WIDTH-13*2];
    
    if (topicTextSize.height < 16) {
        topicTextSize.height = 16;
    }
    float height = topicTextSize.height;
    height += 53;
    return height;
}

- (void)awakeFromNib {
    // Initialization code
    self.avatarImgView.layer.cornerRadius = self.avatarImgView.frame.size.width/2;
    self.avatarImgView.layer.masksToBounds = YES;
    self.avatarImgView.clipsToBounds = YES;
    self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(commentLongPressAction:)];
    [self addGestureRecognizer:longPressGesture];
}

- (IBAction)commentLongPressAction:(id)sender {
    UILongPressGestureRecognizer* longPressGesture = (UILongPressGestureRecognizer*)sender;
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(topicCommentCellCommentLongPressWithCell:)]) {
            [self.delegate topicCommentCellCommentLongPressWithCell:self];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCommentInfo:(XECommentInfo *)commentInfo{
    _commentInfo = commentInfo;
    [self.avatarImgView sd_setImageWithURL:commentInfo.smallAvatarUrl placeholderImage:[UIImage imageNamed:@"topic_avatar_icon"]];
    self.nameLabel.text = commentInfo.userName;
    self.monthLabel.text = commentInfo.title;
    
    self.timeLabel.text = [XEUIUtils dateDiscriptionFromNowBk:commentInfo.time];
    
    self.contentLabel.text = commentInfo.content;
    NSString* content = commentInfo.content;
    if (!content) {
        content = @"";
    }
    CGSize textSize = [XECommonUtils sizeWithText:content font:[UIFont systemFontOfSize:14] width:SCREEN_WIDTH-13*2];
    CGRect frame = self.contentLabel.frame;
    frame.size.height = textSize.height;
    self.contentLabel.frame = frame;
    
}

@end
