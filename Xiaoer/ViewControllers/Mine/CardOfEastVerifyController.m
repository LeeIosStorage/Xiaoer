//
//  CardOfEastVerifyController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/5/18.
//
//

#import "CardOfEastVerifyController.h"
#import "CardInfoVerifyCell.h"
#import "CardOfEastWebViewController.h"
#define cellHeight 60
@interface CardOfEastVerifyController ()
/**
 *  cell左边提示文字
 */
@property (nonatomic,strong)NSMutableArray *reminderArray;


@end

@implementation CardOfEastVerifyController


- (NSMutableArray *)reminderArray{
    if (!_reminderArray) {
        self.reminderArray = [NSMutableArray arrayWithObjects:@"卡号",@"密码",@"姓名",@"常用手机",@"详细地址", nil];
    }
    return _reminderArray;
}
- (UITableView *)infomationTab{
    if (!_infomationTab) {
        self.infomationTab = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _infomationTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_infomationTab registerNib:[UINib nibWithNibName:@"CardInfoVerifyCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _infomationTab.delegate = self;
        _infomationTab.dataSource = self;
        UILabel *footLable = [[UILabel alloc]init];
        _infomationTab.tableFooterView = footLable;
        
    }
    return _infomationTab;
}

- (UIButton *)verifyBtn{
    if (!_verifyBtn) {
        self.verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _verifyBtn.frame = CGRectMake(cellHeight, self.view.bounds.size.height - cellHeight * 2, self.view.bounds.size.width - cellHeight * 2, cellHeight);
        [_verifyBtn setBackgroundImage:[UIImage imageNamed:@"激活small"] forState:UIControlStateNormal];
        [_verifyBtn setBackgroundImage:[UIImage imageNamed:@"激活small"] forState:UIControlStateHighlighted];
        [_verifyBtn setTitle:@"确认激活" forState:UIControlStateNormal];
        [_verifyBtn addTarget:self action:@selector(verifyActivity) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verifyBtn;
}
- (void)loadView{
    
    [super loadView];
    self.view.bounds = [UIScreen mainScreen].bounds;
    [self.view addSubview:self.infomationTab];
    [self.view addSubview:self.verifyBtn];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"卡券详情";

    // Do any additional setup after loading the view from its nib.
}
- (void)verifyActivity{
    CardOfEastWebViewController *webView = [[CardOfEastWebViewController alloc]init];
    [self.navigationController pushViewController:webView animated:YES];
}
#pragma tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CardInfoVerifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell configureCellWith:[self.reminderArray objectAtIndex:indexPath.row]];
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.reminderArray.count;
    
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
