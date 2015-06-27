//
//  ShopCarViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/22.
//
//

#import "ShopCarViewController.h"
#import "ShopCarCell.h"
@interface ShopCarViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ShopCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self configureTabView];
    [self configurePatBtn];
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)payBtnTouched:(id)sender {
    NSLog(@"去结算按钮点击");
}

#pragma mark 布局支付按钮的layer
- (void)configurePatBtn{

    self.payBtn.layer.cornerRadius = 10;
    self.payBtn.layer.masksToBounds = YES;

}
#pragma mark 布局添加tableview属性

- (void)configureTabView{
    
    self.shopCarTab.delegate = self;
    self.shopCarTab.dataSource = self;
    self.shopCarTab.backgroundColor = [UIColor clearColor];
    [self.shopCarTab registerNib:[UINib nibWithNibName:@"ShopCarCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.shopCarTab.tableFooterView = self.tabFooterView;
}

#pragma mark tableView delegate datasources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
//暂定的一个分区 隐藏区头
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#warning 暂时隐藏区头
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0;
//}

#warning 隐藏了区头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [self returnSectionHeader];
    for (UIView *obj in header.subviews) {
        if (obj.tag == 2) {
            UILabel *lable = (UILabel *)obj;
            lable.text = @"满22件";
            
        }
    }
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell configureCellWith:indexPath];
    return cell;
    
}
#warning  暂时不要区尾
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return [self returnSectionFooter];
//}

- (UIView *)returnSectionHeader{
    UIView *SectionHeader = [[UIView alloc]init];
    SectionHeader.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
    imageView.image = [UIImage imageNamed:@"HeaderJian"];
    imageView.tag = 0;
    
    UILabel *topTitle = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, SCREEN_WIDTH - 60, 20)];
    topTitle.text = @"玩具专场";
    topTitle.textColor = [UIColor blackColor];
    topTitle.tag = 1;
    
    UILabel *leftTitle = [[UILabel alloc]initWithFrame:CGRectMake(60, 25, 60, 20)];
    leftTitle.text = @"满2件";
    leftTitle.textColor = [UIColor lightGrayColor];
    leftTitle.tag = 2;
    
    UILabel *rightTitle = [[UILabel alloc]initWithFrame:CGRectMake(130, 25, 80, 20)];
    rightTitle.text = @"已打9折";
    rightTitle.textColor = [UIColor lightGrayColor];
    rightTitle.tag = 3;
    
    [SectionHeader addSubview:imageView];
    [SectionHeader addSubview:topTitle];
    [SectionHeader addSubview:leftTitle];
    [SectionHeader addSubview:rightTitle];
    
    return SectionHeader;
    
}

- (UIView *)returnSectionFooter{
    UIView *sectionFooter = [[UIView alloc]init];
    sectionFooter.backgroundColor = [UIColor whiteColor];
    
    UILabel *xiaoji = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 110, 0, 45, 25)];
    xiaoji.text = @"小计：";
    xiaoji.textColor = [UIColor blackColor];
    xiaoji.font = [UIFont systemFontOfSize:15];
    
    UILabel *xiaojiPric = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 0, 65, 25)];
    xiaojiPric.text = @"56元";
    xiaojiPric.textColor = [UIColor redColor];
    xiaojiPric.font = [UIFont systemFontOfSize:15];
    
    UILabel *youhui = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 110, 25, 65, 25)];
    youhui.text = @"优惠：";
    youhui.textColor = [UIColor lightGrayColor];
    youhui.font = [UIFont systemFontOfSize:15];
    
    UILabel *youhuiPric = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 25, 65, 25)];
    youhuiPric.text = @"2.6元";
    youhuiPric.textColor = [UIColor blackColor];
    youhuiPric.font = [UIFont systemFontOfSize:15];
    
    UIImageView *fenGe = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 37, 40, 1)];
    fenGe.image = [UIImage imageNamed:@"s_n_set_line"];
    
    [sectionFooter addSubview:xiaoji];
    [sectionFooter addSubview:xiaojiPric];
    [sectionFooter addSubview:youhui];
    [sectionFooter addSubview:youhuiPric];
    [sectionFooter addSubview:fenGe];
    return  sectionFooter;
    
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
