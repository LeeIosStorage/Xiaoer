//
//  OrderApplyReimburseCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/3.
//
//

#import "OrderApplyReimburseCell.h"

@implementation OrderApplyReimburseCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWith:(NSIndexPath *)indexPath desText:(NSString *)desText{
    switch (indexPath.section) {
        case 0:
            self.leftTitle.text = @"退款服务";
            break;
        case 1:
            self.leftTitle.text = @"退货原因";
            break;
        case 2:
            self.leftTitle.text = @"退款金额";
            self.rightBtn.hidden = YES;
            break;
            
        default:
            break;
    }
    self.desLab.text = desText;

}
@end
