//
//  SelectBirthdayViewController.h
//  Xiaoer
//
//  Created by KID on 15/1/12.
//
//

#import "XESuperViewController.h"
@protocol SelectBirthdayViewControllerDelegate;

@interface SelectBirthdayViewController : XESuperViewController
@property(nonatomic, assign)id<SelectBirthdayViewControllerDelegate> delegate;
@property(nonatomic, strong) NSDate* oldDate;
@end

@protocol SelectBirthdayViewControllerDelegate <NSObject>
- (void)SelectBirthdayWithDate:(NSDate*)date;

@end