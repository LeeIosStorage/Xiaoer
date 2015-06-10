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
@interface MotherLookController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *motherLookTab;

@end

@implementation MotherLookController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"妈妈必看";
    self.motherLookTab.delegate = self;
    self.motherLookTab.dataSource = self;
    [self.motherLookTab registerNib:[UINib nibWithNibName:@"MotherLookCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.motherLookTab addHeaderWithTarget:self action:@selector(headerRefreshing)];
    // Do any additional setup after loading the view from its nib.
}
- (void)headerRefreshing{
    //添加数据（刷新一次，新添加5个数据）

    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.motherLookTab reloadData];
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
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.textColor = [UIColor whiteColor];
    switch (section) {
        case 0:
            lable.text = @"  正在抢票";
            lable.backgroundColor = [UIColor colorWithRed:233/255.0 green:105/255.0 blue:121/255.0 alpha:1];
            break;
            
        case 1:
            lable.text = @"  热门活动";
            lable.backgroundColor = [UIColor colorWithRed:246/255.0 green:180/255.0 blue:90/255.0 alpha:1];

            break;
        case 2:
            lable.text = @"  推荐商品";
            lable.backgroundColor = [UIColor colorWithRed:128/255.0 green:191/255.0 blue:108/255.0 alpha:1];
            break;
        default:
            break;
    }
    return lable;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MotherLookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    /**
     *  选中样式
     */
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureCellWith:indexPath];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
