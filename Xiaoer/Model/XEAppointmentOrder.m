//
//  XEAppointmentOrder.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/18.
//
//

#import "XEAppointmentOrder.h"
#import "MJExtension.h"
@implementation XEAppointmentOrder
- (NSMutableArray *)appointmentReturenSelfEticker{
    NSMutableArray *array = [NSMutableArray array];
    if (self.eticketAppointList.count > 0) {
        
        for (NSDictionary *dic  in self.eticketAppointList) {
            XEAppointmentEticker *eticter = [XEAppointmentEticker objectWithKeyValues:dic];
            [array addObject:eticter];
        }
        return array;
    }else{
        return nil;
    }
}
@end
