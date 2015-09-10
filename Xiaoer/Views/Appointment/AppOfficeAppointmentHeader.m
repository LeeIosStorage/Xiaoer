//
//  AppOfficeAppointmentHeader.m
//  Xiaoer
//
//  Created by 王鹏 on 15/9/8.
//
//

#import "AppOfficeAppointmentHeader.h"

@implementation AppOfficeAppointmentHeader

+ (instancetype)appOfficeAppointmentHeader{
    return [[[NSBundle mainBundle]loadNibNamed:@"AppOfficeAppointmentHeader" owner:nil options:nil] lastObject];
}

@end
