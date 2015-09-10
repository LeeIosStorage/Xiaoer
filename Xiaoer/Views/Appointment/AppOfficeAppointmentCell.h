//
//  AppOfficeAppointmentCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/9/8.
//
//

#import <UIKit/UIKit.h>

#import "XEAppOfficeAppointmentInfo.h"
@interface AppOfficeAppointmentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *appBtn;

- (void)configureCellWith:(XEAppOfficeAppointmentInfo *)info;
- (void)addAppOfficeAppointmentCellTarget:(id)target action:(SEL)action;
@end
