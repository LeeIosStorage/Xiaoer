//
//  OrderDetailViewController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/28.
//
//

#import "XESuperViewController.h"

@interface OrderDetailViewController : XESuperViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  交易状态（最上部显示）
 */
@property (strong, nonatomic) IBOutlet UIView *dealState;
@property (strong, nonatomic) IBOutlet UIView *cardAddressView;
@property (strong, nonatomic) IBOutlet UIView *otherAddressView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIView *cardSectionHeader;
@property (strong, nonatomic) IBOutlet UIView *shopSectionHeader;
/**
 *  剩余使用次数的lable
 */
@property (weak, nonatomic) IBOutlet UILabel *surplusLab;
/**
 *  联系客服按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *contactService;
/**
 *  拨打电话按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
/**
 *  区头显示商城的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *shopSectionHeaderBtn;
/**
 *  删除订单
 */
@property (weak, nonatomic) IBOutlet UIButton *delateOrder;
/**
 *  预约信息
 */
@property (weak, nonatomic) IBOutlet UIButton *cardOrder;

@end
