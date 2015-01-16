//
//  XETopicViewCell.m
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import "XETopicViewCell.h"

#define testText @"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈"

@implementation XETopicViewCell

+ (float)heightForTopicInfo{
    NSString* topicText = testText;
    //[topicText sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(320, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize topicTextSize = [topicText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-11*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    
    if (topicTextSize.height < 16) {
        topicTextSize.height = 16;
    }
    float height = topicTextSize.height;
    height += 31;
    return height;
}

- (void)awakeFromNib {
    // Initialization code
    _topicNameLabel.text = testText;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
