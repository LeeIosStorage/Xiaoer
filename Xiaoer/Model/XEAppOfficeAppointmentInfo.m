//
//  XEAppOfficeAppointmentInfo.m
//  Xiaoer
//
//  Created by 王鹏 on 15/9/8.
//
//

#import "XEAppOfficeAppointmentInfo.h"

@implementation XEAppOfficeAppointmentInfo
- (NSDate *)resultBeginTime{
    
    if (self.beginTime) {
        NSDateFormatter *dateFormatter = [XEUIUtils dateFormatterOFUS];
        if (self.beginTime ) {
            return  [dateFormatter dateFromString:self.beginTime];
        }
    }
    return nil;
}

@end
