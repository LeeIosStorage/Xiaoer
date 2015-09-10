//
//  XEAppOrderVerifyController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/9/8.
//
//

#import "XEAppOrderVerifyController.h"
#import "AppOrderInfomationCell.h"
#import "AppOrderVerifyHeader.h"

#import <AlipaySDK/AlipaySDK.h>
#import "AppDelegate.h"
#import "DataSigner.h"
#import "Order.h"

@interface XEAppOrderVerifyController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UIButton *pay;
- (IBAction)pay:(id)sender;

@end

@implementation XEAppOrderVerifyController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.title = @"预约挂号";

    self.pay.layer.cornerRadius = 5;
    self.pay.layer.masksToBounds = YES;
    [self configureTableView];
    // Do any additional setup after loading the view from its nib.
}
- (void)configureTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"AppOrderInfomationCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = self.footerView;
    self.tableView.sectionHeaderHeight =[AppOrderVerifyHeader appOrderVerifyHeader].frame.size.height;
    self.tableView.sectionFooterHeight = 0;

    
}

#pragma mark --- UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [AppOrderVerifyHeader appOrderVerifyHeader].frame.size.height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    AppOrderVerifyHeader *header = [AppOrderVerifyHeader appOrderVerifyHeader];
    header.backgroundColor = LGrayColor;
    if (section == 0)
    {
        header.image.image = [UIImage imageNamed:@"appClock"];
        header.titleLab.text = @"预约信息";

    }else if (section == 1)
    {
        header.image.image = [UIImage imageNamed:@"VerifyPayAndDelivery"];
        header.titleLab.text = @"支付订单";
    }
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppOrderInfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    [cell configureVerifyCellWith:indexPath dic:self.dic];
    return cell;
}


- (IBAction)pay:(id)sender {
    XELog(@"pay");
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
    order.tradeNO = self.dic[@"orderNo"]; //订单ID（由商家自行制定）
    order.productName = @"晓儿"; //商品标题
//    order.productDescription = @"晓儿"; //商品描述
//    CGFloat money = [self.dic[@"money"] floatValue];
//    order.amount = [NSString stringWithFormat:@"%.2f",money*0.01];//商品价格
    order.amount = @"0.01"; //商品价格
    NSString *url = [NSString stringWithFormat:@"%@/common/alipayorder/hospitalPayed", [[XEEngine shareInstance] baseUrl]];
    order.notifyURL = url;//回调URl

    
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
            if ([string isEqualToString:@"9000"]) {
                [XEProgressHUD AlertSuccess:@"支付成功"];
                    /**
                     *   pop过去
                     */
//                    for (UIViewController *controller in self.navigationController.viewControllers) {
//                        if ([controller isKindOfClass:[ToyDetailViewController class]]) {
//                            [self.navigationController popToViewController:controller animated:YES];
//                        }
                }

                
                
            else if ([string isEqualToString:@"4000"]) {
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
@end
