//
//  ActivityDetailsViewController.h
//  Xiaoer
//
//  Created by KID on 15/1/16.
//
//

#import "XESuperViewController.h"
#import "XEActivityInfo.h"

@interface ActivityDetailsViewController : XESuperViewController

@property (nonatomic, strong) XEActivityInfo *activityInfo;
@property (nonatomic, assign) BOOL isTicketActivity;

@end
