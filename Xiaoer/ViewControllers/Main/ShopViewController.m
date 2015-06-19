//
//  ShopViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/18.
//
//

#import "ShopViewController.h"
#import "MJRefresh.h"
#import "ShopHeaderCollectCell.h"
#import "ShopViewCell.h"
#import "XEScrollPage.h"
#import "CycleView.h"
#import "AppDelegate.h"
#import "ToyMainViewController.h"
@interface ShopViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,TableViewCellDelegate,XEScrollPageDelegate>
@property (weak, nonatomic) IBOutlet UITableView *shopTabView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UICollectionView *headerCollection;
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIView *lunboBackView;

@property (nonatomic,strong)UICollectionViewFlowLayout *headerLayOut;
@property (nonatomic,strong)XEScrollPage *scrollPageView;

@end

@implementation ShopViewController
- (UICollectionViewFlowLayout *)headerLayOut{
    if (!_headerLayOut) {
        self.headerLayOut = [[UICollectionViewFlowLayout alloc]init];
        _headerLayOut.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
        _headerLayOut.minimumLineSpacing = 0;
        _headerLayOut.minimumInteritemSpacing = 0;
    }
    return _headerLayOut;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBtn.layer.cornerRadius = 10;
    self.searchBtn.layer.borderWidth = 1;
    self.searchBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    //布局heaerview的collectionview
    [self configureHeaderCollectionView];
    
    //布局tableView
    [self configureShopTableView];
    
    //布局轮播图
    [self configureLunBoBackView];
//    //布局searchView
//    [self configuresearchView];
    UIImageView *ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    ImageView.image = [UIImage imageNamed:@"正在建设中6p"];
    [self.view addSubview:ImageView];
    
}
- (IBAction)backToMainPage:(id)sender {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.mainTabViewController.tabBar selectIndex:0];
}

- (void)configureLunBoBackView{

    //轮播图
    CycleView *cycleView = [[CycleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
    cycleView.backgroundColor = [UIColor redColor];
    [cycleView configureHeader];
    [self.lunboBackView addSubview:cycleView];
    
}

#pragma mark 搜索按钮
- (IBAction)searchBtnTouched:(id)sender {
    NSLog(@"搜索");
}

#pragma mark 布局searchView
- (void)configuresearchView{
    CGRect tframe = self.titleNavBar.frame;
    self.searchView.center = self.titleNavBar.center;
    CGRect frame = self.searchView.frame;
    frame.origin.y = tframe.size.height - frame.size.height;
    self.searchView.frame = frame;
    [self.searchView setBackgroundColor:[UIColor clearColor]];
    [self.titleNavBar addSubview:self.searchView];
}


#pragma mark ShopTableView
- (void)configureShopTableView{
    
    [self.shopTabView registerNib:[UINib nibWithNibName:@"ShopViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.shopTabView.tableHeaderView = self.headerView;
    [self.shopTabView addHeaderWithTarget:self action:@selector(headerLoadData)];
    self.shopTabView.userInteractionEnabled = NO;
    
}

#pragma mark HeaderCollectionView
- (void)configureHeaderCollectionView{
    
    [self.headerCollection registerNib:[UINib nibWithNibName:@"ShopHeaderCollectCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    self.headerCollection.delegate = self;
    self.headerCollection.dataSource = self;
    self.headerCollection.collectionViewLayout = self.headerLayOut;
    
}
#pragma mark 加载数据
- (void)headerLoadData{
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.shopTabView reloadData];
        // 调用endRefreshing可以结束刷新状态
        [self.shopTabView headerEndRefreshing];
    });
    
}

#pragma mark collection delegate dataSources

//设置分区数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 4;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ShopHeaderCollectCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    [item configuehHeaderCollectCellWith:indexPath];
    return item;
    
}

//每个Item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
        return CGSizeMake([UIScreen mainScreen].bounds.size.width /4 ,100);
    
}

//每个Item的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
        return UIEdgeInsetsMake(0, 0, 0, 0);

}


//点击item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld %ld",indexPath.section,indexPath.row);
    NSLog(@"%@",self.navigationController);
    ToyMainViewController *toy = [[ToyMainViewController alloc]init];
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.mainTabViewController.navigationController pushViewController:toy animated:YES];

}





#pragma mark tableView delegate dataSources

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
        
    } else if (section == 1) {
        
        return 2;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    lable.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    if (section == 0) {
        lable.text = @"  今日活动";
    }else if (section == 1){
        lable.text = @"  今日上新";
    }
    return lable;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell configureCellWith:indexPath];
    cell.tag = indexPath.section * 1000 + indexPath.row;
    return cell;
}

#pragma mark 瀑布流的点击回调
- (void)touchCellWithSection:(NSInteger)section row:(NSInteger)row{
    NSLog(@"tag = %ld %ld ",section,row);
    
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
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
