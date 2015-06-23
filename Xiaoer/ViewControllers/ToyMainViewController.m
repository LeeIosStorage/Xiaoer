//
//  ToyMainViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/18.
//
//

#import "ToyMainViewController.h"
#import "ToyMainTabCell.h"
#import "ToyListViewController.h"
#import "MJRefresh.h"
#define changeLabeY 105

@interface ToyMainViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (strong, nonatomic) IBOutlet UIView *evaluatingView;
@property (weak, nonatomic) IBOutlet UITableView *evaluatingTab;
@property (strong, nonatomic) IBOutlet UIView *trainvView;
@property (weak, nonatomic) IBOutlet UITableView *trainTab;
@property (strong, nonatomic) IBOutlet UIView *otherBuyView;
@property (weak, nonatomic) IBOutlet UITableView *otherBuyTab;

@property (nonatomic,strong)UITableView *tableView;
//评测玩具
@property (nonatomic,strong)UIButton *changeEvaluat;
//训练玩具
@property (nonatomic,strong)UIButton *changeTrain;
//另购玩具
@property (nonatomic,strong)UIButton *changeOther;

@property (nonatomic,strong)UIButton *button;

@property (nonatomic,strong)UILabel *changeLable;

@property (nonatomic,assign)BOOL touchChangeScro;
@property (nonatomic,assign)int type;

@end

