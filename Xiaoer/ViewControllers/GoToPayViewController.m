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

@interface GoToPayViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation GoToPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    [self configureGoToPayTab];
    NSLog(@"orderPrice == %@  orderNum == %@ ",self.orderPrice,self.orderNum);
    self.orderNumLab.text = self.orderNum;
    self.orderPriceLab.text = self.orderPrice;
    //接收支付成功的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccess:) name:@"success" object:nil];
    

    // Do any additional setup after loading the view from its nib.
}
- (void)paySuccess:(NSNotificationCenter *)sender{
    ToyDetailViewController *detail = [[ToyDetailViewController alloc]init];
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self.navigationController popToViewController:detail animated:YES];
}
- (void)configureGoToPayTab{
    [self.goToPayTabView registerNib:[UINib nibWithNibName:@"GoToPayCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    self.goToPayTabView.dataSource = self;
    self.goToPayTabView.delegate = self;
    self.goToPayTabView.tableHeaderView = self.tabHeader;
    self.goToPayTabView.tableFooterView = self.tabFooter;
    
}
- (IBAction)payBtnTouched:(id)sender {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    Order *order = [[Order alloc] init];
    order.partner = appDelegate.patener;
    order.seller = appDelegate.seller;
    order.tradeNO = self.orderNum; //订单ID（由商家自行制定）
    order.productName = @"晓儿"; //商品标题
    order.productDescription = @"晓儿"; //商品描述
    order.amount = @"0.01"; //商品价格
    
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
                /**
                 *  定位到商品详情页面 pop过去
                 */
                
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[ToyDetailViewController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoToPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
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
