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
#import "XEAddressListInfo.h"
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
    [self getAddressList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址管理";
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [self setRightButtonWithImageName:@"AddAddress" selector:@selector(addAddressBtn)];
    [self configureTableView];
    [self getAddressList];
    // Do any additional setup after loading the view from its nib.
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
        NSArray *array = jsonRet[@"object"];
        if (array.count == 0) {
            [XEProgressHUD AlertError:@"没有获取到数据" At:weakSelf.view];
            return;

        }
        if (jsonRet[@"object"]) {
            NSLog(@"有返回数据");
            if (self.dataSources.count > 0) {
                [self.dataSources removeAllObjects];
            }
            
            for (NSDictionary *dic in array) {
                XEAddressListInfo *info = [XEAddressListInfo objectWithKeyValues:dic];
                [self.dataSources addObject:info];
            }
            [self.tabView reloadData];
            
        }else{
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
        }
    } tag:tag];

}
- (void)addAddressBtn{
    AddAddressViewController *add = [[AddAddressViewController alloc]init];
    [self.navigationController pushViewController:add animated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell configureCellWith:indexPath info:self.dataSources[indexPath.row]];
    return cell;
}


#pragma mark cell delagete
- (void)touchedIndexOfCell:(NSInteger)index{
    XEAddressListInfo *info = (XEAddressListInfo *)self.dataSources[index - 1];
    
    AddAddressViewController *add = [[AddAddressViewController alloc]init];
    add.info = info;
//    if ([[[AddressInfoManager manager]getTheDictionary] isEqual:info]) {
//        add.ifCanDelete = YES;
//        NSLog(@"可以删除");
//    }else{
//        add.ifCanDelete = NO;
//        NSLog(@"11可以删除");
//
//    }
    if ([info.def isEqualToString:@"1"]) {
       add.ifCanDelete = YES;
        NSLog(@"可以删除");
    }else{
        add.ifCanDelete = NO;
        NSLog(@"不可以删除");
    }
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
