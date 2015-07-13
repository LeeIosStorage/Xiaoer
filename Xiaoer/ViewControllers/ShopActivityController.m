//
//  ShopActivityController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/25.
//
//

#import "ShopActivityController.h"
#import "SearchListViewController.h"
#import "ToyDetailViewController.h"
#import "ShopActivityCell.h"
#import "MJRefresh.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XEShopListInfo.h"
#import "MJExtension.h"

@interface ShopActivityController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign)BOOL ifToEnd;
@property (nonatomic,assign)NSInteger pageNum;
@property (nonatomic,strong)NSMutableArray *dataSources;

@end

@implementation ShopActivityController
- (NSMutableArray *)dataSources{
    if (!_dataSources) {
        self.dataSources = [NSMutableArray array];
    }
    return _dataSources;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动";
    [self setRightButtonWithImageName:@"shopSearchBar" selector:@selector(pushToSearch)];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self configureTableView];
    
    NSLog(@"self.serieInfo.title === %@",self.serieInfo.title);
    
    //设置刷新方法
    [self setupRefresh];

}
#pragma mark 获取数据
- (void)getAvtivityListData{
    __weak ShopActivityController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance]getShopListInfoMationWith:tag category:self.category pagenum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] type:self.type name:self.name serieid:self.serieInfo.id];
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
        if ([jsonRet[@"object"][@"goodses"] isKindOfClass:[NSNull class]]) {
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            return;
        }
        NSString *endStr = [jsonRet[@"object"][@"end"]stringValue];
        if ([endStr isEqualToString:@"0"]) {
            self.ifToEnd = YES;
        }
        NSArray *array = jsonRet[@"object"][@"goodses"];
        if (array.count <= 0) {
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            return;
        }
        //判断是否清除dataSources
        if (self.pageNum == 1) {
            [self.dataSources removeAllObjects];
        }
        for (NSDictionary *dic in array) {
            XEShopListInfo *info = [XEShopListInfo objectWithKeyValues:dic];
            [self.dataSources addObject:info];
        }
        [self.tabView reloadData];
    } tag:tag];
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
    [self getAvtivityListData];
    
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
        [self  getAvtivityListData];
    }else{
        //如果是最后一页的话提示已经是最后一页，不在请求数据了
        [XEProgressHUD lightAlert:@"已经到最后一页"];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 调用endRefreshing可以结束刷新状态
        [self.tabView footerEndRefreshing];
    });
}
#pragma mark布局tableview
- (void)configureTableView{
    self.tabView.backgroundColor = [UIColor clearColor];
    [self.tabView registerNib:[UINib nibWithNibName:@"ShopActivityCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tabView.delegate = self;
    self.tabView.dataSource  = self;
}

#pragma mark  tableView delagte
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 10;
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSources.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureCellWith:[self.dataSources objectAtIndex:indexPath.section]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ActivityDetailController *detail = [[ActivityDetailController alloc]init];
    ToyDetailViewController *detail = [[ToyDetailViewController alloc]init];
    
    XEShopSerieInfo *info = (XEShopSerieInfo *)[self.dataSources objectAtIndex:indexPath.section];
    detail.shopId = info.id;
    [self.navigationController pushViewController:detail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark 点击搜索按钮
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
