//
//  OrderDetailViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/28.
//
//

#import "OrderDetailViewController.h"
#import "OrderInfomationController.h"
#import "OrderApplyReimburseController.h"
#import "OrderDreailCardCell.h"
#import "XEEngine.h"
#import "OrderDreailCardCell.h"
#import "OrderDetailShopCell.h"

#import "XEProgressHUD.h"

#import "XEOrderDetailInfo.h"
#import "XEOrderSeriesInfo.h"
#import "XEOrderGoodInfo.h"
#import "XEDetailEticketsInfo.h"
#import "MJExtension.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "Order.h"
#import "AppDelegate.h"
@interface OrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ordetBtnDelegate,refreshDataDelegate>
@property (nonatomic,strong)XEOrderDetailInfo *info;

/**
 *  删除订单
 */
@property (nonatomic,strong)UIButton *deleteBtn;
/**
 *  申请退款
 */
@property (nonatomic,strong)UIButton *applyReimburseBtn;

/**
 *  取消订单
 */
@property (nonatomic,strong)UIButton *cancleOrderBtn;
/**
 *  付款按钮
 */
@property (nonatomic,strong)UIButton *buy;
@end

@implementation OrderDetailViewController
- (UIButton *)buy{
    if (!_buy) {
        self.buy = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buy setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_buy setTitle:@"付款" forState:UIControlStateNormal];
        _buy.layer.borderColor = [UIColor orangeColor].CGColor;
        _buy.titleLabel.font = [UIFont systemFontOfSize:15];
        _buy.layer.borderWidth = 1;
        _buy.layer.cornerRadius = 8;
        _buy.frame = CGRectMake(SCREEN_WIDTH - 15 - 70, 125, 70, 30);
        [_buy addTarget:self action:@selector(detailBuyBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buy;
}
- (UIButton *)cancleOrderBtn{
    if (!_cancleOrderBtn) {
        self.cancleOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleOrderBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_cancleOrderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        _cancleOrderBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _cancleOrderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _cancleOrderBtn.layer.borderWidth = 1;
        _cancleOrderBtn.layer.cornerRadius = 8;
        [_cancleOrderBtn addTarget:self action:@selector(DetailCancleOrderBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        _cancleOrderBtn.frame = CGRectMake(15, 125, 90, 30);
    }
    return _cancleOrderBtn;
}
- (UIButton *)applyReimburseBtn{
    if (!_applyReimburseBtn) {
        self.applyReimburseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_applyReimburseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_applyReimburseBtn setTitle:@"申请退款" forState:UIControlStateNormal];
        _applyReimburseBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _applyReimburseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_applyReimburseBtn addTarget:self action:@selector(detailApplyReimburseBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        _applyReimburseBtn.layer.borderWidth = 1;
        _applyReimburseBtn.layer.cornerRadius = 8;
        _applyReimburseBtn.frame = CGRectMake(SCREEN_WIDTH - 15 - 90 , 125, 90, 30);
    }
    return _applyReimburseBtn;
}

- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_deleteBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(detailDeleteOrderBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _deleteBtn.layer.borderWidth = 1;
        _deleteBtn.layer.cornerRadius = 8;
        _deleteBtn.frame = CGRectMake(15, 125, 90, 30);

    }
    return _deleteBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self congigureTableView];
    [self configureBtnLayer];
    [self getOrderDetailData];
    
    
    
#warning 此版本不需要 联系客服和拨打电话 隐藏掉
    self.contactService.frame = CGRectZero;
    self.phoneBtn.frame = CGRectZero;
    self.phoneLab.frame = CGRectZero;
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark 取消订单
- (void)DetailCancleOrderBtnTouched:(UIButton *)sender{
    __weak OrderDetailViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance]cancleOrderWith:tag orderproviderid:self.orderproviderid];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return ;
        }
        
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"取消订单失败" At:weakSelf.view];
            return;
        }

        if ([[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertLoading:@"取消订单成功" At: weakSelf.view];
            if (self.delegte && [self.delegte respondsToSelector:@selector(detailSuccessRrfreshData)]) {
                [self.delegte  detailSuccessRrfreshData];
            }
            [self performSelector:@selector(backToOrder) withObject:nil afterDelay:2];
        }
        
    } tag:tag];
}

#pragma mark 删除订单
- (void)detailDeleteOrderBtnTouched:(UIButton *)button{
    __weak OrderDetailViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance]deleteOrderWith:tag orderproviderid:self.orderproviderid];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return ;
        }
        
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"删除订单失败" At:weakSelf.view];
            return;
        }
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertSuccess:@"删除订单成功" At:weakSelf.view];
            return;
        }
        if ([[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertLoading:@"删除订单成功" At: weakSelf.view];
            if (self.delegte && [self.delegte respondsToSelector:@selector(detailSuccessRrfreshData)]) {
                [self.delegte  detailSuccessRrfreshData];
            }
            [self performSelector:@selector(backToOrder) withObject:nil afterDelay:2];
        }
    } tag:tag];
    
}

