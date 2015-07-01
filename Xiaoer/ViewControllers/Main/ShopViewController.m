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
#import "SearchListViewController.h"
#import "ActivityMainViewController.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XEShopHomeInfo.h"
#import "UIButton+WebCache.h"
@interface ShopViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,XEScrollPageDelegate,TouchCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *shopTabView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UICollectionView *headerCollection;
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIView *lunboBackView;

@property (nonatomic,strong)UICollectionViewFlowLayout *headerLayOut;
@property (nonatomic,strong)XEScrollPage *scrollPageView;


@property (nonatomic,assign)NSInteger numActivity;
@property (nonatomic,assign)NSInteger numNew;
@property (nonatomic,assign)BOOL addActivity;
@property (nonatomic,assign)BOOL addNew;
@property (nonatomic,assign)BOOL ifToEnd;

@property (nonatomic,assign)NSInteger pageNum;

/**
 *  轮播图数组
 */
@property (nonatomic,strong)NSMutableArray *bannerArray;
/**
 *  今日活动数组
 */
@property (nonatomic,strong)NSMutableArray *activityArray;
/**
 *  今日上新数组
 */
@property (nonatomic,strong)NSMutableArray *NewShopArray;

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

- (NSMutableArray *)bannerArray{
    if (!_bannerArray) {
        self.bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}
- (NSMutableArray *)activityArray{
    if (!_activityArray) {
        self.activityArray = [NSMutableArray array];
    }
    return _activityArray;
}
- (NSMutableArray *)NewShopArray{
    if (!_NewShopArray) {
        self.NewShopArray = [NSMutableArray array];
    }
    return _NewShopArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBtn.layer.cornerRadius = 10;
    self.searchBtn.layer.borderWidth = 1;
    self.searchBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    //布局heaerview的collectionview
//    [self configureHeaderCollectionView];
    
    //布局tableView
//    [self configureShopTableView];
    
    //布局轮播图
//    [self configureLunBoBackView];
    //布局searchView
//    [self configuresearchView];

    
//    self.numActivity = 6;
//    self.numNew = 20;
    self.addActivity = NO;
    self.addNew = NO;
    self.ifToEnd = NO;
    self.pageNum = 1;
//    [self getChooseDataWithTypeString:@"1,2"];
//    [self getHomeShopNewDataWithTypeString:@"3"];
    
        UIImageView *ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
        ImageView.image = [UIImage imageNamed:@"正在建设中6p"];
        [self.view addSubview:ImageView];

    
}

- (IBAction)backToMainPage:(id)sender {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.mainTabViewController.tabBar selectIndex:0];
}

