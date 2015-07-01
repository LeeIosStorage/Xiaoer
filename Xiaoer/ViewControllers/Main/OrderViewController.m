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
#import "MJRefresh.h"
#import "XEProgressHUD.h"
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

/**
 *  全部页面的pagenum
 */
@property (nonatomic,assign)NSInteger allPageNum;
/**
 *  待付款pagenum
 */
@property (nonatomic,assign)NSInteger needPayNum;
/**
 *  电子券pagenum
 */
@property (nonatomic,assign)NSInteger electronCardNum;
/**
 *  预约券pagenum
 */
@property (nonatomic,assign)NSInteger orderNum;
/**
 *  退款单pagenum
 */
@property (nonatomic,assign)NSInteger reimburseNum;

/**
 *  全部数组
 */
@property (nonatomic,strong)NSMutableArray *allArray;
/**
 *  待付款数组
 */
@property (nonatomic,strong)NSMutableArray *needPayArray;
/**
 *  电子券数组
 */
@property (nonatomic,strong)NSMutableArray *electronCardArray;
/**
 *  预约券数组
 */
@property (nonatomic,strong)NSMutableArray *orderArray;
/**
 *  退款单数组
 */
@property (nonatomic,strong)NSMutableArray *reimburseArray;


/**
 *  全部页面是否没有数据
 */
@property (nonatomic,assign)BOOL ifAllToEnd;
/**
 *  待付款页面是否没有数据
 */
@property (nonatomic,assign)BOOL ifNeedPayToEnd;
/**
 *  电子券页面是否没有数据
 */
@property (nonatomic,assign)BOOL ifElectronCardToEnd;
/**
 *  预约页面是否没有数据
 */
@property (nonatomic,assign)BOOL ifOrderToEnd;
/**
 *  退款页面是否没有数据
 */
@property (nonatomic,assign)BOOL ifReimburseToEnd;


@end

@implementation OrderViewController
- (NSMutableArray *)allArray{
    if (!_allArray) {
        self.allArray = [NSMutableArray array];
    }
    return _allArray;
}
- (NSMutableArray *)needPayArray{
    if (!_needPayArray) {
        self.needPayArray = [NSMutableArray array];
    }
    return _needPayArray;
}
- (NSMutableArray *)electronCardArray{
    if (!_electronCardArray) {
        self.electronCardArray = [NSMutableArray array];
    }
    return _electronCardArray;
}
- (NSMutableArray *)orderArray{
    if (!_orderArray) {
        self.orderArray = [NSMutableArray array];
    }
    return _orderArray;
}
- (NSMutableArray *)reimburseArray{
    if (!_reimburseArray) {
        self.reimburseArray = [NSMutableArray array];
    }
    return _reimburseArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self calculateLableFrame];
    [self configureBackScrollview];
    self.tableView = self.allTab;
    
    self.allPageNum = 1;
    self.needPayNum = 1;
    self.electronCardNum = 1;
    self.orderNum = 1;
    self.reimburseNum = 1;
    self.ifAllToEnd = NO;
    self.ifNeedPayToEnd = NO;
    self.ifElectronCardToEnd = NO;
    self.ifOrderToEnd = NO;
    self.ifReimburseToEnd = NO;
    

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
    [self.allTab addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.allTab addFooterWithTarget:self action:@selector(footerLoadData)];
    
    [self.needPayTab registerNib:[UINib nibWithNibName:@"OrderCell" bundle:nil] forCellReuseIdentifier:@"needPayCell"];
    [self.needPayTab addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.needPayTab addFooterWithTarget:self action:@selector(footerLoadData)];

    [self.electronTab registerNib:[UINib nibWithNibName:@"ShopActivityCell" bundle:nil] forCellReuseIdentifier:@"electronCell"];
    [self.electronTab addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.electronTab addFooterWithTarget:self action:@selector(footerLoadData)];

    [self.orderTab registerNib:[UINib nibWithNibName:@"ShopActivityCell" bundle:nil] forCellReuseIdentifier:@"orderCell"];
    [self.orderTab addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.orderTab addFooterWithTarget:self action:@selector(footerLoadData)];

    [self.reimburseTab registerNib:[UINib nibWithNibName:@"OrderCell" bundle:nil] forCellReuseIdentifier:@"reimburseCell"];
    [self.reimburseTab addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.reimburseTab addFooterWithTarget:self action:@selector(footerLoadData)];
    
}
#pragma mark 创建sectionHeaderView
- (UIView *)creatSectionHeaderView{
    UIView *headerView = [[UIView alloc]init];
    //灰色背景色
    UIView *grayColorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    grayColorView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    //白色背景色
    UIView *whithBack = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40)];
    UILabel *layerlable = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 40, 20)];
    layerlable.layer.borderColor = [UIColor orangeColor].CGColor;
    layerlable.layer.borderWidth = 1;
    layerlable.layer.cornerRadius = 8;
    layerlable.layer.masksToBounds = YES;
    layerlable.text = @"商城";
    layerlable.textColor = [UIColor orangeColor];
    layerlable.textAlignment = NSTextAlignmentCenter;
    layerlable.font = [UIFont systemFontOfSize:12];
    
    UILabel *desLab = [[UILabel alloc]init];
    desLab.frame = CGRectMake(65, 10, 150, 40);
    desLab.textColor = [UIColor blackColor];
    desLab.font = [UIFont systemFontOfSize:14];
    desLab.text = @"牧童积木儿童专卖场";
    

    UILabel *stateLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 95, 10, 80, 40)];
    stateLab.textAlignment = NSTextAlignmentRight;
    stateLab.textColor = [UIColor orangeColor];
    stateLab.font = [UIFont systemFontOfSize:14];
    stateLab.text = @"交易成功";

    UIImageView *setLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"s_n_set_line"]];
    setLine.frame = CGRectMake(0, 49, SCREEN_WIDTH, 1);
    
    [headerView addSubview:grayColorView];
    [headerView addSubview:layerlable];
    [headerView addSubview:desLab];
    [headerView addSubview:stateLab];
    [headerView addSubview:setLine];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, whithBack.frame.size.height +
                                  desLab.frame.size.height);
    headerView.backgroundColor = [UIColor whiteColor];
    return headerView;
    
}

