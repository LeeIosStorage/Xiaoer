//
//  OrderCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/27.
//
//

#import "OrderCell.h"
#import "UIImageView+WebCache.h"
@implementation OrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configureCellWith:(NSIndexPath *)indexPath goodesInfo:(XEOrderGoodInfo *)goodInfo orderInfo:(XEOrderInfo *)orderInfo{
    if (self.contentView.frame.size.height == 180) {
        self.topDesLab.hidden = NO;
        self.shopState.hidden = NO;
        self.setLineA.hidden = NO;
        self.topLeftNum.hidden = NO;

    }else{
        self.topDesLab.hidden = YES;
        self.shopState.hidden = YES;
        self.setLineA.hidden = YES;
        self.topDesLab.hidden = YES;
        self.topLeftNum.hidden = YES;
    }
    
    [self.mainImage sd_setImageWithURL:[goodInfo totalImageUrl] placeholderImage:[UIImage imageNamed:@"shopCellHolder"]];
    self.numLab.text = [NSString stringWithFormat:@"×%@",goodInfo.num];
    self.titleLab.text = goodInfo.name;
    self.priceLab.text = [goodInfo resultPrice];
    self.orignalPrice.text = [goodInfo resultOrigPric];
    if ([goodInfo.type isEqualToString:@"2"]) {
        //卡券（非实体商品）
        self.langImgView.hidden = NO;
        self.standard.text = @"";
        self.standard.hidden = YES;
        self.cardImage.hidden = NO;

        
        if ([goodInfo.isUsed isEqualToString:@"0"]) {
            //未使用
            self.cardImage.image = [UIImage imageNamed:@"orderCardUsed"];
            self.cardUsedLab.text = @"未使用";
        }else{
            self.cardImage.image = [UIImage imageNamed:@"orderCardNoUse"];
            self.cardUsedLab.text = @"已使用";

        }
        //改变frame
        
        if (self.contentView.frame.size.height == 180) {
            self.titleLab.frame = CGRectMake(110, 70, 200, 20);
            self.reNumLab.frame = CGRectMake(110, 95, 90, 20);
            self.numLab.frame = CGRectMake(155, 95, 100, 20);
            self.priceLab.frame = CGRectMake(110, 120, 80, 20);
            self.orignalPrice.frame = CGRectMake(200, 120, 100, 20);
            
        }else{
            self.titleLab.frame = CGRectMake(110, 20, 200, 20);
            self.reNumLab.frame = CGRectMake(110, 45, 90, 20);
            self.numLab.frame = CGRectMake(155, 45, 100, 20);
            self.priceLab.frame = CGRectMake(110, 70, 80, 20);
            self.orignalPrice.frame = CGRectMake(200, 70, 100, 20);
        }
        
        
        
        
    }else{
        self.langImgView.hidden = YES;
        self.cardUsedLab.text = @"";
        self.cardImage.hidden = YES;

        if (self.contentView.frame.size.height == 180) {
            if (goodInfo.standard) {
                self.standard.text = goodInfo.standard;
                self.standard.hidden = NO;
                self.titleLab.frame = CGRectMake(110, 70, 200, 20);
                self.standard.frame = CGRectMake(110, 95, 190, 20);
                self.reNumLab.frame = CGRectMake(110, 120, 90, 20);
                self.numLab.frame = CGRectMake(155, 120, 100, 20);
                self.priceLab.frame = CGRectMake(110, 145, 80, 20);
                self.orignalPrice.frame = CGRectMake(200, 145, 100, 20);
            }else{
                self.standard.text = @"";
                self.standard.hidden = YES;
                self.titleLab.frame = CGRectMake(110, 70, 200, 20);
                self.reNumLab.frame = CGRectMake(110, 95, 90, 20);
                self.numLab.frame = CGRectMake(155, 95, 100, 20);
                self.priceLab.frame = CGRectMake(110, 120, 80, 20);
                self.orignalPrice.frame = CGRectMake(200, 120, 100, 20);
            }


        }else{
            self.titleLab.frame = CGRectMake(110, 30, 200, 20);
            if (goodInfo.standard) {
                self.standard.text = goodInfo.standard;
                self.standard.hidden = NO;
                self.standard.frame = CGRectMake(110, 55, 190, 20);
                self.reNumLab.frame = CGRectMake(110, 80, 90, 20);
                self.numLab.frame = CGRectMake(155, 80, 90, 20);
                self.priceLab.frame = CGRectMake(110, 105, 80, 20);
                self.orignalPrice.frame = CGRectMake(200, 105, 100, 20);
            }else{
                self.standard.text = @"";
                self.standard.hidden = YES;
                self.reNumLab.frame = CGRectMake(110, 55, 90, 20);
                self.numLab.frame = CGRectMake(155,55 , 90, 20);
                self.priceLab.frame = CGRectMake(110, 80, 80, 20);
                self.orignalPrice.frame = CGRectMake(200, 80, 100, 20);
          
            }
        }


    }
    
    
    
        NSArray *array = orderInfo.series;
        for (NSDictionary *seri in array) {
            if ([[seri[@"goodses"][0][@"id"]stringValue] isEqualToString:goodInfo.id]) {
                //找到相同的
                //母单单号
                self.topDesLab.text = orderInfo.orderNo;
                //订单状态（1 待付款 2 已失效 3 已付款（待发货）4 已发货 5 未发货的申请退款（待审核） 6 已发货的申请退款退货（待审核）7 审核退款 8 审核不退款 9 关闭交易）
                if ([orderInfo.status isEqualToString:@"1"]) {
                    self.shopState.text = @"待付款";
                }
                if ([orderInfo.status isEqualToString:@"2"]) {
                    self.shopState.text = @"已失效";
                }
                if ([orderInfo.status isEqualToString:@"3"]) {
                    self.shopState.text = @"待发货";
                }
                if ([orderInfo.status isEqualToString:@"4"]) {
                    self.shopState.text = @"已发货";
                }
                if ([orderInfo.status isEqualToString:@"5"]) {
                    self.shopState.text = @"待审核";
                }
                if ([orderInfo.status isEqualToString:@"6"]) {
                    self.shopState.text = @"待审核";
                }
                if ([orderInfo.status isEqualToString:@"7"]) {
                    self.shopState.text = @"审核退款";
                }
                if ([orderInfo.status isEqualToString:@"8"]) {
                    self.shopState.text = @"审核不退款";
                }
                if ([orderInfo.status isEqualToString:@"9"]) {
                    self.shopState.text = @"关闭交易";
                }
                
            }else {
                //不相同
            }
        }
    
    
    
}
- (void)changeFrameWithArray:(NSMutableArray *)array Ycgloat:(CGFloat )ycgfloat{
    for (UIView *view in array) {
        CGRect frame = view.frame;
        frame.origin.y += ycgfloat;
        view.frame = frame;
    }
}


@end