- (void)configureLunBoBackViewWithArray:(NSMutableArray *)array{

    NSLog(@"布局轮播图");
    //轮播图
    CycleView *cycleView = [[CycleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
    cycleView.backgroundColor = [UIColor redColor];
    if (self.bannerArray.count > 0) {
        [cycleView configureHeaderWith:array];
    }else{
        
    }
    [self.lunboBackView addSubview:cycleView];

    
}

#pragma mark 搜索按钮
- (IBAction)searchBtnTouched:(id)sender {
    NSLog(@"搜索");
    SearchListViewController *search = [[SearchListViewController alloc]init];
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.mainTabViewController.navigationController pushViewController:search animated:YES];
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
    [self.shopTabView addFooterWithTarget:self action:@selector(footerLoadData)];
    
}

#pragma mark HeaderCollectionView
- (void)configureHeaderCollectionView{
    [self.headerCollection registerNib:[UINib nibWithNibName:@"ShopHeaderCollectCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    self.headerCollection.delegate = self;
    self.headerCollection.dataSource = self;
    self.headerCollection.collectionViewLayout = self.headerLayOut;
    
}
#pragma mark 请求数据
//请求今日上新数据
- (void)getHomeShopNewDataWithTypeString:(NSString *)typeString{
    __weak ShopViewController *weakSelf = self;
    [XEEngine shareInstance].serverPlatform = TestPlatform;
    int tag = [[XEEngine shareInstance] getConnectTag];

    NSString *PageString = [NSString stringWithFormat:@"%ld",self.pageNum];
    [[XEEngine shareInstance]getShopMainListInfomationWith:tag types:typeString pageNum:PageString];
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
        if (jsonRet[@"object"]) {
            NSLog(@"有返回数据");
            //判断是否到底
            NSString *endStr = [jsonRet[@"object"][@"end"]stringValue];
            if ([endStr isEqualToString:@"0"]) {
                self.ifToEnd = YES;
            }

            //添加模型数据
            NSMutableArray *dataArr = jsonRet[@"object"][@"shopHomes"];
            if (![jsonRet[@"object"][@"shopHomes"] isKindOfClass:[NSNull class]]) {
                NSLog(@"有模型数据");
                for (NSDictionary *dic in dataArr) {
                    NSString *type = [dic[@"type"] stringValue];
                    
                    if ([type isKindOfClass:[NSNull class]] ) {
                        NSLog(@"type不存在");
                        
                    }else{
                        if ([type isEqualToString:@"3"]) {
                            //判断是今日上新
                            XEShopHomeInfo *info = [[XEShopHomeInfo alloc]initWithDictionary:dic];
                            [self.NewShopArray addObject:info];
                            NSLog(@"%ld",self.NewShopArray.count);
                        } else {
                            //不是今日上新不做任何操作
                            
                        }
                    }

                    


                }
            }
            
            }else{
                NSLog(@"没有模型数据");
                [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
                return;
            }
 
        NSLog(@"self.NewShopArray.count == %ld",self.NewShopArray.count);
        [self.shopTabView reloadData];

    } tag:tag];

}

- (void)getChooseDataWithTypeString:(NSString *)types{
    __weak ShopViewController *weakSelf = self;
    [XEEngine shareInstance].serverPlatform = TestPlatform;
    int tag = [[XEEngine shareInstance] getConnectTag];

    [[XEEngine shareInstance]getShopMainListInfomationWith:tag types:types];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        //获取失败信息
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return ;
        }
        
        //判断是否存在模型数据
        if (![jsonRet[@"object"] isKindOfClass:[NSNull class]]) {
            NSLog(@"存在数据");
        }else{
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            return ;
        }
        
        if ([types isEqualToString:@"1,2,3"]) {
            NSLog(@"下拉刷新");
            if (self.bannerArray.count > 0) {
                [self.bannerArray removeAllObjects];
            }
            if (self.activityArray.count > 0) {
                [self.activityArray removeAllObjects];
            }
            if (self.NewShopArray.count > 0) {
                [self.NewShopArray removeAllObjects];
            }
            NSArray *modelArray = jsonRet[@"object"];
            for (NSDictionary *dic in modelArray) {
                //判断type是否存在
                if ([dic[@"type"] isKindOfClass:[NSNull class]]) {
                    NSLog(@"type不存在");
                }else{
                    
                    NSString *typeStr = [dic[@"type"] stringValue];
                    if ([typeStr isEqualToString:@"1"]) {
                        
                        XEShopHomeInfo *info = [[XEShopHomeInfo alloc]initWithDictionary:dic];
                        [self.bannerArray addObject:info];
                        
                    }
                    if ([typeStr isEqualToString:@"2"]) {
                        
                        XEShopHomeInfo *info = [[XEShopHomeInfo alloc]initWithDictionary:dic];
                        [self.activityArray addObject:info];
                        
                    }
                    if ([typeStr isEqualToString:@"3"]) {
                        
                        XEShopHomeInfo *info = [[XEShopHomeInfo alloc]initWithDictionary:dic];
                        [self.NewShopArray addObject:info];
                        
                    }
                    
                    
                }

            }
            NSLog(@"123 self.bannerArray.count == %ld",self.bannerArray.count);
            NSLog(@"123 self.activityArray.count == %ld",self.activityArray.count);
            NSLog(@"123 self.NewShopArray.count%ld",self.NewShopArray.count);
            [self configureLunBoBackViewWithArray:self.bannerArray];
            [self.shopTabView reloadData];

        }else if ([types isEqualToString:@"1,2"]){
            
            NSLog(@"只获取前两个部分数据");
            if (self.bannerArray.count > 0) {
                [self.bannerArray removeAllObjects];
            }
            if (self.activityArray.count > 0) {
                [self.activityArray removeAllObjects];
            }
            NSArray *modelArray = jsonRet[@"object"];
            
            for (NSDictionary *dic in modelArray) {
                
                NSString *typeStr = [dic[@"type"] stringValue];
                if ([dic[@"type"] isKindOfClass:[NSNull class]]) {
                    NSLog(@"type不存在");
                }else{
                    if ([typeStr isEqualToString:@"1"]) {
                        XEShopHomeInfo *info = [[XEShopHomeInfo alloc]initWithDictionary:dic];

                        [self.bannerArray addObject:info];
                    }
                    if ([typeStr isEqualToString:@"2"]) {
                        XEShopHomeInfo *info = [[XEShopHomeInfo alloc]initWithDictionary:dic];

                        [self.activityArray addObject:info];
                    }
                }

            }

            NSLog(@"12 self.bannerArray.count == %ld",self.bannerArray.count);
            NSLog(@"12  self.activityArray.count == %ld",self.activityArray.count);
            [self configureLunBoBackViewWithArray:self.bannerArray];
            [self.shopTabView reloadData];
            
        }


    } tag:tag];

    
}

#pragma mark 加载数据
- (void)headerLoadData{
    self.pageNum = 0;
    self.ifToEnd = NO;
    [self getChooseDataWithTypeString:@"1,2,3"];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
//        [self.shopTabView reloadData];
        // 调用endRefreshing可以结束刷新状态
        [self.shopTabView headerEndRefreshing];
    });
    
}
- (void)footerLoadData{
    if (self.ifToEnd == NO) {
        self.pageNum++;
        [self getHomeShopNewDataWithTypeString:@"3"];
    }else{
        //如果是最后一页的话提示已经是最后一页，不在请求数据了
        [XEProgressHUD lightAlert:@"已经到最后一页"];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        // 调用endRefreshing可以结束刷新状态
        [self.shopTabView footerEndRefreshing];
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
    
        return CGSizeMake(SCREEN_WIDTH /4 ,100);
    
}

//每个Item的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
        return UIEdgeInsetsMake(0, 0, 0, 0);

}


