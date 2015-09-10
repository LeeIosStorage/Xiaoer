//
//  XEAppOfficeAppointmentController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/9/8.
//
//

#import "XEAppOfficeAppointmentController.h"
#import "AppOfficeAppointmentHeader.h"
#import "AppHospitalListHeaderView.h"
#import "XEAppOfficeAppointmentInfo.h"
#import "AppOfficeAppointmentCell.h"
#import "XEAppOrderInfomationController.h"
@interface XEAppOfficeAppointmentController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSources;

@end

@implementation XEAppOfficeAppointmentController
- (NSMutableArray *)dataSources{
    if (!_dataSources) {
        self.dataSources = [NSMutableArray array];
    }
    return _dataSources;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self getData];
}
- (void)viewDidLoad {

    [super viewDidLoad];
    [self configureTableView];
    self.title = @"预约挂号";

}
#pragma mark 获取数据
- (void)getData
{
    int tag = [[XEEngine shareInstance]getConnectTag];
    [[XEEngine shareInstance]appOfficeAppointmentWith:tag hospitaldeptid:self.sub.id];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        if (![jsonRet[@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"获取门诊信息失败"];
            return ;
        }
        if (self.dataSources.count > 0) {
            [self.dataSources removeAllObjects];
        }
        
        NSArray *array = jsonRet[@"object"];
        if (array.count  > 0) {
            for (NSDictionary *dic in array) {
                XEAppOfficeAppointmentInfo *info = [XEAppOfficeAppointmentInfo objectWithKeyValues:dic];
                [self.dataSources addObject:info];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            [XEProgressHUD AlertError:@"暂无门诊信息"];
            return;
        }
        
    } tag:tag];
}
- (void)configureTableView{
    [self.tableView registerNib:[UINib nibWithNibName:@"AppOfficeAppointmentCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    AppHospitalListHeaderView *listHeader = [AppHospitalListHeaderView appHospitalListHeaderView];
    listHeader.rightBtn.hidden = YES;
    listHeader.titleLable.text = self.hospitalName;
    self.tableView.tableHeaderView = listHeader;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [AppOfficeAppointmentHeader appOfficeAppointmentHeader].frame.size.height;
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    AppOfficeAppointmentHeader * header = [AppOfficeAppointmentHeader appOfficeAppointmentHeader];
    header.backgroundColor = LGrayColor;
    header.titleLab.text = self.sub.name;
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppOfficeAppointmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    cell.appBtn.tag = indexPath.row;
    [cell addAppOfficeAppointmentCellTarget:self action:@selector(orderBtnTouched:)];
    [cell configureCellWith:self.dataSources[indexPath.row]];
    return cell;
}
- (void)orderBtnTouched:(UIButton *)button
{
    /**
     *  先判断是否登陆
     */
    if ([[XEEngine shareInstance] needUserLogin:@"亲，需要登录才可预约专家哦"]) {
        return;
    }
    
    XEAppOrderInfomationController *order = [[XEAppOrderInfomationController alloc]init];
    XEAppOfficeAppointmentInfo *info = self.dataSources[button.tag];
    order.hdaid = info.id;
    [self.navigationController pushViewController:order animated:YES];
    NSLog(@"%ld",button.tag);
}
@end
