//
//  MotherLookController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/8.
//
//

#import "MotherLookController.h"
#import "MotherLookCell.h"
#import "MJRefresh.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XEMotherLook.h"
#import "shopOtherViewController.h"
#import "ActivityDetailsViewController.h"
#import "XEActivityInfo.h"
#import "XELinkerHandler.h"
@interface MotherLookController ()<UITableViewDataSource,UITableViewDelegate,MotherLookBtnDelegate>
@property (nonatomic,strong)NSMutableArray *dataSources;
@property (weak, nonatomic) IBOutlet UITableView *motherLookTab;

@end

@implementation MotherLookController
- (NSMutableArray *)dataSources{
    if (!_dataSources) {
        self.dataSources = [NSMutableArray array];
    }
    return _dataSources;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"妈妈必看";
    NSLog(@"%@",self.navigationController);

    self.motherLookTab.delegate = self;
    self.motherLookTab.dataSource = self;
    [self.motherLookTab registerNib:[UINib nibWithNibName:@"MotherLookCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.motherLookTab addHeaderWithTarget:self action:@selector(headerRefreshing)];

    [self headerRefreshing];

}
- (void)touchMotherLookCellBtn:(UIButton *)sender{
    NSString *string = sender.titleLabel.text;
    
    UIAlertView *aletr = [[UIAlertView alloc]initWithTitle:@"您查看的内容不存在，晓儿正在找回中" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    if ([string isEqualToString:@"去抢票"]) {
        NSLog(@"去抢票");
        
        ActivityDetailsViewController *vc = [[ActivityDetailsViewController alloc] init];
        XEActivityInfo *activityInfo = [[XEActivityInfo alloc]init];
        
        NSDictionary *dic = self.dataSources[sender.tag];
        XEMotherLook *model = [XEMotherLook modelWithDictioanry:dic];
        NSLog(@"model.objid === %@",model.objid);
        activityInfo.aId = model.objid;
        activityInfo.aType = 1;
        vc.activityInfo = activityInfo;
        vc.isTicketActivity = YES;
        if ([model.objid isEqualToString:@""]) {
            [aletr show];
            return;
        }else{
            [self.navigationController pushViewController:vc animated:YES];
        }
        

    } else if ([string isEqualToString:@"去看看"]) {


        ActivityDetailsViewController *vc = [[ActivityDetailsViewController alloc]init];
        XEActivityInfo *activityInfo = [[XEActivityInfo alloc]init];
        NSDictionary *dic = self.dataSources[sender.tag];
        XEMotherLook *model = [XEMotherLook modelWithDictioanry:dic];
        vc.activityInfo = activityInfo;
        if ([model.objid isEqualToString:@""]) {
            
            [aletr show];
            return;
        }else{
            [self.navigationController pushViewController:vc animated:YES];
        }

    }else if ([string isEqualToString:@"去逛逛"]){
        
        shopOtherViewController *shop = [[shopOtherViewController alloc]init];
        [self.navigationController pushViewController:shop animated:YES];
        
    }else if ([string isEqualToString:@"去瞧瞧"]){
        
        NSDictionary *dic = self.dataSources[sender.tag];
        XEMotherLook *model = [XEMotherLook modelWithDictioanry:dic];
        NSString *url = [NSString stringWithFormat:@"%@/info/detail?id=%@", [[XEEngine shareInstance] baseUrl],model.objid];
        id vc = [XELinkerHandler handleDealWithHref:url From:self.navigationController];
        if ([model.objid isEqualToString:@""]) {
            
            [aletr show];
            return;
        }else{
            if (vc) {
                [self.navigationController pushViewController:vc animated:YES];
            }
        }

    }
    
    
}
- (void)loadData{
    __weak MotherLookController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [XEEngine shareInstance].serverPlatform = OnlinePlatform;
    [[XEEngine shareInstance]getMotherLookListWithTag:tag];
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
        NSDictionary *dic = jsonRet[@"object"];
        if ([dic count] == 0) {
            NSLog(@"无数据");
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            return;
        }
        if (self.dataSources.count > 0) {
            [self.dataSources removeAllObjects];
        }
        for (NSDictionary *dic in jsonRet[@"object"]) {
            [self.dataSources  addObject:dic];
        }
        NSLog(@"self.dataSources.count == %ld",self.dataSources.count);
        [self.motherLookTab reloadData];
    } tag:tag];
    
}

- (void)headerRefreshing{
    //添加数据（刷新一次，新添加5个数据）
    [self loadData];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        // 调用endRefreshing可以结束刷新状态
        [self.motherLookTab headerEndRefreshing];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSources.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.textColor = [UIColor whiteColor];
    NSDictionary *dic = [self.dataSources objectAtIndex:section];
    if ([[dic[@"type"] stringValue] isEqualToString:@"1"]) {
        lable.text = @"  正在抢票";
        lable.backgroundColor = [UIColor colorWithRed:233/255.0 green:105/255.0 blue:121/255.0 alpha:1];

    }
    if ([[dic[@"type"] stringValue] isEqualToString:@"2"]) {
        lable.text = @"  热门活动";
        lable.backgroundColor = [UIColor colorWithRed:246/255.0 green:180/255.0 blue:90/255.0 alpha:1];

    }
    if ([[dic[@"type"] stringValue] isEqualToString:@"3"]) {
        lable.text = @"  推荐商品";
        lable.backgroundColor = [UIColor colorWithRed:128/255.0 green:191/255.0 blue:108/255.0 alpha:1];

    }
    if ([[dic[@"type"] stringValue] isEqualToString:@"4"]) {
        
        lable.text = @"  咨询快车";
        
        lable.backgroundColor = [UIColor colorWithRed:245/255.0 green:155/255.0 blue:181/255.0 alpha:1];
    }
    
    return lable;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MotherLookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    /**
     *  选中样式
     */
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataSources) {
        NSDictionary *dic = [self.dataSources objectAtIndex:indexPath.section];
        cell.tag = indexPath.section;
        XEMotherLook *motherLook = [XEMotherLook modelWithDictioanry:dic];
        [cell configureCellWith:indexPath motherLook:motherLook];
        cell.delegate = self;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    if (indexPath.section == 2) {
        shopOtherViewController *shop = [[shopOtherViewController alloc]init];
        [self.navigationController pushViewController:shop animated:YES];
    }
    if (indexPath.section == 1) {
        ActivityDetailsViewController *detail = [[ActivityDetailsViewController alloc]init];
        XEMotherLook *model = [XEMotherLook modelWithDictioanry:[self.dataSources objectAtIndex:indexPath.section]];
        XEActivityInfo *info = [[XEActivityInfo alloc]init];
        info.aId = model.IDNum;
        detail.activityInfo = info;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    if (indexPath.section == 0) {
        ActivityDetailsViewController *vc = [[ActivityDetailsViewController alloc] init];
        XEActivityInfo *activityInfo = [[XEActivityInfo alloc]init];
        activityInfo.aType = 1;
        XEMotherLook *model = [XEMotherLook modelWithDictioanry:[self.dataSources objectAtIndex:indexPath.section]];
        activityInfo.aId = model.IDNum;
        vc.activityInfo = activityInfo;
        vc.isTicketActivity = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    */
    [self.motherLookTab deselectRowAtIndexPath:indexPath animated:YES];
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
