//
//  OrderCardHistoryCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/7.
//
//

#import "OrderCardHistoryCell.h"

@implementation OrderCardHistoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWithEtickerInfo:(XEAppointmentEticker *)eticker orderInfo:(XEAppointmentOrder *)orderInfo{
    self.people.text = eticker.linkName;
    self.address.text = eticker.linkAddress;
    self.cardNum.text = orderInfo.cardNo;
    self.seriveContent.text = eticker.sercontent;
}
@end
