//
//  QuestionDetailsViewController.h
//  Xiaoer
//
//  Created by KID on 15/1/29.
//
//

#import "XESuperViewController.h"
#import "XEQuestionInfo.h"

@protocol QuestionDetailsViewControllerDelegate;

@interface QuestionDetailsViewController : XESuperViewController

@property (nonatomic, assign) id<QuestionDetailsViewControllerDelegate> delegate;
@property (nonatomic, strong) XEQuestionInfo *questionInfo;

@end

@protocol QuestionDetailsViewControllerDelegate <NSObject>
@optional
- (void)questionDetailViewController:(QuestionDetailsViewController*)controller deleteQuestion:(XEQuestionInfo*)questionInfo;
@end