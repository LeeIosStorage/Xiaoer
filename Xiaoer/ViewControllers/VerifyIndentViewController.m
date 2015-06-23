//
//  VerifyIndentViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/21.
//
//

#import "VerifyIndentViewController.h"
#import "AddAddressViewController.h"
#import "PayAndDistributionViewController.h"
#import "GoToPayViewController.h"
#import "VerifyIndentCell.h"
#import "AddressManagerController.h"
@interface VerifyIndentViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation VerifyIndentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    self.tabView.backgroundColor = [UIColor clearColor];
    self.firstSetAddressView.frame = CGRectMake(0, SCREEN_HEIGHT - 80, SCREEN_WIDTH, 80);
    [self.tabView registerNib:[UINib nibWithNibName:@"VerifyIndentCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    self.tabView.tableFooterView = self.tabFooterView;
//    [self.view addSubview:self.firstSetAddressView];
    self.bottomPayView.frame = CGRectMake(0, SCREEN_HEIGHT - 60, [UIScreen mainScreen].bounds.size.width, 60);
    self.verifyBtn.frame = CGRectMake(SCREEN_WIDTH - 80, 10, 60, 40);
    self.verifyBtn.layer.cornerRadius = 10;
    self.verifyBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.bottomPayView];
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 155;
    }else if (indexPath.row == 1 ){
        return 150;
    }else if (indexPath.row == 2){
        return 50;
    }else if (indexPath.row == 3){
        return 115;
    }
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VerifyIndentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        
        self.addAddressView.frame = CGRectMake(0,15, [UIScreen mainScreen].bounds.size.width, 140);
        
        [cell configureCellWith:self.addAddressView andIndesPath:indexPath];
        
    }else if (indexPath.row == 1 ){
        
        self.payAndGiveView.frame = CGRectMake(0, 15, [UIScreen mainScreen].bounds.size.width, 135);

        [cell configureCellWith:self.payAndGiveView andIndesPath:indexPath];
        
    }else if (indexPath.row == 2){
        
        self.debitView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);

        [cell configureCellWith:self.debitView andIndesPath:indexPath];
        
    }else if (indexPath.row == 3){
        
        self.noteView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
        [cell configureCellWith:self.noteView andIndesPath:indexPath];
        
    }else{
        
        cell.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        [cell configureCellWith:nil andIndesPath:indexPath];
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        AddressManagerController *manager = [[AddressManagerController alloc]init];
        [self.navigationController pushViewController:manager animated:YES];
    }else if (indexPath.row == 1){
        PayAndDistributionViewController *pay = [[PayAndDistributionViewController alloc]init];
       [self.navigationController pushViewController:pay animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (IBAction)headerAddRessBtn:(id)sender {
//    AddAddressViewController *addAddress = [[AddAddressViewController alloc]init];
//    [self.navigationController pushViewController:addAddress animated:YES];
//    NSLog(@"点击头部设置地址按钮");
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (IBAction)showShopDetail:(id)sender {
//    NSLog(@"点击商品详情");
//}
//- (IBAction)payAndGive:(id)sender {
//    NSLog(@"点击支付和配送方式");
//    PayAndDistributionViewController *pay = [[PayAndDistributionViewController alloc]init];
//    [self.navigationController pushViewController:pay animated:YES];
//}
//- (IBAction)needdebit:(id)sender {
//    NSLog(@"发票");
//}
//- (IBAction)veryBtnToouced:(id)sender {
//    NSLog(@"确定按钮点击");
//    GoToPayViewController *toPay = [[GoToPayViewController alloc]init];
//    [self.navigationController pushViewController:toPay animated:YES];
//}
- (IBAction)bottonAddRessBtnTouched:(id)sender {
    NSLog(@"底部添加地址按钮");
    AddAddressViewController *addAddress = [[AddAddressViewController alloc]init];
    [self.navigationController pushViewController:addAddress animated:YES];
}
- (IBAction)veryBtnToouced:(id)sender {
        NSLog(@"确定按钮点击");
        GoToPayViewController *toPay = [[GoToPayViewController alloc]init];
        [self.navigationController pushViewController:toPay animated:YES];
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
