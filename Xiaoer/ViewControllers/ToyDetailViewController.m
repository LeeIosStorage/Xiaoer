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

#define chooseHeight self.chooseView.frame.size.height

@interface ToyDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *naviLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UIView *tabHeaderView;
//@property (weak, nonatomic) IBOutlet UITableView *detailTabView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *lunboLab;

/**
 *    遮罩
 */
@property (nonatomic,strong)UIView *hideView;




/**
 *  选择的tableview
 */
@property (strong, nonatomic) IBOutlet UIView *chooseView;

/**
 *  选择的tableview
 */
@property (weak, nonatomic) IBOutlet UITableView *chooseTab;
/**
 *  choose的tableview的headerview
 */
@property (strong, nonatomic) IBOutlet UIView *chooseTabHeader;

/**
 *  区头的图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *chooseHeaderImage;
/**
 *  显示价格的lable
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (weak, nonatomic) IBOutlet UIButton *chooseVerifyBtn;


@end

@implementation ToyDetailViewController

- (UIView *)hideView{
    if (!_hideView) {
        self.hideView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _hideView.backgroundColor = [UIColor lightGrayColor];
        _hideView.alpha = 0.3;
    }
    return _hideView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"正在建设中6p"]];
//    imageView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 120);
//    [self.view addSubview:imageView];
    
#warning 修改版的详情，使用html5做，暂时去掉tableview
//    [self configureLunBoView];
//    [self configureTableView];

    
    
    //注意添加顺序
    [self.view addSubview:self.hideView];
    self.hideView.hidden = YES;
    
    //    布局导航条
    [self confugureNaviTitle];
    [self addBottomView];
    [self configureChooseTabView];

}

#pragma mark 布局choosetableview

- (void)configureChooseTabView{
    self.chooseTab.delegate = self;
    self.chooseTab.dataSource = self;
    [self.chooseTab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.chooseView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, chooseHeight);
    self.chooseTab.tableHeaderView = self.chooseTabHeader;
    self.chooseHeaderImage.layer.cornerRadius = 10;
    self.chooseHeaderImage.layer.masksToBounds = YES;
    [self.view addSubview:self.chooseView];
}
#pragma mark 添加底部的视图 （收藏，加入购物车，立即购买）
- (void)addBottomView{
    self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40);
    [self.view addSubview:self.bottomView];
}

#pragma mark 布局tableview属性
- (void)configureTableView{
//    self.detailTabView.delegate = self;
//    self.detailTabView.dataSource = self;
//    [self.detailTabView registerNib:[UINib nibWithNibName:@"ToyDetailCell" bundle:nil] forCellReuseIdentifier:@"detail"];
//    self.detailTabView.tableHeaderView = self.tabHeaderView;

}

#pragma mark 布局轮播图
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
    self.naviLable.frame = CGRectMake(0, 20, SCREEN_WIDTH, 40);
    
    UIButton *shopCar = [UIButton buttonWithType:UIButtonTypeCustom];
    shopCar.backgroundColor = [UIColor clearColor];
    [shopCar setBackgroundImage:[UIImage imageNamed:@"toyCar"] forState:UIControlStateNormal];
    [shopCar addTarget:self action:@selector(toShopCar) forControlEvents:UIControlEventTouchUpInside];
    shopCar.frame = CGRectMake(SCREEN_WIDTH - 40, 0, 40, 40);
    [self.naviLable addSubview:shopCar];
    [self.view addSubview:self.naviLable];
}

#pragma mark 返回按钮
//返回按钮
- (IBAction)back:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark  前往购物车按钮
- (void)toShopCar{
    NSLog(@"添加到购物车");
    ShopCarViewController *car = [[ShopCarViewController alloc]init];
    [self.navigationController pushViewController:car animated:YES];
}


#pragma mark  收藏按钮
- (IBAction)collect:(id)sender {
    NSLog(@"收藏");
}

#pragma mark  底部点击加入到购物车
- (IBAction)bottomAddToShopCar:(id)sender {
    NSLog(@"底部点击加入到购物车");
    [self animationChooseView];

}



#pragma mark  立即购买
- (IBAction)buy:(id)sender {
    NSLog(@"购买");
    VerifyIndentViewController *verify = [[VerifyIndentViewController alloc]init];
    [self.navigationController pushViewController:verify animated:YES];
}

#pragma mark 取消按钮点击

- (IBAction)cancleBtnTouched:(id)sender {
    NSLog(@"取消按钮点击");
    [self animationChooseView];
}

- (IBAction)vetifyBtnTouched:(id)sender {
    [self animationChooseView];
}


#pragma mark  chooseTableView 动画
- (void)animationChooseView{
    NSLog(@"执行动画");
    CGRect rect = self.chooseView.frame;
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        self.hideView.hidden = NO;

        [UIView animateWithDuration:0.5 animations:^{
                        self.chooseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, chooseHeight);
        } completion:^(BOOL finished) {
        }];
    }else{
        self.hideView.hidden  = YES;

        [UIView animateWithDuration:0.5 animations:^{
            self.chooseView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, chooseHeight);
        } completion:^(BOOL finished) {
        }];
        

    }
}
- (IBAction)headerClearBtnTouched:(id)sender {
    
    NSLog(@"嗨噢是否 i 哦发 i 哦好");
    [self animationChooseView];
}



#pragma mark tableView delegate 

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//        return self.chooseTabHeader;
// 
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 180;
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//   . ToyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
