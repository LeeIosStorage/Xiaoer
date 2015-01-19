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

@property (strong, nonatomic) IBOutlet UILabel *topicNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *commentLabel;
@property (strong, nonatomic) IBOutlet UIButton *collectLabel;

+ (float)heightForTopicInfo:(XETopicInfo *)topicInfo;

@end
