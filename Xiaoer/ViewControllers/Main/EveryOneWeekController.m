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
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XEOneWeekInfo.h"
@interface EveryOneWeekController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTabView;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (nonatomic,strong)NSMutableArray *dataSources;

@end

@implementation EveryOneWeekController
- (NSMutableArray *)dataSources{
    if (!_dataSources) {
        self.dataSources = [NSMutableArray array];
    }
    return _dataSources;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainTabView registerNib:[UINib nibWithNibName:@"OneWeakCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cells"];
    self.mainTabView.dataSource = self;
    self.mainTabView.delegate = self;
    self.mainTabView.tableHeaderView = self.headerView;
    [self headerRefreshing];
    [self.mainTabView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    NSLog(@"self.cweek = %ld",(long)self.cweek);

    
}
- (void)getOneWeekData{
    __weak EveryOneWeekController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [XEEngine shareInstance].serverPlatform = TestPlatform;
    NSString *week = [NSString stringWithFormat:@"%ld",self.cweek + 1];
    int we = [week intValue];
    [[XEEngine shareInstance]getOneWeekListWith:we Tag:tag];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        
        //获取失败信息
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return ;
        }
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
        }
        NSLog(@"jsonRet ＝＝＝＝＝＝＝ %@",jsonRet);
        if (self.dataSources.count > 0) {
            [self.dataSources removeAllObjects];
        }
        for (NSDictionary *dic in jsonRet[@"object"]) {
            [self.dataSources  addObject:dic];
        }
    } tag:tag];
}
- (void)headerRefreshing{
    //添加数据（刷新一次，新添加5个数据）
    [self getOneWeekData];
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
   // XEOneWeekInfo *oneWeek = [XEOneWeekInfo modelWithDictioanry:[self.dataSources objectAtIndex:indexPath.row]];
//    [cell configureCellWithModel:oneWeek];
    return cell;
}

- (IBAction)touchHeaderBtn:(id)sender {
    NSLog(@"点击头部");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
