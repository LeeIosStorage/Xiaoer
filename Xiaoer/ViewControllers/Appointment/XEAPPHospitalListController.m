//
//  XEAPPHospitalListController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/9/7.
//
//

#import "XEAPPHospitalListController.h"
#import "AppHospitalListCell.h"
#import "AppHospitalListHeaderView.h"
#import "MJRefresh.h"
#import "XEAppHospital.h"
#import "XEAppSubHospital.h"
#import "AppHospitalIntroCell.h"
#import "XEAppOfficeIntroController.h"

@interface XEAPPHospitalListController ()<UITableViewDataSource,UITableViewDelegate,appHospitalListCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign)NSInteger pageNum;
@property (nonatomic,assign)BOOL ifToEnd;
@property (nonatomic,strong)NSMutableArray *hospitalArray;
@property (nonatomic,assign)BOOL ifClearData;
/**
 *  0 隐藏 1 不隐藏
 */
@property (nonatomic,strong)NSMutableArray *sectionHide;
/**
 *  0 隐藏 1 不隐藏
 */
@property (nonatomic,strong)NSMutableArray *cellHide;

@end

@implementation XEAPPHospitalListController
- (NSMutableArray *)cellHide
{
    if (!_cellHide) {
        self.cellHide = [NSMutableArray array];
    }
    return _cellHide;
}
- (NSMutableArray *)hospitalArray{
    if (!_hospitalArray) {
        self.hospitalArray = [NSMutableArray array];
    }
    return _hospitalArray;
}
- (NSMutableArray *)sectionHide{
    if (!_sectionHide) {
        self.sectionHide = [NSMutableArray array];
    }
    return _sectionHide;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约挂号";
    self.pageNum = 1;
    self.ifToEnd = NO;
    self.ifClearData = NO;
    self.view.backgroundColor = LGrayColor;
    [self getHospitalData];
    [self configureTableView];
}

#pragma mark 获取数据
- (void)getHospitalData
{
    int tag = [[XEEngine shareInstance]getConnectTag];
    [[XEEngine shareInstance]appointmentGetHospitalListWith:tag pagenum:[NSString stringWithFormat:@"%ld",(long)self.pageNum]];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        if (![jsonRet[@"code"] isEqual:@0]) {
            [XEProgressHUD AlertSuccess:@"获取信息失败，请重试"];
            return ;
        }
        
        if (![jsonRet[@"object"][@"end"] isEqual:@0]) {
            self.ifToEnd = YES;
        }
        
        if (self.ifClearData == YES) {
            [self.hospitalArray removeAllObjects];
            [self.sectionHide removeAllObjects];
            [self.cellHide removeAllObjects];
        }
        NSArray *hospitals = jsonRet[@"object"][@"hospitals"];
        if (hospitals.count > 0 ) {
            //0 隐藏 1 不隐藏
            for (int i = 0; i < hospitals.count; i++) {
                NSDictionary *dic = hospitals[i];

                XEAppHospital *hospital = [XEAppHospital objectWithKeyValues:dic];
                [self.hospitalArray addObject:hospital];
                
                [self.cellHide addObject:@"1"];
                
                
                if (self.sectionHide.count > 0)
                {
                    //之前保存过 接下来的不隐藏
                    [self.sectionHide addObject:@"0"];
                    
                }
                else
                {
                    if (i == 0)
                    {
                        [self.sectionHide addObject:@"1"];
                    }
                    else
                    {
                        [self.sectionHide addObject:@"0"];

                    }
                }
                
                
                
            }
            
            
            
            [self.tableView reloadData];
            
        }else{
            [XEProgressHUD lightAlert:@"暂无数据"];
        }
        
    } tag:tag];
}
- (void)configureTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"AppHospitalListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AppHospitalIntroCell" bundle:nil] forCellReuseIdentifier:@"intro"];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
}

#pragma mark 头部刷新
- (void)headerRefresh{
    // 2.2秒后刷新表格UI
    self.pageNum = 1;
    self.ifToEnd = NO;
    self.ifClearData = YES;
    [self getHospitalData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView headerEndRefreshing];
    });
}

