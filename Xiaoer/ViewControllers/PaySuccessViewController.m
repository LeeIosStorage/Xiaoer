//
//  PaySuccessViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/27.
//
//

#import "PaySuccessViewController.h"
#import "PaySuccessCell.h"
@interface PaySuccessViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付成功";
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [self configureTableView];
    [self creatTableViewHeaderView];
    [self configureDeatilAndMainView];
    [self congigureAlertText];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 处理aLertText文本
- (void)congigureAlertText{
    NSString *AlertText = self.alertTextLab.text;
    NSLog(@"%@",AlertText);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:AlertText];
    //设置：在0-3个单位长度内的内容显示成橘黄色
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(29, 25)];
    self.alertTextLab.attributedText = str;
}
#pragma mark 布局DeatilAndMainView
- (void)configureDeatilAndMainView{
    self.detailBtn.layer.cornerRadius = 5;
    self.detailBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.detailBtn.layer.borderWidth = 1;
    
    self.backToMainBtn.layer.cornerRadius = 5;
    self.backToMainBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backToMainBtn.layer.borderWidth = 1;
    
    
}

#pragma mark 创建tabelviewHeaderView
- (void)creatTableViewHeaderView{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor clearColor];
    self.sucImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.sucImgView.frame.size.height);
    self.addressView.frame = CGRectMake(0, self.sucImgView.frame.size.height, SCREEN_WIDTH, self.addressView.frame.size.height);
    self.priceView.frame = CGRectMake(0, self.sucImgView.frame.size.height + self.addressView.frame.size.height, SCREEN_WIDTH, self.priceView.frame.size.height);
    self.detailAToMainView.frame = CGRectMake(0, self.sucImgView.frame.size.height + self.addressView.frame.size.height + self.priceView.frame.size.height, SCREEN_WIDTH, self.detailAToMainView.frame.size.height);
    self.alertView.frame = CGRectMake(0, self.sucImgView.frame.size.height + self.addressView.frame.size.height + self.priceView.frame.size.height + self.detailAToMainView.frame.size.height, SCREEN_WIDTH, self.alertView.frame.size.height);
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.sucImgView.frame.size.height + self.addressView.frame.size.height + self.priceView.frame.size.height + self.detailAToMainView.frame.size.height + self.alertView.frame.size.height);
    [headerView addSubview:self.sucImgView];
    [headerView addSubview:self.addressView];
    [headerView addSubview:self.priceView];
    [headerView addSubview:self.detailAToMainView];
    [headerView addSubview:self.alertView];
    self.tabView.tableHeaderView = headerView;
    
}

#pragma mark 布局tableview
- (void)configureTableView{
    self.tabView.backgroundColor = [UIColor clearColor];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    [self.tabView registerNib:[UINib nibWithNibName:@"PaySuccessCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}
- (IBAction)detailBtnTouched:(id)sender {
    NSLog(@"订单详情按钮点击");
}
- (IBAction)backToMainBtnTouched:(id)sender {
    NSLog(@"返回首页按钮点击");
}

#pragma mark tableView delegate 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaySuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
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
