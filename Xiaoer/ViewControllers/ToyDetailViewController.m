//
//  ToyDetailViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/19.
//
//

#import "ToyDetailViewController.h"
#import "ToyDetailCell.h"
#import "ToyListViewController.h"
#import "VerifyIndentViewController.h"
#import "ShopCarViewController.h"
#import "ToyLunBoView.h"
@interface ToyDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *naviLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UIView *tabHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *detailTabView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *lunboLab;

@end

@implementation ToyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    布局导航条
    [self confugureNaviTitle];
    self.detailTabView.delegate = self;
    self.detailTabView.dataSource = self;
    [self.detailTabView registerNib:[UINib nibWithNibName:@"ToyDetailCell" bundle:nil] forCellReuseIdentifier:@"detail"];
    self.detailTabView.tableHeaderView = self.tabHeaderView;
    self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40);
    [self.view addSubview:self.bottomView];
    [self configureLunBoView];
    // Do any additional setup after loading the view from its nib.
}
- (void)configureLunBoView{
    //轮播图
    ToyLunBoView *cycleView = [[ToyLunBoView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250)];
    cycleView.userInteractionEnabled = YES;
    cycleView.backgroundColor = [UIColor redColor];
    [cycleView configureHeaderWith:1];
    [self.lunboLab addSubview:cycleView];
 
}

#pragma mark 布局导航条
- (void)confugureNaviTitle{
    self.titleNavBar.alpha = 0;
    self.view.backgroundColor = [UIColor orangeColor];
    self.naviLable.frame = CGRectMake(0, 20, SCREEN_WIDTH, 40);
    [self.view addSubview:self.naviLable];
}
//返回按钮
- (IBAction)back:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addToCar:(id)sender {
    NSLog(@"添加到购物车");
}

- (IBAction)collect:(id)sender {
    NSLog(@"收藏");
}
- (IBAction)bottomAddToShopCar:(id)sender {
    NSLog(@"底部点击添加到购物车");
    ShopCarViewController *car = [[ShopCarViewController alloc]init];
    [self.navigationController pushViewController:car animated:YES];

}
- (IBAction)buy:(id)sender {
    NSLog(@"购买");
    VerifyIndentViewController *verify = [[VerifyIndentViewController alloc]init];
    [self.navigationController pushViewController:verify animated:YES];
}

//收藏按钮

#pragma mark tableView delegate 

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ToyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail" forIndexPath:indexPath];
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
