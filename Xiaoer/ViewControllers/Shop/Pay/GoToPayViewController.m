//
//  GoToPayViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/21.
//
//

#import "GoToPayViewController.h"
#import "PaySuccessViewController.h"
#import "GoToPayCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AppDelegate.h"
#import "XEEngine.h"
#import "DataSigner.h"
#import "XEProgressHUD.h"
#import "Order.h"
#import "ToyDetailViewController.h"
#import "BabyImpressPrintController.h"
#import "BabyImpressMainController.h"
#import "BabyImpressDeclareViewController.h"
@interface GoToPayViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation GoToPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";

    //接收支付成功的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccess:) name:@"success" object:nil];
    UILabel *remindLab = [[UILabel alloc]init];
    remindLab.numberOfLines = 0;
    
    if ([self.from isEqualToString:@"0"]) {
        remindLab.text = @"订单提交成功，请尽快付款，30分钟未付款将取消";
        remindLab.frame = CGRectMake(60, 10, SCREEN_WIDTH - 60 - 15, 40);
        self.specialtyBtn.hidden = NO;
    }else if ([self.from isEqualToString:@"1"]){
        remindLab.frame = CGRectMake(15, 10, SCREEN_WIDTH - 30, 40);
        self.specialtyBtn.hidden = YES;
        remindLab.text = @"订单提交成功，请尽快付款，我们将会在每月的最后一天24点取消未付款的订单";
    }else if ([self.from isEqualToString:@"2"]){
        remindLab.frame = CGRectMake(20, 10, SCREEN_WIDTH - 40, 40);
        self.specialtyBtn.hidden = YES;
        remindLab.text = @"1、参与“10分公益，宝宝印像”活动，用户每献出1角钱即得10个“爱心分”。\n2、用户首月可献2元即200个“爱心分”，次月始可献1元即100个“爱心分”。\n3、10个“爱心分”可兑换一张6寸照片的冲印权。";
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName, nil];
        
        CGRect rect = [remindLab.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        CGRect textFram = remindLab.frame;
        textFram.size.height = rect.size.height ;
        remindLab.frame = textFram;
        
        CGRect headerFrame = self.tabHeader.frame;
        headerFrame.size.height += (rect.size.height - 40);
        self.tabHeader.frame = headerFrame;
        
        [self setRightButtonWithImageName:@"babyAsk" selector:@selector(showLoveDeclare)];
    }
    [self.tabHeader addSubview:remindLab];
    [self configureGoToPayTab];

}
- (void)showLoveDeclare{
    BabyImpressDeclareViewController *declare = [[BabyImpressDeclareViewController alloc]init];
    [self.navigationController pushViewController:declare animated:YES];
}
- (void)paySuccess:(NSNotificationCenter *)sender{
    ToyDetailViewController *detail = [[ToyDetailViewController alloc]init];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)configureGoToPayTab{
    self.orderNumLab.text = self.orderNum;
    self.orderPriceLab.text = self.orderPrice;
    [self.goToPayTabView registerNib:[UINib nibWithNibName:@"GoToPayCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    self.goToPayTabView.dataSource = self;
    self.goToPayTabView.delegate = self;
    self.goToPayTabView.tableHeaderView = self.tabHeader;
    self.goToPayTabView.tableFooterView = self.tabFooter;
    
}
- (IBAction)payBtnTouched:(id)sender {
    /**
     *  判断是是否安装了支付宝
     */
    if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
        [XEProgressHUD AlertError:@"您的设备没有安装支付宝"];
//        NSURL *url = [[ NSURL alloc ] initWithString: @"http://itunes.apple.com/app/id330206289"] ;
//        [[UIApplication sharedApplication] openURL:url];
        return;
    }
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    Order *order = [[Order alloc] init];
    order.partner = appDelegate.patener;
    order.seller = appDelegate.seller;
    order.tradeNO = self.orderNum; //订单ID（由商家自行制定）
    order.productName = @"晓儿"; //商品标题
    order.productDescription = @"晓儿"; //商品描述
//    order.amount = self.orderPriceLab.text; //商品价格
    order.amount = @"0.01"; //商品价格

    if ([self.from isEqualToString:@"0"]) {
        NSString *url = [NSString stringWithFormat:@"%@/common/alipayorder/payed", [[XEEngine shareInstance] baseUrl]];
        order.notifyURL = url;//回调URl
    }
    
    if ([self.from isEqualToString:@"1"]) {
        NSString *url = [NSString stringWithFormat:@"%@/common/alipayorder/photoLovePayed", [[XEEngine shareInstance] baseUrl]];
        order.notifyURL = url;//回调URl
    }
    if ([self.from isEqualToString:@"2"]) {
        NSString *url = [NSString stringWithFormat:@"%@/common/alipayorder/lovePayed", [[XEEngine shareInstance] baseUrl]];
        order.notifyURL = url;//回调URl
    }
    
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
    //获取快捷支付单例并调用快捷支付接口

        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSString *string = resultDic[@"resultStatus"];
            NSString *memo = resultDic[@"memo"];
//            if (memo.length > 0) {
//                [XEProgressHUD lightAlert:memo];
//            }
            
            if ([string isEqualToString:@"9000"]) {
                [XEProgressHUD AlertSuccess:@"支付成功"];
                if ([self.from isEqualToString:@"0"]) {
                    /**
                     *  定位到商品详情页面 pop过去
                     */
                    
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[ToyDetailViewController class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                        }
                    }
                }
                
                if ([self.from isEqualToString:@"1"]) {
                    [[XEEngine shareInstance]refreshUserInfo];

                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[BabyImpressPrintController class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                        }
                    }
                }
                
                
                if ([self.from isEqualToString:@"2"]) {
                    [[XEEngine shareInstance]refreshUserInfo];
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[BabyImpressMainController class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                        }
                    }
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

#pragma mark tableView Delagate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoToPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    [cell configureCellWith:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
