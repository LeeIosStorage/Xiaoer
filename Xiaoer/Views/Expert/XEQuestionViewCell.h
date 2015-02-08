//
//  XEQuestionViewCell.h
//  Xiaoer
//
//  Created by KID on 15/1/26.
//
//

#import <UIKit/UIKit.h>
#import "XEQuestionInfo.h"

@interface XEQuestionViewCell : UITableViewCell

@property (strong, nonatomic) XEQuestionInfo *questionInfo;

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UILabel *expertLabel;
@property (strong, nonatomic) IBOutlet UILabel *topicDateLabel;

@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (assign, nonatomic) BOOL isExpertChat;
@property (assign, nonatomic) BOOL isMineChat;

+ (float)heightForQuestionInfo:(XEQuestionInfo *)topicInfo;

@end
