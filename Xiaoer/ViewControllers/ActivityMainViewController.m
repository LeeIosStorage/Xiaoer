//
//  ActivityMainViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/25.
//
//

#import "ActivityMainViewController.h"
#import "ActivityMainCell.h"
#import "ShopActivityController.h"
#import "MJRefresh.h"
@interface ActivityMainViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ActivityMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动";
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.tabView.backgroundColor = [UIColor clearColor];
    [self.tabView registerNib:[UINib nibWithNibName:@"ActivityMainCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self setupRefresh];//调用刷新方法

    // Do any additional setup after loading the view from its nib.
}


//刷新
- (void)setupRefresh{
    //下拉刷新(头部控件刷新的2种方法)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    
    [self.tabView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    
    //自动刷新(一进入程序就下拉刷新)
    [self.tabView headerBeginRefreshing];
    
}

#pragma mark 头部刷新
- (void)headerRefreshing{
    //添加数据（刷新一次，新添加5个数据）
    
    // 2.2秒后刷新表格UI
    NSLog(@"SHUAIXN");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tabView reloadData];
        // 调用endRefreshing可以结束刷新状态
        [self.tabView headerEndRefreshing];
    });
    
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopActivityController *activityList = [[ShopActivityController alloc]init];
    [self.navigationController pushViewController:activityList animated:YES];
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
