//
//  TopicCommentViewCell.h
//  Xiaoer
//
//  Created by KID on 15/1/27.
//
//

#import <UIKit/UIKit.h>
#import "XECommentInfo.h"

@interface TopicCommentViewCell : UITableViewCell

@property (strong, nonatomic) XECommentInfo *commentInfo;

@property (strong, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

+ (float)heightForCommentInfo:(XECommentInfo *)commentInfo;

@end