#pragma mark 尾部刷新
- (void)footerRefresh{
    // 2.2秒后刷新表格UI
    if (self.ifToEnd == YES) {
        [XEProgressHUD lightAlert:@"已经到最后一页"];
        return;
    }
    self.pageNum ++;
    self.ifToEnd = NO;
    self.ifClearData = NO;
    [self getHospitalData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView footerEndRefreshing];
    });
}

#pragma mark  headeView action

- (void)headerViewTouched:(UIButton *)sender{
    if ([self.sectionHide[sender.tag] isEqualToString:@"0"]) {
        self.sectionHide[sender.tag] = @"1";
    }else{
        self.sectionHide[sender.tag] = @"0";
    }
    [self.tableView reloadData];
    NSLog(@"view ＝＝ %@  %ld",sender,(long)sender.tag);
    
}

#pragma mark introCell touche
- (void)introCellTouched:(UIButton *)sender

{
    NSLog(@"sender.tag == %ld",sender.tag);
    if ([self.cellHide[sender.tag] isEqualToString:@"0"]) {
        self.cellHide[sender.tag] = @"1";
    }else{
        self.cellHide[sender.tag] = @"0";
    }
    [self.tableView reloadData];}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    AppHospitalListHeaderView *headerView = [AppHospitalListHeaderView appHospitalListHeaderView];
    XEAppHospital *hos = self.hospitalArray[section];
    headerView.titleLable.text = hos.name;
    headerView.righrBigBtn.tag = section;
    
    if ([self.sectionHide[section] isEqualToString:@"0"])
    {
        
        [headerView.rightBtn setBackgroundImage:[UIImage imageNamed:@"addRight"] forState:UIControlStateNormal];
    }else{
        
        [headerView.rightBtn setBackgroundImage:[UIImage imageNamed:@"addDown"] forState:UIControlStateNormal];
    }
    
    [headerView appHospitalListHeaderViewTarget:self action:@selector(headerViewTouched:)];
    return headerView;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.hospitalArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    XEAppHospital *hospital = self.hospitalArray[section];
    if ([self.sectionHide[section] isEqualToString:@"0"]) {
        return 0;
    }

    return hospital.subHospital.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XEAppHospital *hos = self.hospitalArray[indexPath.section];
    if (indexPath.row == hos.subHospital.count) {
        
        if ([self.cellHide[indexPath.section] isEqualToString:@"0"]) {
            return 35;
        }
        
        return [AppHospitalIntroCell cellHeightWith:hos.intro];
    }else{
        return 130;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [AppHospitalListHeaderView appHospitalListHeaderView].frame.size.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XEAppHospital *hos = self.hospitalArray[indexPath.section];
    
    if (indexPath.row == hos.subHospital.count)
    {
        AppHospitalIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"intro" forIndexPath:indexPath];
        [cell configureIntroCellWith:hos hideStr:self.cellHide[indexPath.section]];
        cell.rightBigBtn.tag = indexPath.section;
        [cell appAppHospitalIntroCellTarget:self action:@selector(introCellTouched:)];
        cell.selectionStyle = 0;
        return cell;
    }
    else
    {
        XEAppSubHospital *sub = (XEAppSubHospital *)hos.subHospital[indexPath.row];

        AppHospitalListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.selectionStyle = 0;

        [cell configureCellWith:sub];
        return cell;
    }
    

    
    return nil;
}



#pragma mark cell delegate
- (void)getInBtnTouchedWith:(XEAppSubHospital *)info{
    
    NSLog(@"%@",info.name);
    for (XEAppHospital *hos in self.hospitalArray) {
        for (XEAppSubHospital *sub in hos.subHospital) {
            if ([sub.id isEqual:info.id]) {
                NSLog(@"找到");
                XEAppOfficeIntroController *offic = [[XEAppOfficeIntroController alloc]init];
                offic.hos = hos;
                offic.sub = info;
                [self.navigationController pushViewController:offic animated:YES];
            }
        }
    }
}
@end
