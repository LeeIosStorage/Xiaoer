//
//  OrderCardHistoryController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/7.
//
//

#import "OrderCardHistoryController.h"
#import "OrderCardHistoryCell.h"
@interface OrderCardHistoryController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//保存卡券信息数组
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
    self.title = @"历史信息";
    [self configureTableView];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark 布局tablewview
- (void)configureTableView{
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderCardHistoryCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate  =self;
    self.tableView.dataSource = self;
}
#pragma mark tableview  delegate datesources

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderCardHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
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
