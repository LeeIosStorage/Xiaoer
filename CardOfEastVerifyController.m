//
//  CardOfEastVerifyController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/5/19.
//
//

#import "CardOfEastVerifyController.h"
#import "CardInfoVerifyCell.h"
#import "CardOfEastSucceedController.h"
@interface CardOfEastVerifyController ()

@end

@implementation CardOfEastVerifyController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  注册单元格
     */
    [self.verifyTableView registerNib:[UINib nibWithNibName:@"CardInfoVerifyCell" bundle:nil] forCellReuseIdentifier:@"VerifyCell"];
    
}
/**
 *  确认激活按钮
 *
 */
- (IBAction)verifyActivityBtn:(id)sender {
    CardOfEastSucceedController *succeed = [[CardOfEastSucceedController alloc]init];
    [self.navigationController pushViewController:succeed animated:YES];
    NSLog(@"确认激活按钮");
}



#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leftLableTextArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CardInfoVerifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VerifyCell" forIndexPath:indexPath];
    [cell configureCellWith:[self.leftLableTextArr objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark  自定义全局变量 －懒加载

- (NSMutableArray *)leftLableTextArr{
    if (!_leftLableTextArr) {
        self.leftLableTextArr = [NSMutableArray arrayWithObjects:@"卡号",@"密码",@"姓名",@"常用手机",@"详细地址", nil];
    }
    return _leftLableTextArr;
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
