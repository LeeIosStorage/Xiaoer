//
//  AddressManagerCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/23.
//
//

#import "AddressManagerCell.h"

@implementation AddressManagerCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWith:(NSIndexPath *)indexPath info:(XEAddressListInfo *)info{
    self.editBtn.tag = indexPath.row + 1;
    self.consignee.userInteractionEnabled = NO;
    self.phoneNum.userInteractionEnabled = NO;
    self.addRess.userInteractionEnabled = NO;
    
    self.consignee.text = info.name;
    self.phoneNum.text = info.phone;
    self.addRess.text = info.address;
    

    
}


- (IBAction)editBtnTouched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    UITableViewCell *cell = (UITableViewCell *)btn.superview.superview.superview;
    
    NSLog(@"%@",btn.superview.superview.superview.subviews);
//    for (UIView *obj in btn.superview.superview.superview.subviews) {
//        UITableViewCell *cell = (UITableViewCell *)obj;
//        if (btn.tag == cell.tag) {
//            for (UIView *view in btn.superview.subviews) {
//                if (view.tag >99 && view.tag< 103) {
//                    NSLog(@"有");
//                    view.userInteractionEnabled = YES;
//                }
//            }
//            
//        }else if (btn.tag != cell.tag){
//            /**
//             *  找到不是tag的cell 让它里面的textfield不可用
//             */
//            for (UIView *view in cell.contentView.subviews) {
//                if (view.tag >99 && view.tag< 103) {
//                    NSLog(@"有");
//                    view.userInteractionEnabled = NO;
//                }
//            }
//        }
//        
//    }
    NSLog(@"cell.tag == %ld",btn.tag);
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchedIndexOfCell:)]) {
        [self.delegate touchedIndexOfCell:btn.tag];
    }

}

@end
