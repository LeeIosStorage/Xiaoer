//
//  ToyListViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/19.
//
//

#import "ToyListViewController.h"
#import "XETitleNavBarView.h"
#import "ToyListCollectionCell.h"
#import "ToyCollectionHeaderCell.h"
#import "ToyDetailViewController.h"
#import "XEEngine.h"
#import "MJRefresh.h"
#import "XEProgressHUD.h"
#import "XEShopListInfo.h"
@interface ToyListViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *naviLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UICollectionView *toyListCollection;
@property (nonatomic,strong)UICollectionViewFlowLayout *layOut;
@property (nonatomic,assign)NSInteger pageNum;
@property (nonatomic,strong)NSMutableArray *dataSources;

@property (nonatomic,assign)BOOL ifToEnd;

@end

@implementation ToyListViewController
- (NSMutableArray *)dataSources{
    if (!_dataSources) {
        self.dataSources = [NSMutableArray array];
    }
    return _dataSources;
}
- (UICollectionViewFlowLayout *)layOut{
    if (!_layOut) {
        self.layOut = [[UICollectionViewFlowLayout alloc]init];
        _layOut.scrollDirection =  UICollectionViewScrollDirectionVertical;
        _layOut.minimumLineSpacing = 10;
        _layOut.minimumInteritemSpacing = 10;
    }
    return _layOut;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
//    布局导航条
    [self confugureNaviTitle];
    
    [self configureCollectionView];

    self.pageNum = 1;
    self.ifToEnd = NO;
    [self setupRefresh];
    
    //获取数据
    [self getToyListData];

    
    
    
    
}

#pragma mark 布局collectionview
- (void)configureCollectionView{
    self.toyListCollection.delegate = self;
    self.toyListCollection.dataSource = self;
    self.toyListCollection.backgroundColor = [UIColor clearColor];

    [self.toyListCollection registerNib:[UINib nibWithNibName:@"ToyCollectionHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"header"];
    [self.toyListCollection registerNib:[UINib nibWithNibName:@"ToyListCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}

#pragma mark 设置刷新
- (void)setupRefresh{
    //下拉刷新(头部控件刷新的2种方法)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    
    [self.toyListCollection addHeaderWithCallback:^{[self headerRefreshing];}];
    [self.toyListCollection addFooterWithTarget:self action:@selector(footerGetData)];
    
    //自动刷新(一进入程序就下拉刷新)
//    [self.toyListCollection headerBeginRefreshing];
    
}

#pragma mark  头部刷新
- (void)headerRefreshing{
    //添加数据（刷新一次，新添加5个数据）
    self.ifToEnd = NO;
    self.pageNum = 1;
    [self getToyListData];
    
    // 2.2秒后刷新表格UI
    NSLog(@"SHUAIXN");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.toyListCollection reloadData];
        NSLog(@"SHUAIXN");
        // 调用endRefreshing可以结束刷新状态
        [self.toyListCollection headerEndRefreshing];
    });
    
}

#pragma mark 尾部刷新
- (void)footerGetData{
    if (self.ifToEnd == NO) {
        self.pageNum ++;
        [self getToyListData];
    }else{
        [XEProgressHUD lightAlert:@"已经到最后一页"];

    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.toyListCollection reloadData];
        // 调用endRefreshing可以结束刷新状态
        [self.toyListCollection footerEndRefreshing];
    });
}
#pragma mark 获取数据
- (void)getToyListData{
    __weak ToyListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    if (!self.name) {
        self.name = @"";
    }
    [[XEEngine shareInstance]getShopListInfoMationWith:tag category:self.category pagenum:[NSString stringWithFormat:@"%ld",(long)self.pageNum    ] type:self.type name:self.name serieid:self.serieid];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        
        
        
        //获取失败信息
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return ;
        }
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            return;
            
        }
        if ([jsonRet[@"object"][@"goodses"] isKindOfClass:[NSNull class]]) {
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            return;
        }
        NSString *endStr = [jsonRet[@"object"][@"end"]stringValue];
        if ([endStr isEqualToString:@"0"]) {
            self.ifToEnd = YES;
        }
        NSArray *array = jsonRet[@"object"][@"goodses"];
        NSLog(@"array ==== %@",array);
        if (array.count <= 0) {
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            return;
        }
        
        if (self.pageNum == 1) {
            [self.dataSources removeAllObjects];
        }
        for (NSDictionary *dic in array) {
            XEShopListInfo *info = [XEShopListInfo modelWithDictioanry:dic];
            [self.dataSources addObject:info];
        }
        [self.toyListCollection reloadData];
    } tag:tag];
}

#pragma mark 布局导航条
- (void)confugureNaviTitle{
    self.titleNavBar.alpha = 0;
    self.titleLable.backgroundColor = [UIColor clearColor];
    CGRect tframe = self.titleNavBar.frame;
    self.naviLable.center = self.titleNavBar.center;
    CGRect frame = self.naviLable.frame;
    frame.origin.y = tframe.size.height - frame.size.height;
    self.naviLable.frame = frame;
    self.titleLable.text = @"玩具专场";
    [self.view addSubview:self.naviLable];
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark collection delegate 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSources.count;
    
}
//设置分区数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        ToyCollectionHeaderCell *header = [collectionView dequeueReusableCellWithReuseIdentifier:@"header" forIndexPath:indexPath];
        [header configureHeaderCellWith:[self.dataSources objectAtIndex:indexPath.row] leftDay:self.leftDay];
        return header;
    }else{
        ToyListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        [cell configureOtherCellWith:[self.dataSources objectAtIndex:indexPath.row]];
        return cell;
        
    }
}

//每个Item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==0) {
        return CGSizeMake(SCREEN_WIDTH, 240);
    }else{
        return CGSizeMake((SCREEN_WIDTH - 30) / 2, (SCREEN_WIDTH - 30) / 2 + 60 );
    }
}

//每个Item的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//区头的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

//点击item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld %ld",(long)indexPath.section,(long)indexPath.row);
    ToyDetailViewController *detail = [[ToyDetailViewController alloc]init];
    [self.navigationController pushViewController:detail animated:YES];
    
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
