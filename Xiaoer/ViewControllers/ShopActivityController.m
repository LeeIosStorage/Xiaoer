//
//  ShopActivityController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/25.
//
//

#import "ShopActivityController.h"
#import "SearchListViewController.h"
//#import "ActivityDetailController.h"
#import "ToyDetailViewController.h"
#import "ShopActivityCell.h"
@interface ShopActivityController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ShopActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动";
    [self setRightButtonWithImageName:@"shopSearchBar" selector:@selector(pushToSearch)];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.tabView.backgroundColor = [UIColor clearColor];
    [self.tabView registerNib:[UINib nibWithNibName:@"ShopActivityCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tabView.delegate = self;
    self.tabView.dataSource  = self;
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell configureCellWith:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ActivityDetailController *detail = [[ActivityDetailController alloc]init];
    ToyDetailViewController *detail = [[ToyDetailViewController alloc]init];
    [self.navigationController pushViewController:detail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)pushToSearch{
    SearchListViewController *search = [[SearchListViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
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
