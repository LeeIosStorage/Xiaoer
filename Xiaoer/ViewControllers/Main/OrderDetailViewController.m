//
//  OrderDetailViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/28.
//
//

#import "OrderDetailViewController.h"
#import "OrderCell.h"
#import "OrderInfomationController.h"
#import "OrderApplyReimburseController.h"
#import "OrderDreailCardCell.h"
@interface OrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.tableView.tableHeaderView = self.dealState;
    [self congigureTableView];
    [self configureBtnLayer];

    // Do any additional setup after loading the view from its nib.
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

#pragma mark 布局tableview属性
- (void)congigureTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource  =self;
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderDreailCardCell" bundle:nil] forCellReuseIdentifier:@"cardCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = self.footerView;

}

#pragma mark 创建tableHeaderView
//- (void)creatTableViewHeadeView{
//    UIView *headerView = [[UIView alloc]init];
//    UIView *resultAddressView = [self returnResultAddressView];
//    
//    resultAddressView.frame = CGRectMake(0, self.dealState.frame.size.height, SCREEN_WIDTH, resultAddressView.frame.size.height);
//    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.dealState.frame.size.height + resultAddressView.frame.size.height);
//    headerView.backgroundColor = [UIColor whiteColor];
//    self.dealState.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
//    [headerView addSubview:self.dealState];
//    [headerView addSubview:resultAddressView];
//    self.tableView.tableHeaderView = headerView;
//    
//}

//- (UIView *)returnResultAddressView{
//    return self.cardAddressView;
//}
#pragma mark  申请退款
- (IBAction)applyReimburseBtnTouched:(id)sender {
    OrderApplyReimburseController  *apply = [[OrderApplyReimburseController alloc]init];
    [self.navigationController pushViewController:apply animated:YES];

}


#pragma mark  tableview delegate

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 140;
    }else{
        return 220;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 50;
    }
    return 40;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == 0) {
//        return 10;
//    }else{
//        return 75;
//    }
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        self.cardSectionHeader.frame = CGRectMake(0, 10, SCREEN_WIDTH, 40);
        [view addSubview:self.cardSectionHeader];
        return view;
    }else{
        return self.shopSectionHeader;
    }
}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section == 1) {
//        return self.cardAddressView;
//    }
//    return nil;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        OrderDreailCardCell *card = [tableView dequeueReusableCellWithIdentifier:@"cardCell" forIndexPath:indexPath];
        return card;
    }
    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