#pragma mark 创建foorterview
- (UIView *)creatFooterView{
    UIView *footerView = [[UIView alloc]init];
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
    footerView.backgroundColor = [UIColor whiteColor];
    

    
    UIImageView *setLineA = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"s_n_set_line"]];
    setLineA.frame = CGRectMake(0, 39, SCREEN_HEIGHT, 1);
    
    UIImageView *setLineB = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"s_n_set_line"]];
    setLineB.frame = CGRectMake(0, 79, SCREEN_HEIGHT, 1);
    
    UIImageView *setLineC = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"s_n_set_line"]];
    setLineB.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 1);
    

    [footerView addSubview:setLineA];
    [footerView addSubview:setLineB];
    [footerView addSubview:setLineC];
    
    return footerView;

}

#pragma mark  创建商品数量lable
- (UILabel *)creatNumLab{
    UILabel *numShop = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 40)];
//    numShop.text = @"共1件商品";
    numShop.textColor = [UIColor blackColor];
    numShop.textAlignment = NSTextAlignmentLeft;
    numShop.font = [UIFont systemFontOfSize:14];
    return numShop;
}
#pragma mark  创建运费lable
- (UILabel *)creatFreightLable{
    /**
     *  运费：
     */
    UILabel *freightLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, 0, 100, 40)];
    freightLab.text = @"运费：¥123.00";
    freightLab.textAlignment = NSTextAlignmentCenter;
    freightLab.font = [UIFont systemFontOfSize:14];
//    NSString *douB = @"：";
//    NSRange rangB = [freightLab.text rangeOfString:douB];
//    NSMutableAttributedString *strB = [[NSMutableAttributedString alloc] initWithString:freightLab.text];
//    [strB addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, rangB.location)];
//    [strB addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, rangB.location + 1)];
//    [strB addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(rangB.location + 1, freightLab.text.length  - rangB.location - 1)];
//    freightLab.attributedText = strB;
    return freightLab;
}

#pragma mark  创建运费内容
- (NSMutableAttributedString *)creeatFreightLableTextWith:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return nil;
    }else{
        NSString *douB = @"：";
        NSRange rangB = [string rangeOfString:douB];
        NSMutableAttributedString *strB = [[NSMutableAttributedString alloc] initWithString:string];
        [strB addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, rangB.location)];
        [strB addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, rangB.location + 1)];
        [strB addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(rangB.location + 1, string.length  - rangB.location - 1)];
        return strB;
    }
}
#pragma mark 创建付款lable
- (UILabel *)creatPriceLable{
    UILabel *priceTitle = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 130 , 0, 115, 40)];
    priceTitle.text = @"合计：¥123.00";
    priceTitle.textAlignment = NSTextAlignmentRight;
    return priceTitle;
}

