//
//  ShopCarCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/22.
//
//

#import "ShopCarCell.h"

@implementation ShopCarCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellBackBtnWithString:(NSString *)string{
    if ([string isEqualToString:@"0"]) {
        self.backBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    }else{
        self.backBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    }
}

- (void)configureCellWith:(NSIndexPath *)indexPth{
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:self.formerPrice.font forKey:NSFontAttributeName];
    CGSize rect = [self.formerPrice.text sizeWithAttributes:attributes];
    CGRect formerrect = self.setLineLab.frame;
    formerrect.size.width = rect.width;
    NSLog(@"width == %f",formerrect.size.width);
    self.setLineLab.frame = formerrect;
    self.backBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backBtn.layer.borderWidth = 1;
    
}

#pragma mark  边框按钮点击
- (IBAction)backButtonTouched:(id)sender {
    UIButton *button = (UIButton *)sender;
    ShopCarCell *cell = (ShopCarCell *)button.superview.superview;
    if (button.layer.borderColor == [UIColor whiteColor].CGColor) {
        button.layer.borderColor = [UIColor orangeColor].CGColor;
        if (self.delegate && [self.delegate respondsToSelector:@selector(returnIndexOfShop:andIfTouchedWith:)]) {
            [self.delegate returnIndexOfShop:cell.tag andIfTouchedWith:@"1"];
        }
    }else{
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        if (self.delegate && [self.delegate respondsToSelector:@selector(returnIndexOfShop:andIfTouchedWith:)]) {
            [self.delegate returnIndexOfShop:cell.tag andIfTouchedWith:@"0"];
        }
    }
    
    
}



- (IBAction)addBtnTouched:(id)sender {
    UIButton *button = (UIButton *)sender;
    ShopCarCell *cell = (ShopCarCell *)button.superview.superview;
    cell.numShopLab.text = [self returnAddResultWith:cell];
    
    NSLog(@"%@",cell.numShopLab.text);
    if (self.delegate && [self.delegate respondsToSelector:@selector(returnIndexOfShop:andNumberText:)]) {
        [self.delegate returnIndexOfShop:cell.tag andNumberText:cell.numShopLab.text];
    }
}
#pragma mark 增加按钮返回的数目
- (NSString *)returnAddResultWith:(ShopCarCell *)cell{
    NSInteger indexAdd = [cell.numShopLab.text integerValue];
    indexAdd ++;
    NSString *addResult = [NSString stringWithFormat:@"%ld",(long)indexAdd];
    return addResult;
}
- (IBAction)reduce:(id)sender {
    UIButton *button = (UIButton *)sender;
    ShopCarCell *cell = (ShopCarCell *)button.superview.superview;
    cell.numShopLab.text = [self reduceResultWith:cell];
    NSLog(@"%@ %ld",cell.numShopLab.text,(long)cell.tag);
    if (self.delegate && [self.delegate respondsToSelector:@selector(returnIndexOfShop:andNumberText:)]) {
        [self.delegate returnIndexOfShop:cell.tag andNumberText:cell.numShopLab.text];
    }
    
}
#pragma mark 减少按钮返回的数目
- (NSString *)reduceResultWith:(ShopCarCell *)cell{
    NSInteger indexAdd = [cell.numShopLab.text integerValue];
    if (indexAdd == 1) {
        return @"1";
    }else{
        indexAdd --;
    }
    NSString *addResult = [NSString stringWithFormat:@"%ld",indexAdd];
    return addResult;
}
@end
