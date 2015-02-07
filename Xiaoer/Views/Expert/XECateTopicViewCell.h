//
//  XECateTopicViewCell.h
//  Xiaoer
//
//  Created by KID on 15/1/28.
//
//

#import <UIKit/UIKit.h>
#import "XETopicInfo.h"

@interface XECateTopicViewCell : UITableViewCell

@property (strong, nonatomic) XETopicInfo *topicInfo;

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *topicTitleLabel;
//@property (strong, nonatomic) IBOutlet UIButton *collectLabel;
//@property (strong, nonatomic) IBOutlet UIButton *commentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *topImageView;
@property (strong, nonatomic) IBOutlet UILabel *topicDateLabel;

@property (assign, nonatomic) BOOL isExpertChat;

+ (float)heightForTopicInfo:(XETopicInfo *)topicInfo;

@end
