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
    
    self.editBtn.tag = indexPath.section;
    self.consignee.userInteractionEnabled = NO;
    self.phoneNum.userInteractionEnabled = NO;    
    self.consignee.text = info.name;
    self.phoneNum.text = info.phone;
    self.addRess.text = [NSString stringWithFormat:@"%@ %@ %@ %@",info.provinceName,info.cityName,info.districtName,info.address];
    
    
    

    
}

- (IBAction)editBtnTouched:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    UITableViewCell *cell = (UITableViewCell *)btn.superview.superview;
    
    NSLog(@"%@",btn.superview.superview.superview.subviews);
    NSLog(@"%@ %@",btn.superview,btn.superview.superview);
    NSLog(@"cell.tag == %ld",cell.tag);
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchedIndexOfCell:)]) {
        [self.delegate touchedIndexOfCell:cell.tag];
    }
    

}


@end
