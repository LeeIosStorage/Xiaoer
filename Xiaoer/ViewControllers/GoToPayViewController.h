//
//  GoToPayViewController.h
//

//
//  Created by 王鹏 on 15/6/21.
//
//

#import "XESuperViewController.h"

@interface GoToPayViewController : XESuperViewController
@property (weak, nonatomic) IBOutlet UITableView *goToPayTabView;
@property (strong, nonatomic) IBOutlet UIView *tabHeader;
@property (strong, nonatomic) IBOutlet UIView *tabFooter;
/**
 *  订单编号lable
 */
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
/**
 *  订单价格lable
 */
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLab;
/**
 *  订单编号
 */
@property (nonatomic,strong)NSString *orderNum;
/**
 *  订单价格
 */
@property (nonatomic,strong)NSString *orderPrice;


@end
