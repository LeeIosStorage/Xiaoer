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

@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UILabel *expertLabel;
@property (strong, nonatomic) IBOutlet UILabel *topicDateLabel;

@property (assign, nonatomic) BOOL isExpertChat;

+ (float)heightForQuestionInfo:(XEQuestionInfo *)topicInfo;

@end