#pragma mark  创建价格text
- (NSMutableAttributedString *)creatPriceTextWith:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return nil;
    }
    
    NSString *dou = @"：";
    NSRange rang = [string rangeOfString:dou];
    NSMutableAttributedString *strA = [[NSMutableAttributedString alloc] initWithString:string];
    [strA addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, rang.location)];
    [strA addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, rang.location + 1)];
    [strA addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(rang.location, string.length  - rang.location)];
    [strA addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(rang.location + 1, string.length  - rang.location - 1)];
    return strA;
}

#pragma mark 创建删除订单按钮
- (UIButton *)creatFooterLayerDeleteBtn{
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [deleteBtn setTitle:@"删除订单" forState:UIControlStateNormal];
    deleteBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    deleteBtn.layer.borderWidth = 1;
    deleteBtn.layer.cornerRadius = 8;
    return deleteBtn;
}
#pragma mark 创建重新购买按钮
- (UIButton *)creatFooterLayerAgainBuyBtn{
    UIButton *againBuy = [UIButton buttonWithType:UIButtonTypeCustom];
    [againBuy setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [againBuy setTitle:@"重新购买" forState:UIControlStateNormal];
    againBuy.layer.borderColor = [UIColor lightGrayColor].CGColor;
    againBuy.titleLabel.font = [UIFont systemFontOfSize:15];
    againBuy.layer.borderWidth = 1;
    againBuy.layer.cornerRadius = 8;
    return againBuy;
}
#pragma mark  创建付款按钮
- (UIButton *)creatFooterLayerPayBtn{
    UIButton *Buy = [UIButton buttonWithType:UIButtonTypeCustom];
    [Buy setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [Buy setTitle:@"付款" forState:UIControlStateNormal];
    Buy.layer.borderColor = [UIColor orangeColor].CGColor;
    Buy.titleLabel.font = [UIFont systemFontOfSize:15];
    Buy.layer.borderWidth = 1;
    Buy.layer.cornerRadius = 8;
    return Buy;
}
#pragma mark 创建footerView   的第二行左边的卡券图片
- (UIImageView *)creatSectionFooterBoottomLeftCardImageView{
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    UIImageView *leftImage  = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 30, 20)];
//    leftImage.image = [UIImage imageNamed:]
    leftImage.backgroundColor = [UIColor redColor];
    

    return leftImage;
}

