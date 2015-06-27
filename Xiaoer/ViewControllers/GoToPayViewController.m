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
@interface GoToPayViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation GoToPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    [self.goToPayTabView registerNib:[UINib nibWithNibName:@"GoToPayCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    self.goToPayTabView.dataSource = self;
    self.goToPayTabView.delegate = self;
    self.goToPayTabView.tableHeaderView = self.tabHeader;
    self.goToPayTabView.tableFooterView = self.tabFooter;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)payBtnTouched:(id)sender {
    NSLog(@"去支付");
    PaySuccessViewController *success = [[PaySuccessViewController alloc]init];
    [self.navigationController pushViewController:success animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
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
