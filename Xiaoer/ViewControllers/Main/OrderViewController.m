//
//  OrderViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/27.
//
//

#import "OrderViewController.h"
#import "ShopActivityCell.h"
#import "OrderCell.h"
#import "OrderDetailViewController.h"
@interface OrderViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullToRefreshViewDelegate>
/**
 *  保存点击的按钮
 */
@property (nonatomic,strong)UIButton *button;

/**
 *  保存点击按钮类型
 */
@property (nonatomic,assign)NSInteger type;
/**
 *  保存所处在的tableview
 */
@property (nonatomic,strong)UITableView *tableView;

/**
 *  保存滑动scrollview之前的水平位置
 */
@property (nonatomic,assign)CGFloat begianSetX;

//changelab是否是点击移动
@property (nonatomic,assign)BOOL touchChangeLab;

@property (nonatomic,strong)PullToRefreshView *pullRefreshView;
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self calculateLableFrame];
    [self configureBackScrollview];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    self.tableView = self.allTab;

    
    self.edgesForExtendedLayout = UIRectEdgeNone;



}

#pragma mark 布局backscrollview
- (void)configureBackScrollview{
    self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 5, 0);
    self.backScrollView.delegate = self;
    self.backScrollView.directionalLockEnabled = YES;
    self.backScrollView.pagingEnabled = YES;
    self.backScrollView.scrollEnabled = YES;
    
    self.allTab.delegate = self;
    self.allTab.dataSource = self;
    
    self.needPayTab.delegate = self;
    self.needPayTab.dataSource = self;
    
    self.electronTab.delegate = self;
    self.electronTab.dataSource = self;
    
    self.orderTab.delegate = self;
    self.orderTab.dataSource = self;
    
    self.reimburseTab.delegate = self;
    self.reimburseTab.dataSource = self;

    
    CGRect allFrame = self.allView.frame;
    allFrame.origin.x = 0;
    self.allView.frame = allFrame;
    
    CGRect needPayFrame = self.needPayView.frame;
    needPayFrame.origin.x = SCREEN_WIDTH;
    self.needPayView.frame = needPayFrame;
    
    CGRect electronFrame = self.electronView.frame;
    electronFrame.origin.x = SCREEN_WIDTH * 2;
    self.electronView.frame = electronFrame;
    
    CGRect orderFrame = self.orderView.frame;
    orderFrame.origin.x = SCREEN_WIDTH * 3;
    self.orderView.frame = orderFrame;
    
    CGRect reimburseFrame = self.reimburseView.frame;
    reimburseFrame.origin.x = SCREEN_WIDTH * 4;
    self.reimburseView.frame = reimburseFrame;
    
    [self.backScrollView addSubview:self.allView];
    [self.backScrollView addSubview:self.needPayView];
    [self.backScrollView addSubview:self.electronView];
    [self.backScrollView addSubview:self.orderView];
    [self.backScrollView addSubview:self.reimburseView];
    
    [self.allTab registerNib:[UINib nibWithNibName:@"OrderCell" bundle:nil] forCellReuseIdentifier:@"allCell"];
    
    [self.needPayTab registerNib:[UINib nibWithNibName:@"OrderCell" bundle:nil] forCellReuseIdentifier:@"needPayCell"];

    [self.electronTab registerNib:[UINib nibWithNibName:@"ShopActivityCell" bundle:nil] forCellReuseIdentifier:@"electronCell"];

    [self.orderTab registerNib:[UINib nibWithNibName:@"ShopActivityCell" bundle:nil] forCellReuseIdentifier:@"orderCell"];

    [self.reimburseTab registerNib:[UINib nibWithNibName:@"OrderCell" bundle:nil] forCellReuseIdentifier:@"reimburseCell"];
    
}
#pragma mark 计算changeLableFrame(下滑lable)
- (void)calculateLableFrame{
    CGRect rect = self.changeLab.frame;
    rect.size.width = SCREEN_WIDTH/5 - 10;
    self.changeLab.frame = rect;
}

