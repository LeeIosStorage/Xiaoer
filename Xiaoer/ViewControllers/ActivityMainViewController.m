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
#import "XEProgressHUD.h"
#import "XEEngine.h"
#import "XEShopSerieInfo.h"
#import "ToyMainTabCell.h"

@interface ActivityMainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)NSInteger pageNum;
@property (nonatomic,assign)BOOL ifToEnd;
@property (nonatomic,strong)NSMutableArray *dataSources;
@end

@implementation ActivityMainViewController
- (NSMutableArray *)dataSources{
    if (!_dataSources) {
        self.dataSources = [NSMutableArray array];
    }
    return _dataSources;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.title = @"活动";
    
    self.pageNum = 1;
    self.ifToEnd = NO;
    [self configureTableView];
    
    //设置刷新方法
    [self setupRefresh];
    [self getAvtivityData];

    // Do any additional setup after loading the view from its nib.
}
#pragma mark 获取数据
- (void)getAvtivityData{
    __weak ActivityMainViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance]getShopSeriousInfomationWithType:self.type tag:tag category:self.category pagenum:[NSString stringWithFormat:@"%ld",(long)self.pageNum]];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        //获取失败信息
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return ;
        }
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            return;
            
        }
        if ([jsonRet[@"object"][@"series"] isKindOfClass:[NSNull class]]) {
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            return;
        }
        NSString *endStr = [jsonRet[@"object"][@"end"]stringValue];
        if ([endStr isEqualToString:@"0"]) {
            self.ifToEnd = YES;
        }
        NSArray *array = jsonRet[@"object"][@"series"];
        NSLog(@"array ==== %@",array);
        if (array.count <= 0) {
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            return;
        }
        
        //判断是否清除dataSources
        if (self.pageNum == 1) {
            [self.dataSources removeAllObjects];
        }
        for (NSDictionary *dic in array) {
            XEShopSerieInfo *info = [XEShopSerieInfo modelWithDictioanry:dic];
            [self.dataSources addObject:info];
        }
        [self.tabView reloadData];
        
    } tag:tag];
    
}
#pragma mark  布局tableview
- (void)configureTableView{
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    self.tabView.backgroundColor = [UIColor clearColor];
//    [self.tabView registerNib:[UINib nibWithNibName:@"ActivityMainCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tabView registerNib:[UINib nibWithNibName:@"ToyMainTabCell" bundle:nil] forCellReuseIdentifier:@"cell"];

}

#pragma mark 设置刷新
- (void)setupRefresh{
    //下拉刷新(头部控件刷新的2种方法)
    
    [self.tabView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.tabView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    //自动刷新(一进入程序就下拉刷新)
    [self.tabView headerBeginRefreshing];
    
}

#pragma mark 头部刷新
- (void)headerRefreshing{
    self.pageNum = 1;
    self.ifToEnd = NO;
    [self getAvtivityData];
    //添加数据（刷新一次，新添加5个数据）
    
    // 2.2秒后刷新表格UI
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        // 调用endRefreshing可以结束刷新状态
        [self.tabView headerEndRefreshing];
    });
    
}
#pragma mark 尾部刷新

- (void)footerRefreshing{
    if (self.ifToEnd == NO) {
        self.pageNum ++;
        [self  getAvtivityData];
    }else{
        //如果是最后一页的话提示已经是最后一页，不在请求数据了
        [XEProgressHUD lightAlert:@"已经到最后一页"];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 调用endRefreshing可以结束刷新状态
        [self.tabView footerEndRefreshing];
    });
}


#pragma mark tableview  delageta
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ToyMainTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    [cell configureCellWithModel:[self.dataSources objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XEShopSerieInfo *info = [self.dataSources objectAtIndex:indexPath.row];
    ShopActivityController *activityList = [[ShopActivityController alloc]init];
    activityList.type = @"2";
    activityList.category = @"1";
    activityList.serieInfo = info;

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