@implementation ToyMainViewController
- (UILabel *)changeLable{
    if (!_changeLable) {
        self.changeLable = [[UILabel alloc]initWithFrame:CGRectMake(10, changeLabeY, SCREEN_WIDTH/3 - 20, 5)];
        _changeLable.backgroundColor = [UIColor colorWithRed:43/255.0 green:186/255.0 blue:230/255.0 alpha:1];
    }
    return _changeLable;
}
- (UIButton *)changeEvaluat{
    if (!_changeEvaluat) {
        self.changeEvaluat = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeEvaluat setTitle:@"评测玩具" forState:UIControlStateNormal];
        [_changeEvaluat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _changeEvaluat.frame = CGRectMake(0, 64, SCREEN_WIDTH/3, 30);
        [_changeEvaluat addTarget:self action:@selector(changeContentOfSet:) forControlEvents:UIControlEventTouchUpInside];
        _changeEvaluat.userInteractionEnabled = YES;
    }
    return _changeEvaluat;
    
}
- (UIButton *)changeTrain{
    if (!_changeTrain) {
        self.changeTrain = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeTrain setTitle:@"训练玩具" forState:UIControlStateNormal];
        [_changeTrain setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _changeTrain.frame = CGRectMake(SCREEN_WIDTH/3, 64, SCREEN_WIDTH/3, 30);
        [_changeTrain addTarget:self action:@selector(changeContentOfSet:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _changeTrain;
}
- (UIButton *)changeOther{
    if (!_changeOther) {
        self.changeOther = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeOther setTitle:@"另购玩具" forState:UIControlStateNormal];
        [_changeOther setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _changeOther.frame = CGRectMake(SCREEN_WIDTH/3* 2, 64, SCREEN_WIDTH/3, 30);
        [_changeOther addTarget:self action:@selector(changeContentOfSet:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeOther;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"玩具";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.touchChangeScro = NO;
    //布局backScrollView
    [self configurebackScrollView];
    [self.view addSubview:self.changeOther];
    [self.view addSubview:self.changeEvaluat];
    [self.view addSubview:self.changeOther];
    [self.view addSubview:self.changeTrain];
    [self.view addSubview:self.changeLable];
    
    self.tableView = self.evaluatingTab;

    [self setupRefresh];//调用刷新方法
    
}

//刷新
- (void)setupRefresh{
    //下拉刷新(头部控件刷新的2种方法)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    
    //自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
}

#pragma mark 头部刷新
- (void)headerRefreshing{
    //添加数据（刷新一次，新添加5个数据）
    //    [self getOneWeekData];
    
    // 2.2秒后刷新表格UI
    NSLog(@"SHUAIXN");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        // 调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
    
}

#pragma mark changerBtn 点击
- (void)changeContentOfSet:(UIButton *)sender{
    
    NSLog(@"点击");
    if (self.button) {
        [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    self.button = sender;
    [sender setTitleColor:[UIColor colorWithRed:43/255.0 green:186/255.0 blue:230/255.0 alpha:1] forState:UIControlStateNormal];
    
    if ([sender.titleLabel.text isEqualToString:@"评测玩具"]) {
        NSLog(@"评测玩具");
        self.tableView = self.evaluatingTab;
        self.type = 0;

    }
    if ([sender.titleLabel.text isEqualToString:@"训练玩具"]) {
        NSLog(@"训练玩具");
        self.tableView = self.trainTab;
        self.type = 1;

    }
    if ([sender.titleLabel.text isEqualToString:@"另购玩具"]) {
        NSLog(@"另购玩具");
        self.tableView = self.otherBuyTab;
        self.type = 2;
    }
    
        [self animationWithLine];
    
}
//线条动画
#pragma mark 线条动画
- (void)animationWithLine
{

        [UIView animateWithDuration:0.3 animations:^{
            self.changeLable.frame = CGRectMake(self.type * SCREEN_WIDTH/3  + 10, changeLabeY, SCREEN_WIDTH/3 - 20, 5);
            if (self.touchChangeScro == YES) {
            
                return ;
            }else{
                [self.backScrollView setContentOffset:CGPointMake(self.type * SCREEN_WIDTH, 0)];
            }
           
        }];
    [self setupRefresh];
    
}

#pragma mark 布局backScrollView
- (void)configurebackScrollView{
    self.backScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 3, 0);
    self.backScrollView.delegate = self;
    self.backScrollView.directionalLockEnabled = YES;
    self.backScrollView.pagingEnabled = YES;
    self.backScrollView.scrollEnabled = YES;
    
    CGRect ecalutF = self.evaluatingView.frame;
    ecalutF.origin.x = 0;
    self.evaluatingView.frame = ecalutF;
    
    CGRect trainvF = self.trainvView.frame;
    trainvF.origin.x = SCREEN_WIDTH;
    self.trainvView.frame = trainvF;
    
    CGRect otherBuyF = self.otherBuyView.frame;
    otherBuyF.origin.x = SCREEN_WIDTH * 2;
    self.otherBuyView.frame = otherBuyF;

    
    [self.backScrollView addSubview:self.evaluatingView];
    [self.backScrollView addSubview:self.trainvView];
    [self.backScrollView addSubview:self.otherBuyView];
    
    [self.evaluatingTab registerNib:[UINib nibWithNibName:@"ToyMainTabCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.trainTab registerNib:[UINib nibWithNibName:@"ToyMainTabCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.otherBuyTab registerNib:[UINib nibWithNibName:@"ToyMainTabCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.evaluatingTab.delegate = self;
    self.trainTab.delegate = self;
    self.otherBuyTab.delegate = self;
    self.evaluatingTab.dataSource = self;
    self.trainTab.dataSource = self;
    self.otherBuyTab.dataSource = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView  代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ToyMainTabCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell1) {
        return cell1;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ToyListViewController *list = [[ToyListViewController alloc]init];
    [self.navigationController pushViewController:list animated:YES];
    NSLog(@"%@",self.navigationController);
    
}

#pragma mark scrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.touchChangeScro = YES;
    NSLog(@"开始拖拽scrollView");

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = SCREEN_WIDTH/self.backScrollView.contentOffset.x;
    if (index < 0 || index >(long) 1) {
        NSLog(@"11  index == %ld",(long)index);
        [self changeContentOfSet:self.changeEvaluat];
        self.touchChangeScro = NO;

    } else if (index == 1) {
        [self changeContentOfSet:self.changeTrain];
        self.touchChangeScro = NO;

    }else if (index == 0){
        [self changeContentOfSet:self.changeOther];
        self.touchChangeScro = NO;
    }
    
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
