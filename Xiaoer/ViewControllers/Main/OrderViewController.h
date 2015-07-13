//
//  OrderViewController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/27.
//
//

#import "XESuperViewController.h"

@interface OrderViewController : XESuperViewController
//全部
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
//待付款
@property (weak, nonatomic) IBOutlet UIButton *needPayBtn;
//预约券
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
//电子券
@property (weak, nonatomic) IBOutlet UIButton *electronCardBtn;
//退款单
@property (weak, nonatomic) IBOutlet UIButton *reimburseBtn;


@property (weak, nonatomic) IBOutlet UILabel *changeLab;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;

/**
 *  全部
 */
@property (strong, nonatomic) IBOutlet UIView *allView;
/**
 *  全部Tab
 */
@property (weak, nonatomic) IBOutlet UITableView *allTab;
/**
 *  待付款
 */
@property (strong, nonatomic) IBOutlet UIView *needPayView;
/**
 *  待付款Tab
 */
@property (weak, nonatomic) IBOutlet UITableView *needPayTab;
/**
 *  电子券
 */
@property (strong, nonatomic) IBOutlet UIView *electronView;
/**
 *  电子券Tab
 */
@property (weak, nonatomic) IBOutlet UITableView *electronTab;
/**
 *  预约券
 */
@property (strong, nonatomic) IBOutlet UIView *orderView;
/**
 *  预约券Tab
 */
@property (weak, nonatomic) IBOutlet UITableView *orderTab;
/**
 *  退款单
 */
@property (strong, nonatomic) IBOutlet UIView *reimburseView;
/**
 *  退款单Tab
 */
@property (weak, nonatomic) IBOutlet UITableView *reimburseTab;
//删除订单view
@property (strong, nonatomic) IBOutlet UIView *deleteOrderView;
//删除订单页面 取消按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteOrderCancleBtn;
//删除订单页面 确定按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteOrderVerifyBtn;


//取消订单原因view
@property (strong, nonatomic) IBOutlet UIView *cancleOrderReasonView;
//取消订单的pickerview
@property (weak, nonatomic) IBOutlet UIPickerView *canclePickerView;
//取消订单界面 取消按钮
@property (weak, nonatomic) IBOutlet UIButton *cancleReasonCanlceBtn;
//取消订单界面 确定按钮
@property (weak, nonatomic) IBOutlet UIButton *cancaleReasonVerifyBtn;

//即将过期view
@property (strong, nonatomic) IBOutlet UIView *outOfDateView;


@end
