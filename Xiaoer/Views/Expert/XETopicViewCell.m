//
//  XETopicViewCell.m
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import "XETopicViewCell.h"

@implementation XETopicViewCell

+ (float)heightForTopicInfo{
    NSString* topicText = @"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈";
    CGSize topicTextSize = [topicText sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(320, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    if (topicTextSize.height < 16) {
        topicTextSize.height = 16;
    }
    float height = topicTextSize.height;
    height += 21;
    return height;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
