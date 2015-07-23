//
//  OrderCardHistoryController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/7.
//
//

#import "OrderCardHistoryController.h"
#import "OrderCardHistoryCell.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "MJExtension.h"
#import "XEAppointmentEticker.h"
#import "XEAppointmentOrder.h"
@interface OrderCardHistoryController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  保存预约券数组
 */
@property (nonatomic,strong)NSMutableArray *dataSources;

@end

@implementation OrderCardHistoryController
- (NSMutableArray *)dataSources{
    if (!_dataSources) {
        self.dataSources  = [NSMutableArray array];
    }
    return _dataSources;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史记录";
    [self configureTableView];
    [self getOrderHistoryData];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark 获取数据
- (void)getOrderHistoryData{
    __weak OrderCardHistoryController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance]getOrderHistoryInfomationWith:tag orderproviderid:self.goodInfo.orderProviderId userid:[XEEngine shareInstance].uid goodsid:self.goodInfo.id];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return ;
        }
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            return;
        }
        if ([jsonRet[@"object"] isKindOfClass:[NSNull class]]) {
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
        }
        
        NSArray *array = jsonRet[@"object"];
        if (array.count == 0) {
            [XEProgressHUD AlertError:@"暂无预约券信息" At:weakSelf.view];
            return;
        }
        
        for (NSDictionary *dic in jsonRet[@"object"]) {
            XEAppointmentOrder *order = [XEAppointmentOrder objectWithKeyValues:dic];
            if ([order appointmentReturenSelfEticker].count > 0) {
                [self.dataSources addObject:order];
            }
//            for (NSDictionary *etdic in order.eticketAppointList) {
//                XEAppointmentEticker *eticker = [XEAppointmentEticker objectWithKeyValues:etdic];
//                [self.dataSources addObject:eticker];
//            }
        }
        NSLog(@"self.dataSources.count== %ld",self.dataSources.count);
        [self.tableView reloadData];
        
    } tag:tag];
}
#pragma mark 布局tablewview
- (void)configureTableView{
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderCardHistoryCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate  =self;
    self.tableView.dataSource = self;
}
#pragma mark tableview  delegate datesources

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSources.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    XEAppointmentOrder *order = self.dataSources[section];
    return [order appointmentReturenSelfEticker].count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderCardHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    XEAppointmentOrder *order = self.dataSources[indexPath.section];
    XEAppointmentEticker *eticter = (XEAppointmentEticker *)[order appointmentReturenSelfEticker][indexPath.row];
    [cell configureCellWithEtickerInfo:eticter orderInfo:order];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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
