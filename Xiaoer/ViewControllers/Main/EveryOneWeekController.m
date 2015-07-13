//
//  EveryOneWeekController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/8.
//
//

#import "EveryOneWeekController.h"
#import "UIImageView+WebCache.h"
#import "OneWeakCell.h"
#import "MJRefresh.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XEOneWeekInfo.h"
#import "XEBabyInfo.h"
#import "RecipesViewController.h"
#import "XELinkerHandler.h"

#import "XERecipesInfo.h"
@interface EveryOneWeekController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTabView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

;
@property (weak, nonatomic) IBOutlet UILabel *headerLab;
@property (weak, nonatomic) IBOutlet UILabel *headerLaab;
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
    self.title = @"每周一练";
    [self.mainTabView registerNib:[UINib nibWithNibName:@"OneWeakCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cells"];
    self.mainTabView.dataSource = self;
    self.mainTabView.delegate = self;
    self.mainTabView.tableHeaderView = self.headerView;
    [self.mainTabView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self headerRefreshing];

}
- (void)getOneWeekData{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"shopCellHolder"]];

    __weak EveryOneWeekController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    
    NSString *week = [NSString stringWithFormat:@"%ld",(long)self.cweek];
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
        if (self.dataSources.count > 0) {
            [self.dataSources removeAllObjects];
        }
        for (NSDictionary *dic in jsonRet[@"object"]) {
            [self.dataSources  addObject:dic];
        }
        if (self.dataSources) {
            XEOneWeekInfo *oneWeek = [XEOneWeekInfo modelWithDictioanry:[self.dataSources objectAtIndex:0]];
            NSLog(@"oneWeek.objid ==== %@",oneWeek.objid);
            [self.headerImageView sd_setImageWithURL:oneWeek.totalImageUrl placeholderImage:[UIImage imageNamed:@"shopCellHolder"]];
            self.headerLaab.text = oneWeek.title;
        }
        NSLog(@"self.dataSources.count = %ld",(unsigned long)self.dataSources.count);
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
    return self.dataSources.count -1;
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
    
    XEOneWeekInfo *oneWeek = [XEOneWeekInfo modelWithDictioanry:[self.dataSources objectAtIndex:indexPath.row + 1]];
   [cell configureCellWithModel:oneWeek];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        XEOneWeekInfo *oneWeek = [XEOneWeekInfo modelWithDictioanry:[self.dataSources objectAtIndex:indexPath.row + 1]];

    if ([oneWeek.type isEqualToString:@"3"]) {
        
        NSString *url = [NSString stringWithFormat:@"%@/info/detail?id=%@", [[XEEngine shareInstance] baseUrl], oneWeek.objid];
        id vc = [XELinkerHandler handleDealWithHref:url From:self.navigationController];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if ([oneWeek.type isEqualToString:@"2"]){
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"商城正在建设中" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [aler show];
        
    }else if ([oneWeek.type isEqualToString:@"1"]){
        
         NSString *string =  [NSString stringWithFormat:@"%@/info/detail?id=%@", [[XEEngine shareInstance] baseUrl], oneWeek.objid];
        id vc = [XELinkerHandler handleDealWithHref:string From:self.navigationController];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}

/**
 *  点击headerView 的btn
 *
 */
- (IBAction)touchHeaderBtn:(id)sender {
    
    NSLog(@"点击头部按钮");
    if (self.dataSources.count == 0) {
        return;
    }
    XEOneWeekInfo *info = [XEOneWeekInfo modelWithDictioanry:[self.dataSources objectAtIndex:0]];
    if ([info.type isEqualToString:@"3"]) {
        NSString *url = [NSString stringWithFormat:@"%@/info/detail?id=%@", [[XEEngine shareInstance] baseUrl], info.objid];
        id vc = [XELinkerHandler handleDealWithHref:url From:self.navigationController];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if ([info.type isEqualToString:@"2"]){
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"商城正在建设中" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [aler show];
        
    }else if ([info.type isEqualToString:@"1"]){
        //评测
        NSString *string =  [NSString stringWithFormat:@"%@/info/detail?id=%@", [[XEEngine shareInstance] baseUrl], info.objid];
        id vc = [XELinkerHandler handleDealWithHref:string From:self.navigationController];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    
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
