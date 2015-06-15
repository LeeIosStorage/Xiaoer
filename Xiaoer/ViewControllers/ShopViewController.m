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
    
    self.pullRefreshView = [[PullToRefreshView alloc] initWithScrollView:self.shopTabView];
    self.pullRefreshView.delegate = self;
    [self.shopTabView addSubview:self.pullRefreshView];
    [self.shopTabView addInfiniteScrollingWithActionHandler:^{
        
    }];
    
    [self.shopTabView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    // Do any additional setup after loading the view from its nib.
    self.shopTabView.tableHeaderView = self.headerView;
//    [self.view addSubview:self.shopTabView];
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
