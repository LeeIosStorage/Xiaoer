//
//  XETopicViewCell.m
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import "XETopicViewCell.h"

@implementation XETopicViewCell

+ (float)heightForTopicInfo:(XETopicInfo *)topicInfo{
    NSString* topicText = topicInfo.title;
    //[topicText sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(320, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    if (!topicText) {
        topicText = @"";
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize topicTextSize = [topicText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-11-26, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    
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
    
}

@end
