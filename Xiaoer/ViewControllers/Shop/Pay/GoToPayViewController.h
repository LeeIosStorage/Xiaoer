//
//  GoToPayViewController.h
//

//
//  Created by 王鹏 on 15/6/21.
//
//

#import "XESuperViewController.h"

@interface GoToPayViewController : XESuperViewController
@property (weak, nonatomic) IBOutlet UILabel *backWhiteLab;
@property (weak, nonatomic) IBOutlet UITableView *goToPayTabView;
@property (strong, nonatomic) IBOutlet UIView *tabHeader;
@property (strong, nonatomic) IBOutlet UIView *tabFooter;

@property (weak, nonatomic) IBOutlet UIButton *specialtyBtn;

/**
 *  提醒lable
 */
@property (weak, nonatomic) IBOutlet UILabel *remindView;

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
/**
 *  0 商城  1宝宝印象支付 2充值爱心分
 */
@property (nonatomic,strong)NSString *from;

@end
