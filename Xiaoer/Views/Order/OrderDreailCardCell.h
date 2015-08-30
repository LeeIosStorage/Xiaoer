//
//  OrderDreailCardCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/7.
//
//

#import <UIKit/UIKit.h>
#import "XEOrderGoodInfo.h"
#import "XEOrderDetailInfo.h"
#import "UIImageView+WebCache.h"
#import "XEOrderSeriesInfo.h"
@protocol ordetBtnDelegate <NSObject>

- (void)orderBtnTouchedWith:(UIButton *)button;

@end


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
 *  预约按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;



/**
 *  主图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
/**
 *  描述
 */
@property (weak, nonatomic) IBOutlet UILabel *title;
/**
 *  左边 数量
 */
@property (weak, nonatomic) IBOutlet UILabel *leNum;
/**
 *  右边 数量
 */
@property (weak, nonatomic) IBOutlet UILabel *reNum;
/**
 *   现价
 */
@property (weak, nonatomic) IBOutlet UILabel *price;
/**
 *  原价
 */
@property (weak, nonatomic) IBOutlet UILabel *orignalPrice;
/**
 *  波浪线
 */
@property (weak, nonatomic) IBOutlet UIImageView *langImag;
/**
 *  左边 使用图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *leUseImg;

/**
 *  右边 使用lable
 */
@property (weak, nonatomic) IBOutlet UILabel *reUseLab;


/**
 *  左边 收货人
 */
@property (weak, nonatomic) IBOutlet UILabel *leReceivePeopleLab;

/**
 *  右边 收货人
 */
@property (weak, nonatomic) IBOutlet UILabel *reReceivePeople;

/**
 *  左边 地址
 */
@property (weak, nonatomic) IBOutlet UILabel *leAddress;

/**
 *  右边 右边地址
 */
@property (weak, nonatomic) IBOutlet UILabel *reAddress;


/**
 *  左边 卡券号
 */
@property (weak, nonatomic) IBOutlet UILabel *leCardNum;

/**
 *  右边 卡券号
 */
@property (weak, nonatomic) IBOutlet UILabel *reCardNum;

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
@property (nonatomic,assign)id<ordetBtnDelegate>delegate;

- (void)configureCellWith:(XEOrderGoodInfo *)info
                indexPath:(NSIndexPath *)indexPath
               detailInfo:(XEOrderDetailInfo *)detailInfo;
@end
