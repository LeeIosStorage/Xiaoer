//
//  OrderDreailCardCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/7.
//
//

#import "OrderDreailCardCell.h"
#import "XEDetailEticketsInfo.h"
@implementation OrderDreailCardCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWith:(XEOrderGoodInfo *)info indexPath:(NSIndexPath *)indexPath detailInfo:(XEOrderDetailInfo *)detailInfo{
    CGFloat height = self.contentView.frame.size.height;

    for (XEOrderSeriesInfo * seir in [detailInfo detailReturenSeriesInfo]) {
        XEOrderGoodInfo *good = [seir returnGoodsInfo][0];
        if ([info.id isEqualToString:good.id]) {
            self.headerDes.text = info.serieName;
        }
    }
    
    if (height == 260) {
        NSLog(@"260");
         // 有预约信息
        XEDetailEticketsInfo  *etickets = [info goodReturnEticketsArray][0];
        self.reReceivePeople.text = detailInfo.linkName;
        self.reAddress.text = detailInfo.linkAddress;
        self.reCardNum.text = etickets.cardNo;
        self.reOrder.text = info.sercontent;
        
        self.leAddress.alpha = 1;
        self.reAddress.alpha = 1;
        
        self.leCardNum.alpha = 1;
        self.reCardNum.alpha = 1;
        
        self.leOrder.alpha = 1;
        self.reOrder.alpha = 1;
        
        self.leReceivePeopleLab.alpha = 1;
        self.reReceivePeople.alpha = 1;
        

        
        
    }
//    if (height == 220) {
//        //不是第一个 有预约信息
//        NSLog(@"220");
//        self.headerImage.frame = CGRectZero;
//        self.headerDes.frame = CGRectZero;
//        self.orderBtn.frame = CGRectZero;
//        
//        //其他的往上移动 40距离 
//        NSMutableArray *viewArray = [NSMutableArray array];
//        [viewArray addObject:self.mainImage];
//        [viewArray addObject:self.title];
//        [viewArray addObject:self.langImag];
//        [viewArray addObject:self.price];
//        [viewArray addObject:self.orignalPrice];
////        [viewArray addObject:self.leAddress];
////        [viewArray addObject:self.reAddress];
////        [viewArray addObject:self.leCardNum];
////        [viewArray addObject:self.reCardNum];
////        [viewArray addObject:self.leOrder];
////        [viewArray addObject:self.reOrder];
////        [viewArray addObject:self.leReceivePeopleLab];
////        [viewArray addObject:self.reReceivePeople];
//        [self changeFrameBWith:viewArray];
//        
//        self.setLineA.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
//        self.setLineB.frame = CGRectMake(0, 115, SCREEN_WIDTH, 1);
//        self.setLineC.frame = CGRectMake(0, 219, SCREEN_WIDTH, 1);
//    }
    if (height == 155) {
        NSLog(@"155");
        //第一个 无预约信息
        self.leAddress.alpha = 0;
        self.reAddress.alpha = 0;
        
        self.leCardNum.alpha = 0;
        self.reCardNum.alpha = 0;
        
        self.leOrder.alpha = 0;
        self.reOrder.alpha = 0;

        self.leReceivePeopleLab.alpha = 0;
        self.reReceivePeople.alpha = 0;
        

        
        self.setLineA.frame = CGRectMake(0, 39, SCREEN_WIDTH, 1);
        self.setLineB.frame = CGRectMake(0, 154, SCREEN_WIDTH, 1);
        self.setLineC.frame = CGRectMake(0, 154, SCREEN_WIDTH, 1);
        
        self.headerImage.frame = CGRectMake(15, 5, 30, 30);
        self.headerDes.frame = CGRectMake(60, 10, 150, 20);
        self.orderBtn.frame = CGRectMake(SCREEN_WIDTH - 15 - 60, 10, 60, 20);
    }
    
    if ([info  goodReturnEticketsArray].count > 0) {
        //有预约券
        self.orderBtn.alpha = 1;
        self.reOrder.text = info.sercontent;
    }else{
        //无预约券
        self.orderBtn.alpha = 0;
        self.reOrder.text = @"";
    }
    
    
    self.orderBtn.layer.cornerRadius = 5;
    self.orderBtn.layer.masksToBounds = YES;
    [self.mainImage sd_setImageWithURL:[info totalImageUrl] placeholderImage:[UIImage imageNamed:@"shopCellHolder"]];
    self.title.text = info.name;
    self.reNum.text = [NSString stringWithFormat:@"×%@",info.num];
    self.price.text = [info resultPrice];
    self.orignalPrice.text = [info resultOrigPric];
    if ([info.isUsed isEqualToString:@"0"]) {
        //未使用
        self.leUseImg.image = [UIImage imageNamed:@"orderCardUsed"];
        self.reUseLab.text = @"未使用";
    }else{
        self.leUseImg.image = [UIImage imageNamed:@"orderCardNoUse"];
        self.reUseLab.text = @"已使用";
        
    }

    
    
}
- (void)changeFrameBWith:(NSMutableArray *)array{
    for (UIView *view in array) {
        CGRect frame = view.frame;
        frame.origin.y -= 40;
        view.frame = frame;
        
    }
}
/**
 *  预约信息按钮点击
 * */
- (IBAction)orderInfomationBtnTouched:(id)sender {
    NSLog(@"预约信息按钮点击");
    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
    button.tag = cell.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderBtnTouchedWith:)]) {
        [self.delegate orderBtnTouchedWith:button];
    }
}
@end
