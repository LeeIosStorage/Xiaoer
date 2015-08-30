//
//  ToyMainTabCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/18.
//
//

#import <UIKit/UIKit.h>
#import "XEShopSerieInfo.h"
@interface ToyMainTabCell : UITableViewCell
//主要的imageVidew
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
//右上方在底部显示一定颜色
@property (weak, nonatomic) IBOutlet UILabel *bottonLab;

/**
 *  钟表imageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *clockImg;
/**
 *  显示剩余多少天
 */
@property (weak, nonatomic) IBOutlet UILabel *dayLable;
/**
 *  图片下方的小lable
 */
@property (weak, nonatomic) IBOutlet UILabel *bottomSmalLab;
/**
 *  描述性文件
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLab;






- (void)configureCellWithModel:(XEShopSerieInfo *)model;
@end
