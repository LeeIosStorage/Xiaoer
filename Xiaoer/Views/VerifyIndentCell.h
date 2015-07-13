//
//  VerifyIndentCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/23.
//
//

#import <UIKit/UIKit.h>
#import "XEShopCarInfo.h"

@protocol NumShopDelegate <NSObject>

- (void)returnIndexOfShop:(NSInteger )index
            andNumberText:(NSString *)numText;
- (void)showPickerViewWithBtn:(UIButton *)button;
- (void)useCouponWith:(UIButton *)button
        chooseBtnText:(NSString *)choosetBtnText;

@end

@interface VerifyIndentCell : UITableViewCell
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
/**
 *  原价下划线
 */
@property (weak, nonatomic) IBOutlet UIImageView *setLineLab;

@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UILabel *standardLab;
- (void)configureCellWith:(NSIndexPath *)indexPth
              andStateStr:(NSString *)string
                     info:(XEShopCarInfo *)info
             ifHavePicker:(BOOL)ifHavePicker;
@property (nonatomic,assign)id<NumShopDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *chooseCouponBtn;

@property (weak, nonatomic) IBOutlet UIButton *useCouponBtn;

@end
