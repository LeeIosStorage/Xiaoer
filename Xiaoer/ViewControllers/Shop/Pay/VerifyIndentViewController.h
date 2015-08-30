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
//有详情
@property (strong, nonatomic) IBOutlet UIView *addAddressView;
//无详情
@property (strong, nonatomic) IBOutlet UIView *addAddressViewB;

@property (weak, nonatomic) IBOutlet UILabel *InfoName;

@property (weak, nonatomic) IBOutlet UILabel *infoPhone;

@property (weak, nonatomic) IBOutlet UILabel *infoAddress;


//支付和配送方式
@property (strong, nonatomic) IBOutlet UIView *payAndGiveView;
@property (strong, nonatomic) IBOutlet UIView *payAndGiveViewB;

//发票
@property (strong, nonatomic) IBOutlet UIView *debitView;
//备注留言
@property (strong, nonatomic) IBOutlet UIView *noteView;
@property (strong, nonatomic) IBOutlet UIView *noteViewB;

@property (strong, nonatomic) IBOutlet UIView *footer;
/**
 *  优惠券
 */
@property (strong, nonatomic) IBOutlet UIView *coupon;
/**
 *  选择优惠券按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *chooseCouponBtn;
/**
 *  使用优惠券按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *useCouponBtn;

//底部的支付界面
@property (strong, nonatomic) IBOutlet UIView *bottomPayView;


//底部提示添加地址按钮
@property (weak, nonatomic) IBOutlet UIButton *bottomSetAddressBtn;
//底部提示设置地址lable
@property (weak, nonatomic) IBOutlet UILabel *bottomSetAddressLab;


@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property (weak, nonatomic) IBOutlet UITextView *noteTextField;
//footview总价
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
//优惠
@property (weak, nonatomic) IBOutlet UILabel *favorableLab;
//运费
@property (weak, nonatomic) IBOutlet UILabel *freightLab;
//footerView 需支付
@property (weak, nonatomic) IBOutlet UILabel *bottomNeedPay;
//选择优惠券的界面
@property (strong, nonatomic) IBOutlet UIView *pickeBackView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
/**
 *  确定使用优惠券按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *choosePickerBtn;


/**
 *  shopArray
 */
@property (nonatomic,strong)NSMutableArray *shopArray;
@end
