//
//  OrderDreailCardCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/7.
//
//

#import <UIKit/UIKit.h>
#import "XEOrderGoodInfo.h"
#import "UIImageView+WebCache.h"

@interface OrderDreailCardCell : UITableViewCell
/**
 *  头部的图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

/**
 *  头部的描述
 */
@property (weak, nonatomic) IBOutlet UILabel *headerDes;
/**
 *  主图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
/**
 *
 */
@property (weak, nonatomic) IBOutlet UILabel *title;
/**
 *  描述
 */
@property (weak, nonatomic) IBOutlet UILabel *desLab;
/**
 *  波浪线
 */
@property (weak, nonatomic) IBOutlet UIImageView *langImag;


/**
 *   现价
 */
@property (weak, nonatomic) IBOutlet UILabel *price;
/**
 *  原价
 */
@property (weak, nonatomic) IBOutlet UILabel *orignalPrice;
/**
 *  左边 收货人
 */
@property (weak, nonatomic) IBOutlet UILabel *LeReceivePeopleLab;
/**
 *  右边 收货人
 */
@property (weak, nonatomic) IBOutlet UILabel *RiReceivePeople;
/**
 *  右边 地址
 */
@property (weak, nonatomic) IBOutlet UILabel *leAddress;

/**
 *  右边 右边地址
 */
@property (weak, nonatomic) IBOutlet UILabel *ReReceiveAddress;

/**
 *  左边 卡券号
 */
@property (weak, nonatomic) IBOutlet UILabel *LeCardNum;
/**
 *  右边 卡券号
 */
@property (weak, nonatomic) IBOutlet UILabel *ReCardNum;
/**
 *  左边 预约上门
 */
@property (weak, nonatomic) IBOutlet UILabel *leOrder;

/**
 *  右边 预约上门
 */
@property (weak, nonatomic) IBOutlet UILabel *reOrder;


@property (weak, nonatomic) IBOutlet UIImageView *setLineA;
@property (weak, nonatomic) IBOutlet UIImageView *setLineB;
@property (weak, nonatomic) IBOutlet UIImageView *setLineC;

- (void)configureCellWith:(XEOrderGoodInfo *)info
                indexPath:(NSIndexPath *)indexPath;
@end
