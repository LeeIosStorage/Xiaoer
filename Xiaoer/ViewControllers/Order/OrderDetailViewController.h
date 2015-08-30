//
//  OrderDetailViewController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/28.
//
//

#import "XESuperViewController.h"

#import "XEOrderInfo.h"


@protocol detailRrfreshData <NSObject>

- (void)detailSuccessRrfreshData;
- (void)detailPaySuccessDelegate;

@end

@interface OrderDetailViewController : XESuperViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  商品交易状态（最上部显示）
 */
@property (strong, nonatomic) IBOutlet UIView *topShopState;
/**
 *  交易状态
 */
@property (weak, nonatomic) IBOutlet UILabel *shopState;
/**
 *  订单金额
 */
@property (weak, nonatomic) IBOutlet UILabel *orderPric;
/**
 *  订单运费
 */
@property (weak, nonatomic) IBOutlet UILabel *carriey;
/**
 *  收货人
 */
@property (weak, nonatomic) IBOutlet UILabel *receivePeople;
/**
 *  收货人
 */
@property (weak, nonatomic) IBOutlet UILabel *receivePeoplePhone;
/**
 *  收获地址
 */
@property (weak, nonatomic) IBOutlet UILabel *receivePeopleAddress;



/**
 *  卡券交易top
 */
@property (strong, nonatomic) IBOutlet UIView *topCardState;
/**
 *  卡券交易状态
 */
@property (weak, nonatomic) IBOutlet UILabel *topCardStateState;
/**
 *  卡券金额
 */
@property (weak, nonatomic) IBOutlet UILabel *cardPrice;
/**
 *  卡券运费
 */
@property (weak, nonatomic) IBOutlet UILabel *cardCarriey;


@property (strong, nonatomic) IBOutlet UIView *cardAddressView;
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
 *  预约信息
 */
@property (weak, nonatomic) IBOutlet UIButton *cardOrder;

/**
 *  联系客服 拨打电话 背景图
 */
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;

/**
 *  申请退款ID
 */
@property (nonatomic,strong)NSString *orderproviderid;


/**
 *  末尾商品数量
 */
@property (weak, nonatomic) IBOutlet UILabel *footerTotalNum;
/**
 *  末尾运费
 */
@property (weak, nonatomic) IBOutlet UILabel *footerCarriey;
/**
 *  末尾实付
 */
@property (weak, nonatomic) IBOutlet UILabel *footerMoney;
/**
 *  末尾订单号
 */
@property (weak, nonatomic) IBOutlet UILabel *footerProviderNo;
/**
 *  末尾交易时间
 */
@property (weak, nonatomic) IBOutlet UILabel *footerDealTime;


@property (nonatomic,assign)id<detailRrfreshData>delegte;


@end