#pragma mark 创建footerView  的卡券使用状态lable
- (UILabel *)creatSectionFooterLeftCardStateLab{
    UILabel *stateDes = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 60, 20)];
        stateDes.text = @"已使用";
        stateDes.textColor = [UIColor lightGrayColor];
        stateDes.textAlignment = NSTextAlignmentLeft;
    stateDes.font = [UIFont systemFontOfSize:14];
    return stateDes;
}
#pragma mark 头部刷新
- (void)headerRefresh{
    
    NSInteger index = self.backScrollView.contentOffset.x/SCREEN_WIDTH;
    if (index == 0 || index >(long) 4) {
        self.allPageNum = 0;
        self.ifAllToEnd = NO;
        
    } else if (index == 1) {
        self.needPayNum = 1;
        self.ifNeedPayToEnd = NO;
        
    }else if (index == 2){
        self.electronCardNum = 1;
        self.ifElectronCardToEnd = NO;
        
    }else if (index == 3){
        self.orderNum= 1;
        self.ifOrderToEnd = NO;
        
    }else if (index == 4){
        self.reimburseNum = 1;
        self.ifReimburseToEnd = NO;
    }

//获取数据
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        // 调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}

#pragma mark 尾部刷新
- (void)footerLoadData{
    
    
    NSInteger index = self.backScrollView.contentOffset.x/SCREEN_WIDTH;
    if (index == 0 || index >(long) 4) {
        if (self.ifAllToEnd == NO) {
            self.allPageNum ++;
            //获取数据
            
        }else{
            //如果是最后一页的话提示已经是最后一页，不在请求数据了
            [XEProgressHUD lightAlert:@"已经到最后一页"];
        }
        
    } else if (index == 1) {
        if (self.ifNeedPayToEnd == NO) {
            self.needPayNum ++;
            //获取数据
            
        }else{
            //如果是最后一页的话提示已经是最后一页，不在请求数据了
            [XEProgressHUD lightAlert:@"已经到最后一页"];
        }
        
    }else if (index == 2){
        if (self.ifElectronCardToEnd == NO) {
            self.electronCardNum ++;
            //获取数据
            
        }else{
            //如果是最后一页的话提示已经是最后一页，不在请求数据了
            [XEProgressHUD lightAlert:@"已经到最后一页"];
        }
        
    }else if (index == 3){
        if (self.ifOrderToEnd == NO) {
            self.orderNum ++;
            //获取数据
            
        }else{
            //如果是最后一页的话提示已经是最后一页，不在请求数据了
            [XEProgressHUD lightAlert:@"已经到最后一页"];
        }
    }else if (index == 4){
        
        if (self.ifReimburseToEnd == NO) {
            self.reimburseNum ++;
            //获取数据
            
        }else{
            //如果是最后一页的话提示已经是最后一页，不在请求数据了
            [XEProgressHUD lightAlert:@"已经到最后一页"];
        }

    }
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.electronTab) {
        return 10;
    }else if (tableView == self.orderTab){
        return 10;
    }else{
        return [self creatSectionHeaderView].frame.size.height;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lightGray = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 10)];
    lightGray.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];

    if (tableView == self.electronTab) {
        return lightGray;
    }else if (tableView == self.orderTab){
        return lightGray;
    }else{
        return [self creatSectionHeaderView];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.electronTab) {
        return 0;
    }else if (tableView == self.orderTab){
        return 0;
    }else{
        return [self creatFooterView].frame.size.height;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [self creatFooterView];
    //商品数量
    UILabel *numLab = [self creatNumLab];
    numLab.text = @"共一件商品";
    //运费
    UILabel *freightLab  = [self creatFreightLable];
    freightLab.frame = CGRectMake((SCREEN_WIDTH - 100)/2, 5, 100, 30);
    freightLab.attributedText = [self creeatFreightLableTextWith:@"运费：¥123.00"];
    //支付款项
    UILabel *price = [self creatPriceLable];
    price.frame =CGRectMake(SCREEN_WIDTH - 130 , 5, 115,30);
    price.attributedText = [self creatPriceTextWith:@"合计：¥123.00"];
    //卡片
    UIImageView *cardState = [self creatSectionFooterBoottomLeftCardImageView];
    cardState.frame = CGRectMake(15, 50, 40, 20);
    //卡片使用情况
    UILabel *cardUsed = [self creatSectionFooterLeftCardStateLab];
    cardUsed.frame = CGRectMake(60, 50, 60, 20);
    //删除按钮
    UIButton *delete = [self creatFooterLayerDeleteBtn];
    //支付按钮
    UIButton *payBtn = [self creatFooterLayerPayBtn];
    payBtn.frame = CGRectMake(SCREEN_WIDTH - 85, 45, 70, 30);
    
    //重新购买
    UIButton *againPay = [self creatFooterLayerAgainBuyBtn];
    
    if (tableView == self.allTab) {
        delete.frame = CGRectMake(SCREEN_WIDTH - 95, 45, 80, 30);
        [footerView addSubview:cardState];
        [footerView addSubview:cardUsed];
        [footerView addSubview:delete];
    }else if (tableView == self.needPayTab){
        delete.frame = CGRectMake(SCREEN_WIDTH - 190, 45, 90, 30);
        [footerView  addSubview:payBtn];
        [footerView addSubview:delete];
    }else if (tableView == self.electronTab){
        return nil;
    }else if (tableView == self.orderTab){
        return nil;
    }else if (tableView == self.reimburseTab){
        againPay.frame = CGRectMake(SCREEN_WIDTH - 105, 45, 90, 30);
        [footerView addSubview:freightLab];
        [footerView addSubview:price];
        [footerView addSubview:againPay];
    }
    [footerView addSubview:numLab];
    return footerView;
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.electronTab) {
        return 10;
    }else if (tableView == self.orderTab){
        return 10;
    }else{
        return 5;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.electronTab) {
        return 1;
    }else if (tableView == self.orderTab){
        return 1;
    }
    return 3;
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
            self.tableView = self.allTab;
            [self changeContentOfSet:self.allBtn];
            
        } else if (index == 1) {
            self.tableView = self.needPayTab;
            [self changeContentOfSet:self.needPayBtn];
            
        }else if (index == 2){
            self.tableView = self.electronTab;
            [self changeContentOfSet:self.electronCardBtn];
            
        }else if (index == 3){
            self.tableView = self.orderTab;
            [self changeContentOfSet:self.orderBtn];
        }else if (index == 4){
            self.tableView = self.reimburseTab;
            [self changeContentOfSet:self.reimburseBtn];
        }
    }else{
        NSLog(@"没有横向偏移，不做任何处理");
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
