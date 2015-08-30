//
//  OrderWillPassController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/18.
//
//

#import "OrderWillPassController.h"

#import "OrderWillPassCell.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XEOrderWillPassInfo.h"
#import "MJExtension.h"


#import "ToyDetailViewController.h"

@interface OrderWillPassController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSources;
@end

@implementation OrderWillPassController
- (NSMutableArray *)dataSources{
    if (!_dataSources) {
        self.dataSources = [NSMutableArray array];
    }
    return _dataSources;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
    [self getWillPassData];
    // Do any additional setup after loading the view from its nib.
}
- (void)getWillPassData{
    __weak OrderWillPassController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance]getOrderWillpassOrderWith:tag type:self.type userid:[XEEngine shareInstance].uid];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return ;
        }
        
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"获取数据失败" At:weakSelf.view];
            return;
        }
        NSArray *array = jsonRet[@"object"];
        if (array.count == 0) {
            [XEProgressHUD AlertError:@"暂无过期内容" At:weakSelf.view];
        }
        if (self.dataSources.count > 0) {
            [self.dataSources removeAllObjects];
        }
        
        for (NSDictionary *dic in array) {
            XEOrderWillPassInfo *info = [XEOrderWillPassInfo objectWithKeyValues:dic];
            [self.dataSources addObject:info];
        }
        [self.tableView reloadData];

    } tag:tag];
}
#pragma mark  布局tableview
- (void)configureTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderWillPassCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderWillPassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell configureCellWith:self.dataSources[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XEOrderWillPassInfo *info = self.dataSources[indexPath.row];
    ToyDetailViewController *detail = [[ToyDetailViewController alloc]init];
    detail.shopId = info.id;
    [self.navigationController pushViewController:detail animated:YES];
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
