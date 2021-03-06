//
//  ShopCarCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/22.
//
//

#import <UIKit/UIKit.h>
#import "XEShopCarInfo.h"
@protocol changeNumShopDelegate <NSObject>

- (void)returnIndexOfShop:(NSInteger )index
            andNumberText:(NSString *)numText;


@end


@interface ShopCarCell : UITableViewCell
/**
 *  原价按钮
 */
@property (weak, nonatomic) IBOutlet UILabel *formerPrice;
/**
 *  现价按钮
 */
@property (weak, nonatomic) IBOutlet UILabel *afterPrice;
/**
 *  显示数量按钮
 */
@property (weak, nonatomic) IBOutlet UILabel *numShopLab;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

/**
 *  减少数量按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
/**
 *  增加数量按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic,assign)id<changeNumShopDelegate> delegate;
/**
 *  原价下划线
 */
@property (weak, nonatomic) IBOutlet UIImageView *setLineLab;
/**
 *  底部的按钮，用来显示点击与否
 */

@property (weak, nonatomic) IBOutlet UILabel *standardLab;

@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
- (void)configureCellWith:(NSIndexPath *)indexPth
              andStateStr:(NSString *)string
                     info:(XEShopCarInfo *)info;

- (void)configureCellWith:(NSIndexPath *)indexPth;
@end
