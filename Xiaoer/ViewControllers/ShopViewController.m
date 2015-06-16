//
//  ShopViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/3.
//
//

#import "ShopViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"

@interface ShopViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *headerView;
@property (weak, nonatomic) IBOutlet UITableView *shopTabView;

@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商城";
    self.pullRefreshView = [[PullToRefreshView alloc] initWithScrollView:self.shopTabView];
    self.pullRefreshView.delegate = self;
    [self.shopTabView addSubview:self.pullRefreshView];
    [self.shopTabView addInfiniteScrollingWithActionHandler:^{
    }];
    
    [self.shopTabView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    // Do any additional setup after loading the view from its nib.
    self.shopTabView.tableHeaderView = self.headerView;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height- 64)];
    imageView.image = [UIImage imageNamed:@"正在建设中6p"];
    [self.view addSubview:imageView];
    
    self.navigationItem.leftBarButtonItem = nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 23;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
    
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
