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
/**
 *  头像
 */
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;

/**
 *  人物名称
 */
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
/**
 *  titlelab
 */
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
/**
 *  话题内容
 */
@property (strong, nonatomic) IBOutlet UILabel *topicTitleLabel;
/**
 *  右上角的图片
 */
@property (strong, nonatomic) IBOutlet UIImageView *topImageView;
/**
 *  时间
 */
@property (strong, nonatomic) IBOutlet UILabel *topicDateLabel;
/**
 *  hot
 */
@property (strong, nonatomic) IBOutlet UILabel *hotLabel;
/**
 *  照片
 */
@property (strong, nonatomic) IBOutlet UIImageView *picImage;
/**
 *  类型
 */
@property (weak, nonatomic) IBOutlet UILabel *typeLab;

@property (assign, nonatomic) BOOL isExpertChat;
//@property (assign, nonatomic) BOOL isHot;

+ (float)heightForTopicInfo:(XETopicInfo *)topicInfo;
- (void)configureCellTitleDesWithSameStr:(NSString *)string
                               topicInfo:(XETopicInfo *)topicInfo;
@end