#pragma mark 支付请求
- (void)detailBuyBtnTouched{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    Order *order = [[Order alloc] init];
    order.partner = appDelegate.patener;
    order.seller = appDelegate.seller;
    order.tradeNO = self.info.orderProviderNo; //订单ID（由商家自行制定）
    order.productName = @"晓儿"; //商品标题
    order.productDescription = @"晓儿"; //商品描述
    NSString *money = [NSString stringWithFormat:@"%.2f",[self.info.money floatValue]/100];
    order.amount =money; //商品价格
    
    NSString *url = [NSString stringWithFormat:@"%@/common/alipayorder/payed", [[XEEngine shareInstance] baseUrl]];
    order.notifyURL = url;//回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"xiaoerPay";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(appDelegate.privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSString *string = resultDic[@"resultStatus"];
            NSString *memo = resultDic[@"memo"];
            if (memo.length > 0) {
                [XEProgressHUD lightAlert:memo];
            }
            
            if ([string isEqualToString:@"9000"]) {

                [self getOrderDetailData];
                
                if (self.delegte && [self.delegte respondsToSelector:@selector(detailPaySuccessDelegate)]) {
                    [self.delegte detailPaySuccessDelegate];
                }

            } else if ([string isEqualToString:@"4000"]) {
                NSLog(@"系统异常");
                [XEProgressHUD AlertError:@"系统异常"];
                
            }else if ([string isEqualToString:@"6001"]){
                NSLog(@"用户中途取消");
                [XEProgressHUD AlertError:@"用户中途取消,请重新支付"];
                
            }else if ([string isEqualToString:@"6002"]){
                NSLog(@"网络连接出错");
                [XEProgressHUD AlertError:@"网络连接出错"];
                
            }else{
                [XEProgressHUD AlertError:@"支付失败"];
            }
        }];
        
    }

}
- (void)backToOrder{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark  申请退款
- (void)detailApplyReimburseBtnTouched:(UIButton *)sender{
    OrderApplyReimburseController  *apply = [[OrderApplyReimburseController alloc]init];
    apply.delegate = self;
    apply.detailInfo = self.info;
    [self.navigationController pushViewController:apply animated:YES];
}
#pragma mark 获取数据
- (void)getOrderDetailData{
    __weak OrderDetailViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance]getOrderDetailInfomationWith:tag orderproviderid:self.orderproviderid];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return ;
        }
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            return;
        }
        if ([jsonRet[@"object"] isKindOfClass:[NSNull class]]) {
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            return;
        }
        self.info = [XEOrderDetailInfo objectWithKeyValues:jsonRet[@"object"]];
        
        self.footerCarriey.text =  [NSString stringWithFormat:@"运费：%.2f",[self.info.carriage floatValue]/100];
         self.footerTotalNum.text = [NSString stringWithFormat:@"共%@件商品",self.info.total];
        self.footerMoney.text = [NSString stringWithFormat:@"%.2f元",[self.info.money floatValue]/100];
        self.footerProviderNo.text = self.info.orderProviderNo;
        self.footerDealTime.text = self.info.orderTime;
        
        [self.buy removeFromSuperview];
        [self.cancleOrderBtn removeFromSuperview];
        [self.applyReimburseBtn removeFromSuperview];
        [self.deleteBtn removeFromSuperview];
        
        
        if ([self.info.status isEqualToString:@"1"]) {
            //  self.shopState.text = @"待付款";
            [self.footerView addSubview:self.buy];
            [self.footerView addSubview:self.cancleOrderBtn];
        }
        if ([self.info.status isEqualToString:@"2"]) {
            // self.shopState.text = @"已失效";
        }
        if ([self.info.status isEqualToString:@"3"]) {
            //  self.shopState.text = @"待发货";
            [self.footerView addSubview:self.applyReimburseBtn];
        }
        if ([self.info.status isEqualToString:@"4"]) {
            //self.shopState.text = @"已发货";
            [self.footerView addSubview:self.applyReimburseBtn];

        }
        if ([self.info.status isEqualToString:@"5"]) {
            //self.shopState.text = @"待审核";
        }
        if ([self.info.status isEqualToString:@"6"]) {
            //self.shopState.text = @"待审核";
        }
        if ([self.info.status isEqualToString:@"7"]) {
            //self.shopState.text = @"审核退款";
            [self.footerView addSubview:self.deleteBtn];
            
        }
        if ([self.info.status isEqualToString:@"8"]) {
            //self.shopState.text = @"审核不退款";
            [self.footerView addSubview:self.deleteBtn];
        }
        
        if ([self.info.status isEqualToString:@"9"]) {
            //self.shopState.text = @"关闭交易";
            [self.footerView addSubview:self.deleteBtn];
        }
        
        self.tableView.tableFooterView = self.footerView;
        self.tableView.tableHeaderView = [self creatTableViewHeadeView];
        
        [self.tableView reloadData];
        
    } tag:tag];
}



