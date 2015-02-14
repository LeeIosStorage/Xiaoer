//
//  TopicDetailsViewController.h
//  Xiaoer
//
//  Created by KID on 15/1/27.
//
//

#import "XESuperViewController.h"
#import "XETopicInfo.h"

@protocol TopicDetailsViewControllerDelegate;

@interface TopicDetailsViewController : XESuperViewController

@property (nonatomic, assign) id<TopicDetailsViewControllerDelegate> delegate;
@property (nonatomic, strong) XETopicInfo *topicInfo;

@end

@protocol TopicDetailsViewControllerDelegate <NSObject>
@optional
- (void)topicDetailViewController:(TopicDetailsViewController*)controller deleteTopic:(XETopicInfo*)topicInfo;
@end