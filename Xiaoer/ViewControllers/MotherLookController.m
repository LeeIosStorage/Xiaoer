//
//  MotherLookController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/8.
//
//

#import "MotherLookController.h"
#import "MotherLookCell.h"
@interface MotherLookController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *motherLookTab;

@end

@implementation MotherLookController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.motherLookTab.delegate = self;
    self.motherLookTab.dataSource = self;
    [self.motherLookTab registerNib:[UINib nibWithNibName:@"MotherLookCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    // Do any additional setup after loading the view from its nib.
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
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    lable.textAlignment = NSTextAlignmentLeft;
    switch (section) {
        case 0:
            lable.text = @"  正在抢票";
            break;
            
        case 1:
            lable.text = @"  热门活动";
            break;
        case 2:
            lable.text = @"  推荐商品";
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
