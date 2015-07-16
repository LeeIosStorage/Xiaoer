//
//  OrderDreailCardCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/7.
//
//

#import "OrderDreailCardCell.h"

@implementation OrderDreailCardCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWith:(XEOrderGoodInfo *)info indexPath:(NSIndexPath *)indexPath{
    CGFloat height = self.contentView.frame.size.height;

    if (height == 260) {
        NSLog(@"260");
         //第一个 有预约信息
    }
    if (height == 220) {
        NSLog(@"220");
        //不是第一个 有预约信息
    }
    if (height == 155) {
        NSLog(@"155");
        //第一个 无预约信息
        self.leAddress.hidden = YES;
    }
    if (height == 115) {
        NSLog(@"115");
        //不是一个 无有预约信息
    }
    
}
/**
 *  预约信息按钮点击
 * */
- (IBAction)orderInfomationBtnTouched:(id)sender {
    NSLog(@"预约信息按钮点击");
    
}
@end
