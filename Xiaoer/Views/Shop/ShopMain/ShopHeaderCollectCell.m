//
//  ShopHeaderCollectCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/18.
//
//

#import "ShopHeaderCollectCell.h"

@implementation ShopHeaderCollectCell
- (void)configuehHeaderCollectCellWith:(NSIndexPath *)indexPath{
    CGFloat Xwidth = self.contentView.frame.size.width;
    CGFloat Xheight = self.contentView.frame.size.height;
    self.headerCollecLab.frame = CGRectMake(0, Xheight - 20, Xwidth, 20);
    self.headerCollectImg.frame = CGRectMake(10, 15, Xwidth - 20, Xheight - 20);
    switch (indexPath.row) {
        case 0:
            self.headerCollectImg.image = [UIImage imageNamed:@"shopToy"];
            self.headerCollecLab.text = @"玩具";
            break;
        case 1:
            self.headerCollectImg.image = [UIImage imageNamed:@"shopActivity"];
            self.headerCollecLab.text = @"活动";
            break;
        case 2:
            self.headerCollectImg.image = [UIImage imageNamed:@"shopHousekeeping"];
            self.headerCollecLab.text = @"家政";
            break;
        case 3:
            self.headerCollectImg.image = [UIImage imageNamed:@"shopPray"];
            self.headerCollecLab.text = @"祈福";
            break;
        default:
            break;
    }
}
- (void)awakeFromNib {
    // Initialization code
}

@end
