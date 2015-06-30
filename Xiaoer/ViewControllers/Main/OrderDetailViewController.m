//
//  OrderDetailViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/28.
//
//

#import "OrderDetailViewController.h"
#import "OrderCell.h"

@interface OrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self congigureTableView];
    [self creatTableViewHeadeView];
    [self configureBtnLayer];

    // Do any additional setup after loading the view from its nib.
}

- (IBAction)contactServiceBtnTouched:(id)sender {
    NSLog(@"联系客服");
}

- (IBAction)phoneBtnTouched:(id)sender {
    NSLog(@"拨打电话");
}

#pragma mark 布局button的layer
- (void)configureBtnLayer{
    self.surplusLab.layer.cornerRadius = 5;
    self.surplusLab.layer.masksToBounds = YES;
    
    self.contactService.layer.borderColor = [UIColor darkTextColor].CGColor;
    self.contactService.layer.borderWidth = 1;
    self.contactService.layer.cornerRadius = 10;
    
    self.phoneBtn.layer.borderColor = [UIColor darkTextColor].CGColor;
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
    
}
#pragma mark 布局tableview属性
- (void)congigureTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource  =self;
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = self.footerView;

}

#pragma mark 创建tableHeaderView
- (void)creatTableViewHeadeView{
    UIView *headerView = [[UIView alloc]init];
    UIView *resultAddressView = [self returnResultAddressView];
    
    resultAddressView.frame = CGRectMake(0, self.dealState.frame.size.height, SCREEN_WIDTH, resultAddressView.frame.size.height);
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.dealState.frame.size.height + resultAddressView.frame.size.height);
    headerView.backgroundColor = [UIColor whiteColor];
    self.dealState.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    [headerView addSubview:self.dealState];
    [headerView addSubview:resultAddressView];
    self.tableView.tableHeaderView = headerView;
    
}

- (UIView *)returnResultAddressView{
    return self.cardAddressView;
}
#pragma mark  tableview delegate

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 50;
    }
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
