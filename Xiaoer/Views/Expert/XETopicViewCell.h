//
//  XETopicViewCell.h
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import <UIKit/UIKit.h>

@interface XETopicViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *topicNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *commentLabel;
@property (strong, nonatomic) IBOutlet UIButton *collectLabel;

+ (float)heightForTopicInfo;

@end