#pragma mark changerBtn 点击
- (void)changeContentOfSet:(UIButton *)sender{
    
    if (self.button) {
        [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    self.button = sender;
    [sender setTitleColor:[UIColor colorWithRed:43/255.0 green:186/255.0 blue:230/255.0 alpha:1] forState:UIControlStateNormal];
    
    if ([sender.titleLabel.text isEqualToString:@"全部"]) {
        NSLog(@"全部");
        self.tableView = self.allTab;
        self.type = 0;
        
    }
    if ([sender.titleLabel.text isEqualToString:@"待付款"]) {
        NSLog(@"待付款");
        self.tableView = self.needPayTab;
        self.type = 1;
        
    }
    if ([sender.titleLabel.text isEqualToString:@"电子券"]) {
        NSLog(@"电子券");
        self.tableView = self.electronTab;
        self.type = 2;
    }
    if ([sender.titleLabel.text isEqualToString:@"预约券"]) {
        NSLog(@"预约券");
        self.tableView = self.orderTab;
        self.type = 3;
    }
    if ([sender.titleLabel.text isEqualToString:@"退款单"]) {
        NSLog(@"退款单");
        self.tableView = self.reimburseTab;
        self.type = 4;
    }
    
    [self animationWithLine];
    
}

#pragma mark 线条动画
- (void)animationWithLine
{
    CGRect rect = self.changeLab.frame;
    rect.origin.x = self.type * (SCREEN_WIDTH/5) +5;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.changeLab.frame = rect;
        if (self.touchChangeLab == YES) {
            [self.backScrollView setContentOffset:CGPointMake(self.type * SCREEN_WIDTH, 0)];
            self.touchChangeLab = NO;
        }else{
            NSLog(@"手动滑动tableview造成tableView移动，不执行动画");
        }
    }];
    
}


#pragma mark 头部按钮点击
- (IBAction)allBtnTouched:(id)sender {
    NSLog(@"全部");
    self.touchChangeLab = YES;
    [self changeContentOfSet:(UIButton *)sender];
}
- (IBAction)needPayBtnTouched:(id)sender {
    NSLog(@"待付款");
    self.touchChangeLab = YES;

    [self changeContentOfSet:(UIButton *)sender];


}
- (IBAction)electronCardBtnTouched:(id)sender {
    NSLog(@"电子券");
    self.touchChangeLab = YES;

    [self changeContentOfSet:(UIButton *)sender];


}
- (IBAction)orderBtnTouched:(id)sender {
    NSLog(@"预约券");
    self.touchChangeLab = YES;

    [self changeContentOfSet:(UIButton *)sender];


}
- (IBAction)reimburseBtnTouched:(id)sender {
    NSLog(@"退款单");
    self.touchChangeLab = YES;

    [self changeContentOfSet:(UIButton *)sender];


}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.electronTab) {
        return 20;
    }
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.electronTab) {
        return 150;
    }else if (tableView == self.orderTab){
        return 150;
    }else{
        return 100;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.allTab) {
        OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    } else if(tableView == self.needPayTab) {
        OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"needPayCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    
    }else if (tableView == self.electronTab){
        ShopActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"electronCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if (tableView == self.orderTab){
            ShopActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if (tableView == self.reimburseTab){
        OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reimburseCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;

    }

    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailViewController *detail = [[OrderDetailViewController alloc]init];
    [self.navigationController pushViewController:detail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark scrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"%f",self.backScrollView.contentOffset.x);
    self.begianSetX = self.backScrollView.contentOffset.x;
    self.touchChangeLab = NO;
    NSLog(@"开始拖拽scrollView");
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.begianSetX != self.backScrollView.contentOffset.x) {
        NSLog(@"进来");
        NSInteger index = self.backScrollView.contentOffset.x/SCREEN_WIDTH;
        NSLog(@"index === %ld",index);
        if (index == 0 || index >(long) 4) {
            NSLog(@"11  index == %ld",(long)index);
            
            [self changeContentOfSet:self.allBtn];
            
        } else if (index == 1) {
            
            [self changeContentOfSet:self.needPayBtn];
            
        }else if (index == 2){
            
            [self changeContentOfSet:self.electronCardBtn];
            
        }else if (index == 3){
            
            [self changeContentOfSet:self.orderBtn];
        }else if (index == 4){
            [self changeContentOfSet:self.reimburseBtn];

        }
    }else{
        NSLog(@"不做任何处理");
    }
    
    
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
