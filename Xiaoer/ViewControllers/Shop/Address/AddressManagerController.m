//
//  AddressManagerController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/23.
//
//

#import "AddressManagerController.h"
#import "AddressManagerCell.h"
#import "AddAddressViewController.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "AddressInfoManager.h"
@interface AddressManagerController ()<UITableViewDataSource,UITableViewDelegate,AddressManagerCellDelegate>
@property (nonatomic,strong)NSMutableArray *dataSources;
@end

@implementation AddressManagerController
- (NSMutableArray *)dataSources{
    if (!_dataSources) {
        self.dataSources = [NSMutableArray array];
    }
    return _dataSources;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //防止编辑地址界面编辑过之后 这边没有反应，所以在viewDidAppear 中仙配置下
    [self configureTableView];
    [self getAddressList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址管理";
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [self setRightButtonWithImageName:@"AddAddress" selector:@selector(addAddressBtn)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deledate:) name:@"editVerifyInfo" object:nil];

    // Do any additional setup after loading the view from its nib.
}

- (void)deledate:(NSNotificationCenter *)sender{
    [self getAddressList];
    
}
#pragma mark 布局tableview
- (void)configureTableView{
    
    [self.tabView registerNib:[UINib nibWithNibName:@"AddressManagerCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    self.tabView.backgroundColor = [UIColor clearColor];
    [self.tabView addHeaderWithTarget:self action:@selector(refreshAddlistView)];

}
#pragma mark 头部刷新
- (void)refreshAddlistView{
    [self getAddressList];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tabView headerEndRefreshing];
    });
    
}
#pragma mark 获取数据
- (void)getAddressList{
    __weak AddressManagerController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    
    [[XEEngine shareInstance]getAddressListWithTag:tag userId:[XEEngine shareInstance].uid];
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
        [self.dataSources removeAllObjects];

        NSArray *array = jsonRet[@"object"];
        if (array.count == 0) {
            [XEProgressHUD AlertError:@"没有获取到数据" At:weakSelf.view];
            [self.tabView reloadData];
            return;

        }
        if (jsonRet[@"object"]) {
            NSLog(@"有返回数据");

            
            for (NSDictionary *dic in array) {
                XEAddressListInfo *info = [XEAddressListInfo objectWithKeyValues:dic];
                [self.dataSources addObject:info];
            }
            [self.tabView reloadData];
            return;
            
        }else{
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            [self.tabView reloadData];
            return;

        }
    } tag:tag];

}

- (void)addAddressBtn{
    AddAddressViewController *add = [[AddAddressViewController alloc]init];
    [self.navigationController pushViewController:add animated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSources.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 20;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.tag = indexPath.section;
    cell.delegate = self;
    [cell configureCellWith:indexPath info:self.dataSources[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XEAddressListInfo *info = self.dataSources[indexPath.section];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%@ %@ ",info.phone,info.id);
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshAddressInfoWith:)]) {
        [self.delegate refreshAddressInfoWith:info];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark cell delagete
- (void)touchedIndexOfCell:(NSInteger)index{
    XEAddressListInfo *Addinfo = (XEAddressListInfo *)self.dataSources[index];
    
    AddAddressViewController *add = [[AddAddressViewController alloc]init];
    add.info = Addinfo;
    add.ifHaveDeleteBtn = YES;
    if (self.fromVerifyInfo) {
        
        if ([Addinfo.id isEqualToString:self.fromVerifyInfo.id]) {
            NSLog(@"来自上一层选择的info");
            NSLog(@"%@   %@",self.fromVerifyInfo.id,Addinfo.id);

            add.ifCanDelete = YES;
        }else{
            NSLog(@"不是自上一层选择的info");
            NSLog(@"%@   %@",self.fromVerifyInfo.id,Addinfo.id);
            add.ifCanDelete = NO;
        }
        
    }else{
        add.ifCanDelete = NO;
    }
    NSLog(@"%@",self.ifCanDelete ? @"y ":@"n");
    [self.navigationController pushViewController:add animated:YES];
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
