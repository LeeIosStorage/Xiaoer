//
//  XETopicViewCell.h
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import <UIKit/UIKit.h>
#import "XETopicInfo.h"

@interface XETopicViewCell : UITableViewCell

@property (strong, nonatomic) XETopicInfo *topicInfo;

@property (strong, nonatomic) IBOutlet UIImageView *topicImageView;
@property (strong, nonatomic) IBOutlet UILabel *topicNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *topicDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userTitleLabel;

@property (assign, nonatomic) BOOL isExpertChat;

+ (float)heightForTopicInfo:(XETopicInfo *)topicInfo;

@end
