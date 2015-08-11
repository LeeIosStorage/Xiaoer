//
//  BabyImpressMyPictureController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/25.
//
//

#import "BabyImpressMyPictureController.h"
#import "BabyImpressMyPicturerCell.h"
#import "BabyImpressPrintController.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "MJRefresh.h"
#import "XEBabyImpressPhotoListInfo.h"
#import "MJExtension.h"

@interface BabyImpressMyPictureController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tabFooterView;
@property (nonatomic,strong)NSMutableArray *dataSources;
/**
 *  快递信息view
 */
@property (strong, nonatomic) IBOutlet UIView *expressageView;
/**
 *  快递信息文字lab
 */
@property (weak, nonatomic) IBOutlet UILabel *expressageLab;
@end

@implementation BabyImpressMyPictureController

-(NSMutableArray *)dataSources{
    if (!_dataSources) {
        self.dataSources = [NSMutableArray array];
    }
    return _dataSources;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [self getPosedData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的照片"; 
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.tableView.backgroundColor = [UIColor clearColor];

    [self configureTabeView];


    
    // Do any additional setup after loading the view from its nib.
}


- (void)getPosedData{
    __weak BabyImpressMyPictureController *weakSelf = self;
//    [XEEngine shareInstance].serverPlatform = TestPlatform;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance]qiniuCheckPosedPhotoWith:tag userid:[XEEngine shareInstance].uid];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        //获取失败信息
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return ;
        }
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"获取上传照片失败" At:weakSelf.view];
            return;
        }
        if ([jsonRet[@"object"] isKindOfClass:[NSNull class]]) {
            [XEProgressHUD AlertError:@"获取上传照片失败" At:weakSelf.view];
            return;
        
        }
        [self.dataSources removeAllObjects];

        NSArray *array = jsonRet[@"object"][@"list"];
        if (array.count == 0) {
            [XEProgressHUD AlertError:@"你还没有上传照片，请上传" At:weakSelf.view];
            [self.tableView reloadData];
            return;
        }
        
        for (NSDictionary *dic in array) {
            XEBabyImpressPhotoListInfo *info = [XEBabyImpressPhotoListInfo objectWithKeyValues:dic];
            [self.dataSources addObject:info];
        }
        
        if (jsonRet[@"object"][@"sendInfo"]) {
            NSLog(@"快递信息存在");
            self.tableView.tableFooterView = [self creatFooterWithExpressage:jsonRet[@"object"][@"sendInfo"]];
        }else{
            NSLog(@"快递信息不存在");
            self.tabFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
            self.tableView.tableFooterView = self.tabFooterView;
        }
        [self.tableView reloadData];
        
    } tag:tag];


}

- (void)configureTabeView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 10;
    self.tableView.sectionFooterHeight = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"BabyImpressMyPicturerCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
}
- (UIView *)creatFooterWithExpressage:(NSString *)str{
    self.tabFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    self.expressageView.frame = CGRectMake(0, 60, SCREEN_WIDTH, 60);
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    [footer addSubview:self.tabFooterView];
    NSArray *array = [str componentsSeparatedByString:@"##"];
    self.expressageLab.text = [NSString stringWithFormat:@"您的订单已通过%@发出，快递单号：%@",array[0],array[1]];
    [footer addSubview:self.expressageView];
    
    return footer;
}
- (void)headerRefresh{
    //获取数据
    [self getPosedData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        // 调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });

}
#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSources.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BabyImpressMyPicturerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell configureCellWith:self.dataSources[indexPath.section]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BabyImpressPrintController *print = [[BabyImpressPrintController alloc]init];
    print.info = self.dataSources[indexPath.section];
    [self.navigationController pushViewController:print animated:YES];
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
