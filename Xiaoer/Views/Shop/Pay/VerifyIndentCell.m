//
//  VerifyIndentCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/23.
//
//

#import "VerifyIndentCell.h"
#import "UIImageView+WebCache.h"
#import "XEProgressHUD.h"
@implementation VerifyIndentCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWith:(NSIndexPath *)indexPth andStateStr:(NSString *)string info:(XEShopCarInfo *)info ifHavePicker:(BOOL)ifHavePicker{
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:self.formerPrice.font forKey:NSFontAttributeName];
    CGSize rect = [self.formerPrice.text sizeWithAttributes:attributes];
    CGRect formerrect = self.setLineLab.frame;
    formerrect.size.width = rect.width;
    self.setLineLab.frame = formerrect;
    self.numShopLab.text = info.num;;
    self.formerPrice.text = [NSString stringWithFormat:@"%@",info.resultOrigPric];
    self.afterPrice.text = [NSString stringWithFormat:@"%@",info.resultPrice];
    [self.mainImageView sd_setImageWithURL:[info totalImageUrl] placeholderImage:[UIImage imageNamed:@"shopCellHolder"]];
    if (info.standard) {
        self.standardLab.text = info.standard;
    }else{
        self.standardLab.text = @"";
    }
    self.desLab.text = info.name;
    

    self.chooseCouponBtn.layer.cornerRadius = 8;
    self.chooseCouponBtn.layer.masksToBounds = YES;
    self.chooseCouponBtn.layer.borderWidth = 1;
    self.chooseCouponBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.useCouponBtn.layer.cornerRadius = 5;
    self.useCouponBtn.layer.masksToBounds = YES;
    
    if (ifHavePicker == YES) {
        self.chooseCouponBtn.frame = CGRectMake(15, 120, 200, 30);
        self.useCouponBtn.frame = CGRectMake(SCREEN_WIDTH - 15 - 60, 120, 60, 30);

    }else{
        self.chooseCouponBtn.frame = CGRectMake(0, 0, 0, 0);
        self.useCouponBtn.frame =CGRectMake(0, 0, 0, 0);

    }
    

    
}
- (IBAction)addBtnTouched:(id)sender {
    UIButton *button = (UIButton *)sender;
    VerifyIndentCell *cell = (VerifyIndentCell *)button.superview.superview;
    cell.numShopLab.text = [self returnAddResultWith:cell];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(returnIndexOfShop:andNumberText:)]) {
        [self.delegate returnIndexOfShop:cell.tag andNumberText:cell.numShopLab.text];
    }
}

#pragma mark 增加按钮返回的数目
- (NSString *)returnAddResultWith:(VerifyIndentCell *)cell{
    NSInteger indexAdd = [cell.numShopLab.text integerValue];
    indexAdd ++;
    NSString *addResult = [NSString stringWithFormat:@"%ld",(long)indexAdd];
    return addResult;
}

- (IBAction)reduceBtnTouched:(id)sender {
    UIButton *button = (UIButton *)sender;
    VerifyIndentCell *cell = (VerifyIndentCell *)button.superview.superview;
    cell.numShopLab.text = [self reduceResultWith:cell];
    if (self.delegate && [self.delegate respondsToSelector:@selector(returnIndexOfShop:andNumberText:)]) {
        [self.delegate returnIndexOfShop:cell.tag andNumberText:cell.numShopLab.text];
    }
}
#pragma mark 减少按钮返回的数目
- (NSString *)reduceResultWith:(VerifyIndentCell *)cell{
    NSInteger indexAdd = [cell.numShopLab.text integerValue];
    if (indexAdd == 1) {
        return @"1";
    }else{
        indexAdd --;
    }
    NSString *addResult = [NSString stringWithFormat:@"%ld",indexAdd];
    return addResult;
}

- (IBAction)chooseCouponBtnTouched:(id)sender {
    UIButton *button = (UIButton *)sender;
    VerifyIndentCell *cell = (VerifyIndentCell *)button.superview.superview;

    button.tag = cell.tag;

    NSLog(@"选择优惠券 %ld",button.tag);
    if (self.delegate && [self.delegate respondsToSelector:@selector(showPickerViewWithBtn:)]) {
        [self.delegate showPickerViewWithBtn:button];
    }
}

- (IBAction)useCouponBtnTouched:(id)sender{
    UIButton *button = (UIButton *)sender;
    VerifyIndentCell *cell = (VerifyIndentCell *)button.superview.superview;
    button.tag = cell.tag;

    NSLog(@"%@",cell.chooseCouponBtn.titleLabel.text);
    
    if ([cell.chooseCouponBtn.titleLabel.text isEqualToString:@"请选择促销活动优惠券"]) {
        
        [XEProgressHUD lightAlert:@"请选择优惠券"];
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(useCouponWith:chooseBtnText:)]) {
            [self.delegate useCouponWith:button chooseBtnText:cell.chooseCouponBtn.titleLabel.text];
        }
    }


}
@end
