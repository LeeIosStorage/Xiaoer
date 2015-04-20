//
//  ActivityDetailsViewController.h
//  Xiaoer
//
//  Created by KID on 15/1/16.
//
//

#import "XESuperViewController.h"
#import "XEActivityInfo.h"

@protocol ActivityDetailsViewControllerDelegate;

@interface ActivityDetailsViewController : XESuperViewController

@property (nonatomic, strong) XEActivityInfo *activityInfo;
@property (nonatomic, assign) BOOL isTicketActivity;
@property (nonatomic, assign) id<ActivityDetailsViewControllerDelegate> delegate;

@end

@protocol ActivityDetailsViewControllerDelegate <NSObject>
@optional
- (void)activityDetailsViewController:(ActivityDetailsViewController*)controller changeStatus:(XEActivityInfo*)activityInfo;
@end