//
//  VerifyIndentViewController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/21.
//
//

#import "XESuperViewController.h"

@interface VerifyIndentViewController : XESuperViewController
//底部的设置地址
@property (strong, nonatomic) IBOutlet UIView *firstSetAddressView;
//头部添加地址
@property (strong, nonatomic) IBOutlet UIView *addAddressView;
//支付和配送方式
@property (strong, nonatomic) IBOutlet UIView *payAndGiveView;
//发票
@property (strong, nonatomic) IBOutlet UIView *debitView;
@property (strong, nonatomic) IBOutlet UIView *noteView;
@property (strong, nonatomic) IBOutlet UIView *tabFooterView;
//底部的支付界面
@property (strong, nonatomic) IBOutlet UIView *bottomPayView;


//底部提示添加地址按钮
@property (weak, nonatomic) IBOutlet UIButton *bottomSetAddressBtn;
@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;

@end