#pragma mark 创建tableHeaderView

- (UIView *)creatTableViewHeadeView{
    UIView *resultAddressView = [self returnResultAddressView];
    resultAddressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, resultAddressView.frame.size.height);
    return resultAddressView;
}

- (UIView *)returnResultAddressView{
    BOOL ifHaveCard = NO;
    
    if (self.info) {
        for (XEOrderGoodInfo *good in [self.info detailReturnAllGoodsesInfo]) {
            if ([good.type isEqualToString:@"2"]) {
                ifHaveCard = YES;
            }
        }
        
        if (ifHaveCard == YES) {
            self.topCardState.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
            if ([self.info.status isEqualToString:@"1"]) {
                self.topCardStateState.text = @"待付款";
            }
            if ([self.info.status isEqualToString:@"2"]) {
                self.topCardStateState.text = @"已失效";
            }
            if ([self.info.status isEqualToString:@"3"]) {
                self.topCardStateState.text = @"待发货";
            }
            if ([self.info.status isEqualToString:@"4"]) {
                self.topCardStateState.text = @"已发货";
            }
            if ([self.info.status isEqualToString:@"5"]) {
                self.topCardStateState.text = @"待审核";
            }
            if ([self.info.status isEqualToString:@"6"]) {
                self.topCardStateState.text = @"待审核";
            }
            if ([self.info.status isEqualToString:@"7"]) {
                self.topCardStateState.text = @"审核退款";
            }
            if ([self.info.status isEqualToString:@"8"]) {
                self.topCardStateState.text = @"审核不退款";
            }
            if ([self.info.status isEqualToString:@"9"]) {
                self.topCardStateState.text = @"关闭交易";
            }
            
            self.cardPrice.text = [NSString stringWithFormat:@"%.2f元",[self.info.money floatValue]/100];
            self.cardCarriey.text =[NSString stringWithFormat:@"%.2f元",[self.info.carriage floatValue]/100];
            return self.topCardState;
        } else {
            //商品的top
            //订单状态（1 待付款 2 已失效 3 已付款（待发货）4 已发货 5 未发货的申请退款（待审核） 6 已发货的申请退款退货（待审核）7 审核退款 8 审核不退款 9 关闭交易）
            if ([self.info.status isEqualToString:@"1"]) {
                self.shopState.text = @"待付款";
            }
            if ([self.info.status isEqualToString:@"2"]) {
                self.shopState.text = @"已失效";
            }
            if ([self.info.status isEqualToString:@"3"]) {
                self.shopState.text = @"待发货";
            }
            if ([self.info.status isEqualToString:@"4"]) {
                self.shopState.text = @"已发货";
            }
            if ([self.info.status isEqualToString:@"5"]) {
                self.shopState.text = @"待审核";
            }
            if ([self.info.status isEqualToString:@"6"]) {
                self.shopState.text = @"待审核";
            }
            if ([self.info.status isEqualToString:@"7"]) {
                self.shopState.text = @"审核退款";
            }
            if ([self.info.status isEqualToString:@"8"]) {
                self.shopState.text = @"审核不退款";
            }
            if ([self.info.status isEqualToString:@"9"]) {
                self.shopState.text = @"关闭交易";
            }
            
            self.orderPric.text = [NSString stringWithFormat:@"%.2f元",[self.info.money floatValue]/100];
            self.carriey.text =[NSString stringWithFormat:@"%.2f元",[self.info.carriage floatValue]/100];
            self.receivePeople.text = self.info.linkName;
            self.receivePeopleAddress.text = [NSString stringWithFormat:@"收货地址：%@",self.info.linkAddress];
            self.receivePeoplePhone.text = self.info.linkPhone;
            
            return self.topShopState;
        }

        
    }else{        
        return nil;
    }
    
}


