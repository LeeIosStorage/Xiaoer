//
//  EveryOneWeekController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/8.
//
//

#import "EveryOneWeekController.h"
#import "OneWeakCell.h"
#import "MJRefresh.h"
@interface EveryOneWeekController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTabView;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@end

@implementation EveryOneWeekController

//- (void)loadView{
//    [super loadView];
////    [self.view addSubview:self.tableView];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainTabView registerNib:[UINib nibWithNibName:@"OneWeakCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cells"];
    self.mainTabView.dataSource = self;
    self.mainTabView.delegate = self;
    self.mainTabView.tableHeaderView = self.headerView;
    [self.mainTabView addHeaderWithTarget:self action:@selector(headerRefreshing)];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)headerRefreshing{
    //添加数据（刷新一次，新添加5个数据）
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.mainTabView reloadData];
        // 调用endRefreshing可以结束刷新状态
        [self.mainTabView headerEndRefreshing];
    });
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OneWeakCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cells"];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"OneWeakCell" owner:self options:nil];
        cell = array.lastObject;
    }

    return cell;
}
- (IBAction)touchHeaderBtn:(id)sender {
    NSLog(@"点击头部");
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
