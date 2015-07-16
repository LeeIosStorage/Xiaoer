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
@interface OrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)XEOrderDetailInfo *info;
@end

@implementation OrderDetailViewController

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
        }
        self.info = [XEOrderDetailInfo objectWithKeyValues:jsonRet[@"object"]];
        
        self.footerCarriey.text =  [NSString stringWithFormat:@"运费：%.2f",[self.info.carriage floatValue]/100];
         self.footerTotalNum.text = [NSString stringWithFormat:@"共%@件商品",self.info.total];
        self.footerMoney.text = [NSString stringWithFormat:@"%.2f元",[self.info.money floatValue]/100];
        self.footerProviderNo.text = self.info.orderProviderNo;
        self.footerDealTime.text = self.info.orderTime;
        
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
            return 220;
        }
        if([good goodReturnEticketsArray].count == 0  && [good.id isEqualToString:firstGood.id]){
            //第一个 无有预约信息
            return 155;
        }
        if([good goodReturnEticketsArray].count == 0  && ![good.id isEqualToString:firstGood.id]){
            //不是一个 无有预约信息
            return 115;
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
        [card configureCellWith:good indexPath:indexPath];
        return card;
    }else{
        OrderDetailShopCell *shop = [tableView dequeueReusableCellWithIdentifier:@"shop" forIndexPath:indexPath];
        return shop;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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
    self.surplusLab.layer.cornerRadius = 5;
    self.surplusLab.layer.masksToBounds = YES;
    
    self.contactService.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contactService.layer.borderWidth = 1;
    self.contactService.layer.cornerRadius = 10;
    
    self.phoneBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.phoneBtn.layer.borderWidth = 1;
    self.phoneBtn.layer.cornerRadius = 10;
    
    
    self.shopSectionHeaderBtn.layer.cornerRadius = 5;
    self.shopSectionHeaderBtn.layer.masksToBounds = YES;
    self.shopSectionHeaderBtn.layer.borderWidth = 1;
    self.shopSectionHeaderBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    
    self.delateOrder.layer.cornerRadius = 5;
    self.delateOrder.layer.masksToBounds = YES;
    self.delateOrder.layer.borderWidth = 1;
    self.delateOrder.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    self.cardOrder.layer.cornerRadius = 5;
    self.cardOrder.layer.masksToBounds = YES;
    
    
    self.applyReimburseBtn.layer.cornerRadius = 5;
    self.applyReimburseBtn.layer.masksToBounds = YES;
    self.applyReimburseBtn.layer.borderWidth = 1;
    self.applyReimburseBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
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
#pragma mark  预约信息按钮点击
- (IBAction)toOrderInfoMation:(id)sender {
    NSLog(@"预约信息");
    OrderInfomationController *infomation = [[OrderInfomationController alloc]init];
    [self.navigationController pushViewController:infomation animated:YES];
}

#pragma mark  申请退款
- (IBAction)applyReimburseBtnTouched:(id)sender {
    OrderApplyReimburseController  *apply = [[OrderApplyReimburseController alloc]init];
    [self.navigationController pushViewController:apply animated:YES];
    
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