//点击item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    ToyMainViewController *toy = [[ToyMainViewController alloc]init];
    
    if (indexPath.row == 0) {
        toy.shopType = @"1";
        [appDelegate.mainTabViewController.navigationController pushViewController:toy animated:YES];

    }else if (indexPath.row == 1){
        ActivityMainViewController *activity = [[ActivityMainViewController alloc]init];
        activity.type = @"1";
        activity.category = @"1";
        
        [appDelegate.mainTabViewController.navigationController pushViewController:activity animated:YES];
    }

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
          NSUInteger numRow = self.activityArray.count/3;
        NSInteger yushu = self.activityArray.count%3;
        if (yushu > 0) {
            self.addActivity = YES;
            return numRow + 1;
            
        }else{
            return numRow;
        }
        
      
        
    } else if (section == 1) {
        
        NSUInteger numRow = self.NewShopArray.count/3;
        NSInteger yushu = self.NewShopArray.count%3;
        if (yushu > 0) {
            self.addNew = YES;
            NSLog(@"numRow + 1 == %ld",numRow + 1);

            return numRow + 1;
        }else{
            NSLog(@"numRow + 1 = %ld",numRow + 1);

            return numRow;
        }
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
    if (indexPath.section == 0) {

        if (self.addActivity == NO) {
            [cell configureCellWith:indexPath andNumberOfItemsInCell:3 moledArray:[NSArray arrayWithObjects:[self.activityArray objectAtIndex:indexPath.row*3],[self.activityArray objectAtIndex:indexPath.row*3 + 1],[self.activityArray objectAtIndex:indexPath.row*3 + 2], nil]];
        }else if (self.addActivity == YES){
            NSLog(@"self.activityArray.count ++++  %ld",self.activityArray.count);
            if (indexPath.row == self.activityArray.count/3) {
                //最后一行
                
                if (self.activityArray.count%3 == 1) {
                    [cell configureCellWith:indexPath andNumberOfItemsInCell:1 moledArray:[NSArray arrayWithObjects:[self.activityArray objectAtIndex:self.activityArray.count - 1], nil]];
                }else if (self.activityArray.count%3 == 2){
                    [cell configureCellWith:indexPath andNumberOfItemsInCell:2 moledArray:[NSArray arrayWithObjects:[self.activityArray objectAtIndex:indexPath.row * 3],[self.activityArray objectAtIndex:indexPath.row * 3 + 1], nil]];
                }
                
            }else{
                //不是最后一行

                [cell configureCellWith:indexPath andNumberOfItemsInCell:3 moledArray:[NSArray arrayWithObjects:[self.activityArray objectAtIndex:indexPath.row*3],[self.activityArray objectAtIndex:indexPath.row*3 + 1],[self.activityArray objectAtIndex:indexPath.row*3 + 2], nil]];
            }
            
        }

    }else if (indexPath.section == 1){

        if (self.addNew == NO) {
            [cell configureCellWith:indexPath andNumberOfItemsInCell:3 moledArray:[NSArray arrayWithObjects:[self.NewShopArray objectAtIndex:indexPath.row*3],[self.NewShopArray objectAtIndex:indexPath.row*3 + 1],[self.NewShopArray objectAtIndex:indexPath.row*3 + 2], nil]];
         }else if (self.addNew == YES){
             
            if (indexPath.row == self.NewShopArray.count/3) {
                NSLog(@"%ld",self.NewShopArray.count%3);
                if (self.NewShopArray.count%3 == 1) {
                    [cell configureCellWith:indexPath andNumberOfItemsInCell:1 moledArray:[NSArray arrayWithObjects:[self.NewShopArray objectAtIndex:self.NewShopArray.count - 1], nil]];
                }else if (self.NewShopArray.count%3 == 2){
                    [cell configureCellWith:indexPath andNumberOfItemsInCell:2 moledArray:[NSArray arrayWithObjects:[self.NewShopArray objectAtIndex:indexPath.row * 3],[self.NewShopArray objectAtIndex:indexPath.row * 3 + 1], nil]];
                }
            }else{
                [cell configureCellWith:indexPath andNumberOfItemsInCell:3 moledArray:[NSArray arrayWithObjects:[self.NewShopArray objectAtIndex:indexPath.row*3],[self.NewShopArray objectAtIndex:indexPath.row*3 + 1],[self.NewShopArray objectAtIndex:indexPath.row*3 + 2], nil]];
            }
        }
    }
    cell.tag = indexPath.section * 1000 + indexPath.row;
    cell.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];    return cell;
}
- (void)touchCellWithCellTag:(NSInteger)cellTag btnTag:(NSInteger)btnTag{
    if (cellTag < 1000) {
        
    }else if (cellTag >= 1000){
        cellTag = cellTag%1000;
    }
    
    NSLog(@"%ld %ld ",cellTag,btnTag);

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
