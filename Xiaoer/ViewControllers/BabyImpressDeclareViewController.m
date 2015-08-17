//
//  BabyImpressDeclareViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/8/14.
//
//

#import "BabyImpressDeclareViewController.h"

@interface BabyImpressDeclareViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtnTouched:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIView *declareView;
@property (weak, nonatomic) IBOutlet UILabel *lightGrayLab;

@end

@implementation BabyImpressDeclareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"10分公益爱心";
    [self configureTableView];
    // Do any additional setup after loading the view from its nib.
}
- (void)configureTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource  =self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = self.footerView;
    self.tableView.tableHeaderView = [self creatHeaderView];
    self.lightGrayLab.backgroundColor =  [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];

    
    
}
- (UIView *)creatHeaderView{
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, SCREEN_WIDTH - 40, 0)];
    lable.font = [UIFont systemFontOfSize:16];
    lable.numberOfLines = 0;
    lable.text = @"1、参与“10分公益，宝宝印像”活动，用户每献出1角钱即得10个“爱心分”。\n2、用户首月可献2元即200个“爱心分”，次月始可献1元即100个“爱心分”。\n3、10个“爱心分”可兑换一张6寸照片的冲印权。\n4、“爱心分”可自用或转增，每个月最多转赠100个“爱心分”。\n5、订单支付完成后，不能删除上传照片。\n6、“爱心分”可累积无上限，但每个用户每月最多可用300个“爱心分”兑换30张照片的冲印权。\n7、“爱心分”仅用于本活动的照片兑换。\n8、“爱心分”自用户参与活动始的一年内有效。";
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil];
    CGRect rect = [lable.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    CGRect textFram = lable.frame;
    textFram.size.height = rect.size.height ;
    lable.frame = textFram;
    [self.declareView addSubview:lable];
    self.declareView.frame = CGRectMake(0, 0, SCREEN_WIDTH, rect.size.height + 60 + 25);
    return  self.declareView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
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

- (IBAction)backBtnTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
