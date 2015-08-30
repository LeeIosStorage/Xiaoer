//
//  OrderCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/27.
//
//

#import <UIKit/UIKit.h>


#import "XEOrderInfo.h"


#import "XEOrderSeriesInfo.h"

@interface OrderCell : UITableViewCell
/**
 *  左边的订单号
 */
@property (weak, nonatomic) IBOutlet UILabel *topLeftNum;


/**
 *  右边的订单号
 */
@property (weak, nonatomic) IBOutlet UILabel *topDesLab;
/**
 *  头部显示交易状态的label
 */
@property (weak, nonatomic) IBOutlet UILabel *shopState;

/**
 *  主要的图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
/**
 *  titleLab
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
/**
 *  数量
 */
@property (weak, nonatomic) IBOutlet UILabel *numLab;
/**
 *  左边的数量
 */
@property (weak, nonatomic) IBOutlet UILabel *reNumLab;


/**
 *  现价
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
/**
 *  原价
 */
@property (weak, nonatomic) IBOutlet UILabel *orignalPrice;
/**
 *  规格
 */
@property (weak, nonatomic) IBOutlet UILabel *standard;
/**
 *  显示波浪的图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *langImgView;

@property (weak, nonatomic) IBOutlet UIImageView *cardImage;
@property (weak, nonatomic) IBOutlet UILabel *cardUsedLab;


@property (weak, nonatomic) IBOutlet UIImageView *setLineA;

@property (weak, nonatomic) IBOutlet UIImageView *setLineB;

- (void)configureCellWith:(NSIndexPath *)indexPath
               goodesInfo:(XEOrderGoodInfo *)goodInfo
                orderInfo:(XEOrderInfo *)orderInfo;
- (void)changeFrameWithArray:(NSMutableArray *)array
                     Ycgloat:(CGFloat )ycgfloat;
@end
