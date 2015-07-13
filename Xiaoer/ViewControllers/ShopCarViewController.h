//
//  ShopCarViewController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/22.
//
//

#import "XESuperViewController.h"

@interface ShopCarViewController : XESuperViewController
@property (weak, nonatomic) IBOutlet UITableView *shopCarTab;
@property (strong, nonatomic) IBOutlet UIView *tabFooterView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
/**
 *  小记
 */
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
/**
 *  优惠
 */
@property (weak, nonatomic) IBOutlet UILabel *privilegeLab;

/**
 *  刷新购物车
 */
- (void)refreshShopCarWithDel:(NSString *)del
                withIndoIndex:(NSInteger )index;

@end
