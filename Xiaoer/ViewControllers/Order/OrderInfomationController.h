//
//  OrderInfomationController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/2.
//
//

#import "XESuperViewController.h"
#import "XEOrderGoodInfo.h"
#import "XEOrderDetailInfo.h"
@interface OrderInfomationController : XESuperViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  动画的视图
 */
@property (strong, nonatomic) IBOutlet UIView *dataBackView;
/**
 *  取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
/**
 *  确定按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *dataVetifyBtn;
/**
 *  选择器
 */
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPickerView;

//卡券选择器背景图
@property (strong, nonatomic) IBOutlet UIView *cardPickerBackView;
//卡券取消按钮
@property (weak, nonatomic) IBOutlet UIButton *cardCancleBtn;
//卡券确定按钮
@property (weak, nonatomic) IBOutlet UIButton *cardVerifyBtn;
//卡券pickerview
@property (weak, nonatomic) IBOutlet UIPickerView *cardPickerView;





@property (nonatomic,strong)XEOrderGoodInfo *goodInfo;
@property (nonatomic,strong)XEOrderDetailInfo *detail;

@end