#pragma mark  tableview delegate

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.info detailReturenSeriesInfo].count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    XEOrderSeriesInfo *seriousInfo = [self.info detailReturenSeriesInfo][section];
    return [seriousInfo returnGoodsInfo].count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XEOrderSeriesInfo *seriousInfo = [self.info detailReturenSeriesInfo][indexPath.section];
    XEOrderGoodInfo *good = [seriousInfo returnGoodsInfo][indexPath.row];
    // *  类型（1玩具, 2卡券, 3祈福）
    XEOrderGoodInfo *firstGood = [seriousInfo returnGoodsInfo][0];
    if ([good.type isEqualToString:@"2"]) {
        //卡券
        if([good goodReturnEticketsArray].count > 0  && [good.id isEqualToString:firstGood.id]){
            //第一个 有预约信息
            return 260;
           }
        if([good goodReturnEticketsArray].count > 0  && ![good.id isEqualToString:firstGood.id]){
            //不是第一个 有预约信息
            return 260;
        }
        if([good goodReturnEticketsArray].count == 0  && [good.id isEqualToString:firstGood.id]){
            //第一个 无有预约信息
            return 155;
        }
        if([good goodReturnEticketsArray].count == 0  && ![good.id isEqualToString:firstGood.id]){
            //不是一个 无有预约信息
            return 155;
        }
        
        
    }else{
        //实体商品 不用再判断卡券model
        if ([good.id isEqualToString:firstGood.id]) {
            //第一个
            return 150;
            
        }else{
            return 110;
        }
        
    }
    
    return 0;

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XEOrderSeriesInfo *seriousInfo = [self.info detailReturenSeriesInfo][indexPath.section];
    XEOrderGoodInfo *good = [seriousInfo returnGoodsInfo][indexPath.row];
    // *  类型（1玩具, 2卡券, 3祈福）
    if ([good.type isEqualToString:@"2"]) {
        OrderDreailCardCell *card = [tableView dequeueReusableCellWithIdentifier:@"card" forIndexPath:indexPath];
        [card configureCellWith:good indexPath:indexPath detailInfo:self.info] ;
        card.tag = indexPath.section*1000 + indexPath.row;
        card.delegate = self;
        return card;
    }else{
        OrderDetailShopCell *shop = [tableView dequeueReusableCellWithIdentifier:@"shop" forIndexPath:indexPath];
        [shop confugireShopCellWith:good detailInfo:self.info];
        return shop;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark cell delegate
- (void)orderBtnTouchedWith:(UIButton *)button{
    OrderInfomationController *infomation = [[OrderInfomationController alloc]init];
    
    if (button.tag < 1000) {
        XEOrderSeriesInfo *serious = [self.info detailReturenSeriesInfo][0];
        infomation.goodInfo = [serious returnGoodsInfo][button.tag];
    }else{
        XEOrderSeriesInfo *serious = [self.info detailReturenSeriesInfo][button.tag/1000];
        infomation.goodInfo = [serious returnGoodsInfo][button.tag%1000];

    }
    infomation.detail = self.info;

    [self.navigationController pushViewController:infomation animated:YES];
}
#pragma mark 布局tableview属性
- (void)congigureTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource  =self;
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderDreailCardCell" bundle:nil] forCellReuseIdentifier:@"card"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderDetailShopCell" bundle:nil] forCellReuseIdentifier:@"shop"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 160);
    
}
#pragma mark 布局button的layer
- (void)configureBtnLayer{
//    self.surplusLab.layer.cornerRadius = 5;
//    self.surplusLab.layer.masksToBounds = YES;
//    
//    self.contactService.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.contactService.layer.borderWidth = 1;
//    self.contactService.layer.cornerRadius = 10;
//    
//    self.phoneBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.phoneBtn.layer.borderWidth = 1;
//    self.phoneBtn.layer.cornerRadius = 10;
//    
//    
//    self.shopSectionHeaderBtn.layer.cornerRadius = 5;
//    self.shopSectionHeaderBtn.layer.masksToBounds = YES;
//    self.shopSectionHeaderBtn.layer.borderWidth = 1;
//    self.shopSectionHeaderBtn.layer.borderColor = [UIColor orangeColor].CGColor;
//    
//    
//    
//    self.cardOrder.layer.cornerRadius = 5;
//    self.cardOrder.layer.masksToBounds = YES;
//    
//    
//    self.applyReimburseBtn.layer.cornerRadius = 5;
//    self.applyReimburseBtn.layer.masksToBounds = YES;
//    self.applyReimburseBtn.layer.borderWidth = 1;
//    self.applyReimburseBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

/**
 *  联系客服
 */
#pragma mark  联系客服
- (IBAction)contactServiceBtnTouched:(id)sender {
    NSLog(@"联系客服");
}
/**
 *  拨打电弧
 */
#pragma mark  拨打电话

- (IBAction)phoneBtnTouched:(id)sender {
    NSLog(@"拨打电话");
}





- (void)sucessRefreshData{
    if (self.delegte && [self.delegte respondsToSelector:@selector(detailSuccessRrfreshData)]) {
        [self.delegte detailSuccessRrfreshData];
    }
    
    [self getOrderDetailData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
