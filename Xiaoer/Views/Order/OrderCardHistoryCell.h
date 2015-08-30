//
//  OrderCardHistoryCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/7.
//
//

#import <UIKit/UIKit.h>
#import "XEAppointmentEticker.h"
#import "XEAppointmentOrder.h"


@interface OrderCardHistoryCell : UITableViewCell
/**
 *  收货人
 */
@property (weak, nonatomic) IBOutlet UILabel *people;
/**
 *  地址
 */
@property (weak, nonatomic) IBOutlet UILabel *address;
/**
 *  卡券号
 */
@property (weak, nonatomic) IBOutlet UILabel *cardNum;
/**
 *  服务内容
 */
@property (weak, nonatomic) IBOutlet UILabel *seriveContent;


- (void)configureCellWithEtickerInfo:(XEAppointmentEticker *)eticker
                           orderInfo:(XEAppointmentOrder *)orderInfo;

@end
