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
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XEShopSerieInfo.h"

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
@property (weak, nonatomic) IBOutlet UIButton *changeEvaluat;

//训练玩具
@property (weak, nonatomic) IBOutlet UIButton *changeTrain;
//另购玩具
@property (weak, nonatomic) IBOutlet UIButton *changeOther;
@property (nonatomic,strong)UIButton *button;

@property (weak, nonatomic) IBOutlet UILabel *changeLable;
@property (nonatomic,assign)BOOL touchChangeScro;
@property (nonatomic,assign)int type;
@property (nonatomic,assign)CGFloat begianSetX;

@property (nonatomic,strong)PullToRefreshView *pullRefreshViewA;
@property (nonatomic,strong)PullToRefreshView *pullRefreshViewB;
@property (nonatomic,strong)PullToRefreshView *pullRefreshViewC;

/**
 *  评测玩具数组
 */
@property (nonatomic,strong)NSMutableArray *evaluatArray;
/**
 *  训练玩具数组
 */
@property (nonatomic,strong)NSMutableArray *trainArray;

/**
 *  另购玩具数组
 */
@property (nonatomic,strong)NSMutableArray *otherArray;


@property (nonatomic,assign)NSInteger evaluatPage;
@property (nonatomic,assign)NSInteger trainPage;
@property (nonatomic,assign)NSInteger otherPage;


@property (nonatomic,assign)BOOL ifEcaluatToEnd;
@property (nonatomic,assign)BOOL ifTrainToEnd;
@property (nonatomic,assign)BOOL ifOtherToEnd;


@end

@implementation ToyMainViewController
//- (UILabel *)changeLable{
//    if (!_changeLable) {
//        self.changeLable = [[UILabel alloc]initWithFrame:CGRectMake(10, changeLabeY, SCREEN_WIDTH/3 - 20, 5)];
//        _changeLable.backgroundColor = [UIColor colorWithRed:43/255.0 green:186/255.0 blue:230/255.0 alpha:1];
//    }
//    return _changeLable;
//}
//- (UIButton *)changeEvaluat{
//    if (!_changeEvaluat) {
//        self.changeEvaluat = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_changeEvaluat setTitle:@"评测玩具" forState:UIControlStateNormal];
//        [_changeEvaluat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _changeEvaluat.frame = CGRectMake(0, 64, SCREEN_WIDTH/3, 30);
//        [_changeEvaluat addTarget:self action:@selector(changeContentOfSet:) forControlEvents:UIControlEventTouchUpInside];
//        _changeEvaluat.userInteractionEnabled = YES;
//    }
//    return _changeEvaluat;
//    
//}
//- (UIButton *)changeTrain{
//    if (!_changeTrain) {
//        self.changeTrain = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_changeTrain setTitle:@"训练玩具" forState:UIControlStateNormal];
//        [_changeTrain setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _changeTrain.frame = CGRectMake(SCREEN_WIDTH/3, 64, SCREEN_WIDTH/3, 30);
//        [_changeTrain addTarget:self action:@selector(changeContentOfSet:) forControlEvents:UIControlEventTouchUpInside];
//
//    }
//    return _changeTrain;
//}
//- (UIButton *)changeOther{
//    if (!_changeOther) {
//        self.changeOther = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_changeOther setTitle:@"另购玩具" forState:UIControlStateNormal];
//        [_changeOther setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _changeOther.frame = CGRectMake(SCREEN_WIDTH/3* 2, 64, SCREEN_WIDTH/3, 30);
//        [_changeOther addTarget:self action:@selector(changeContentOfSet:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _changeOther;
//}
- (NSMutableArray *)evaluatArray{
    if (!_evaluatArray) {
        self.evaluatArray = [NSMutableArray array];
    }
    return _evaluatArray;
}
- (NSMutableArray *)trainArray{
    if (!_trainArray) {
        self.trainArray = [NSMutableArray array];
    }
    return _trainArray;
}
- (NSMutableArray *)otherArray{
    if (!_otherArray) {
        self.otherArray = [NSMutableArray array];
    }
    return _otherArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"玩具";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.touchChangeScro = NO;
    self.evaluatPage = 1;
    self.trainPage = 1;
    self.otherPage = 1;
    //布局backScrollView
    [self configurebackScrollView];
    [self configureChangeLableAndChangeBtn];
    self.tableView = self.evaluatingTab;
    [self addRefreshToTabView];
    
    
    //开始加载数据
    //获取评测玩具数据
    [self getDataWithCategory:@"1" PageNum:[NSString stringWithFormat:@"%ld",(long)self.evaluatPage]];
    //获取训练玩具数据
    [self getDataWithCategory:@"2" PageNum:[NSString stringWithFormat:@"%ld",(long)self.evaluatPage]];
    //获取另购玩具数据
    [self getDataWithCategory:@"3" PageNum:[NSString stringWithFormat:@"%ld",(long)self.evaluatPage]];
}

#pragma mark  请求数据
- (void)getDataWithCategory:(NSString *)category PageNum:(NSString *)pageNum{
    __weak ToyMainViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance]getShopSeriousInfomationWithType:self.shopType tag:tag category:category pagenum:pageNum];
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
        if ([jsonRet[@"object"][@"series"] isKindOfClass:[NSNull class]]) {
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            return;
        }
        NSString *endStr = [jsonRet[@"object"][@"end"]stringValue];
        NSArray *array = jsonRet[@"object"][@"series"];
        NSLog(@"array ==== %@",array);
        if (array.count <= 0) {
            return;
        }
        
        if ([category isEqualToString:@"1"]) {
            //评测
            NSLog(@"1111 json = %@",jsonRet);
            if ([endStr isEqualToString:@"0"
                ]) {
                self.ifEcaluatToEnd = YES;
            }
            if (self.evaluatPage == 1) {
                if (self.evaluatArray.count > 0) {
                    [self.evaluatArray removeAllObjects];
                }
            }

            for (NSDictionary *dic in jsonRet[@"object"][@"series"]) {
                XEShopSerieInfo *info = [XEShopSerieInfo modelWithDictioanry:dic];
                [self.evaluatArray addObject:info];
            }

            
        }else if ([category isEqualToString:@"2"]){
            //训练
            NSLog(@"2222 json = %@",jsonRet);
            if ([endStr isEqualToString:@"0"
                 ]) {
                self.ifTrainToEnd = YES;
            }
            if (self.trainPage == 1) {
                if (self.trainArray.count > 0) {
                    [self.trainArray removeAllObjects];
                }
            }

            for (NSDictionary *dic in jsonRet[@"object"][@"series"]) {
                XEShopSerieInfo *info = [XEShopSerieInfo modelWithDictioanry:dic];
                [self.trainArray addObject:info];
            }

        }else if ([category isEqualToString:@"3"]){
            //另购
            NSLog(@"3333 json = %@",jsonRet);
            if ([endStr isEqualToString:@"0"
                 ]) {
                self.ifOtherToEnd = YES;
            }
            if (self.otherPage == 1) {
                if (self.otherArray.count > 0) {
                    [self.otherArray removeAllObjects];
                }
                
            }

            for (NSDictionary *dic in jsonRet[@"object"][@"series"]) {
                XEShopSerieInfo *info = [XEShopSerieInfo modelWithDictioanry:dic];
                [self.otherArray addObject:info];
            }


        }
        NSLog(@"-----------%ld %ld %ld",(unsigned long)self.evaluatArray.count,(unsigned long)self.trainArray.count,(unsigned long)self.otherArray.count);
        
        [self.evaluatingTab reloadData];
        [self.trainTab reloadData];
        [self.otherBuyTab reloadData];
    } tag:tag];
    
}
#pragma mark添加刷新控件
- (void)addRefreshToTabView{
    self.pullRefreshViewA = [[PullToRefreshView alloc] initWithScrollView:self.evaluatingTab];
    self.pullRefreshViewB = [[PullToRefreshView alloc] initWithScrollView:self.trainTab];
    
    self.pullRefreshViewC = [[PullToRefreshView alloc] initWithScrollView:self.otherBuyTab];
    
    self.pullRefreshViewA.delegate = self;
    self.pullRefreshViewC.delegate = self;
    
    self.pullRefreshViewB.delegate = self;
    
    [self.evaluatingTab addSubview:self.pullRefreshViewA];
    [self.trainTab addSubview:self.pullRefreshViewB];
    [self.otherBuyTab addSubview:self.pullRefreshViewC];
    
    [self.evaluatingTab addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.trainTab addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.otherBuyTab addFooterWithTarget:self action:@selector(footerRefresh)];
}



#pragma mark PullToRefreshViewDelegate 头部刷新
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    
    NSInteger index = SCREEN_WIDTH/self.backScrollView.contentOffset.x;
    
        if (index < 0 || index >(long) 1) {
            NSLog(@"11  index == %ld",(long)index);
            self.evaluatPage = 1;
            self.ifEcaluatToEnd = NO;
            [self getDataWithCategory:@"1" PageNum:[NSString stringWithFormat:@"%ld",(long)self.evaluatPage]];
            
        } else if (index == 1) {
            self.trainPage = 1;
            self.ifTrainToEnd = NO;
            [self getDataWithCategory:@"2" PageNum:[NSString stringWithFormat:@"%ld",(long)self.trainPage]];
            
        }else if (index == 0){
            self.otherPage = 1;
            self.ifOtherToEnd = NO;
            [self getDataWithCategory:@"3" PageNum:[NSString stringWithFormat:@"%ld",(long)self.otherPage]];
        }
    NSLog(@"延迟动画显示完成加载");
    [self performSelector:@selector(finishFooterLoad) withObject:nil afterDelay:1.0];

    
}
- (void)finishFooterLoad{
    NSInteger index = SCREEN_WIDTH/self.backScrollView.contentOffset.x;
    NSLog(@"index == %ld",(long)index);
    if (index < 0 || index >(long) 1) {
        [self.pullRefreshViewA finishedLoading];
    } else if (index == 1) {
        [self.pullRefreshViewB finishedLoading];
        
    }else if (index == 0){
        [self.pullRefreshViewC finishedLoading];
    }

}
- (NSDate *)pullToRefreshViewLastUpdated:(PullToRefreshView *)view {
    return [NSDate date];
}


#pragma mark 尾部刷新
- (void)footerRefresh{
    NSInteger index = SCREEN_WIDTH/self.backScrollView.contentOffset.x;
    
    if (index < 0 || index >(long) 1) {
        if (self.ifEcaluatToEnd == NO) {
            self.evaluatPage++;
            [self getDataWithCategory:@"1" PageNum:[NSString stringWithFormat:@"%ld",(long)self.evaluatPage]];
        }else{
            //如果是最后一页的话提示已经是最后一页，不在请求数据了
            [XEProgressHUD lightAlert:@"已经到最后一页"];
        }
        
    } else if (index == 1) {
        if (self.ifTrainToEnd == NO) {
            self.trainPage++;
            [self getDataWithCategory:@"2" PageNum:[NSString stringWithFormat:@"%ld",(long)self.trainPage]];
        }else{
            //如果是最后一页的话提示已经是最后一页，不在请求数据了
            [XEProgressHUD lightAlert:@"已经到最后一页"];
        }
    }else if (index == 0){
        if (self.ifOtherToEnd == NO) {
            self.otherPage++;
            [self getDataWithCategory:@"3" PageNum:[NSString stringWithFormat:@"%ld",(long)self.otherPage]];
        }else{
            //如果是最后一页的话提示已经是最后一页，不在请求数据了
            [XEProgressHUD lightAlert:@"已经到最后一页"];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        // 调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });
}


#pragma mark 头部按钮点击
- (IBAction)pingceBtnTouched:(id)sender {
    self.touchChangeScro = YES;
    [self changeContentOfSet:(UIButton *)sender];

}

- (IBAction)trainBtnTouched:(id)sender {
    self.touchChangeScro = YES;
    [self changeContentOfSet:(UIButton *)sender];

}
- (IBAction)otherBuyBtnTouched:(id)sender {
    self.touchChangeScro = YES;
    [self changeContentOfSet:(UIButton *)sender];
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

    CGRect rect = self.changeLable.frame;
    rect.origin.x = self.type * SCREEN_WIDTH/3  + 10;
        [UIView animateWithDuration:0.3 animations:^{
            self.changeLable.frame = rect;
            if (self.touchChangeScro == YES) {
                [self.backScrollView setContentOffset:CGPointMake(self.type * SCREEN_WIDTH, 0)];
                self.touchChangeScro = NO;

            }else{
                NSLog(@"手动滑动tableview，不再次做平移处理");
            }
           
        }];
    
}

#pragma mark 布局backScrollView
- (void)configurebackScrollView{
    
    self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
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
    
    [self.evaluatingTab registerNib:[UINib nibWithNibName:@"ToyMainTabCell" bundle:nil] forCellReuseIdentifier:@"evaluat"];
    [self.trainTab registerNib:[UINib nibWithNibName:@"ToyMainTabCell" bundle:nil] forCellReuseIdentifier:@"train"];
    [self.otherBuyTab registerNib:[UINib nibWithNibName:@"ToyMainTabCell" bundle:nil] forCellReuseIdentifier:@"other"];
    
    self.evaluatingTab.delegate = self;
    self.trainTab.delegate = self;
    self.otherBuyTab.delegate = self;
    self.evaluatingTab.dataSource = self;
    self.trainTab.dataSource = self;
    self.otherBuyTab.dataSource = self;
}
#pragma mark  布局下划线和头部按钮
- (void)configureChangeLableAndChangeBtn{
    
    CGRect rect = self.changeLable.frame;
    rect.size.width = SCREEN_WIDTH/3 - 20;
    self.changeLable.frame = rect;
    
    //使button 显示的文字居中
    self.changeEvaluat.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.changeOther.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.changeOther.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
}


#pragma mark tableView  代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.evaluatingTab) {
        return self.evaluatArray.count;
    }
    if (tableView == self.trainTab) {
        return self.trainArray.count;
    }
    if (tableView == self.otherBuyTab) {
        return self.otherArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.evaluatingTab) {
        ToyMainTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"evaluat" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configureCellWithModel:[self.evaluatArray objectAtIndex:indexPath.row]];
            return cell;
        }
    
    if (tableView == self.trainTab) {
        ToyMainTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"train" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell configureCellWithModel:[self.trainArray objectAtIndex:indexPath.row]];

        return cell;

    }
    
    if (tableView == self.otherBuyTab) {
        ToyMainTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"other" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configureCellWithModel:[self.otherArray objectAtIndex:indexPath.row]];

        return cell;
    }


    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ToyListViewController *list = [[ToyListViewController alloc]init];

    NSInteger index = SCREEN_WIDTH/self.backScrollView.contentOffset.x;
        if (index < 0 || index >(long) 1) {
            list.type =  @"1";
            list.category = @"1";
            XEShopSerieInfo *ser = (XEShopSerieInfo *)[self.evaluatArray objectAtIndex:indexPath.row];
            list.serieInfo = ser;


        } else if (index == 1) {
            self.tableView = self.trainTab;
            list.type =  @"1";
            list.category = @"2";
            XEShopSerieInfo *ser = (XEShopSerieInfo *)[self.trainArray objectAtIndex:indexPath.row];

            list.serieInfo = ser;


        }else if (index == 0){
            self.tableView = self.otherBuyTab;
            list.type =  @"1";
            list.category = @"3";
            XEShopSerieInfo *ser = (XEShopSerieInfo *)[self.otherArray objectAtIndex:indexPath.row];
            list.serieInfo = ser;

        }
    
    [self.navigationController pushViewController:list animated:YES];
    
}

#pragma mark scrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"%f",self.backScrollView.contentOffset.x);
    self.begianSetX = self.backScrollView.contentOffset.x;
    self.touchChangeScro = NO;
    NSLog(@"开始拖拽scrollView");

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = SCREEN_WIDTH/self.backScrollView.contentOffset.x;
    NSLog(@"index == %ld",(long)index);

    if (self.begianSetX != self.backScrollView.contentOffset.x) {
        if (index < 0 || index >(long) 1) {
            NSLog(@"11  index == %ld",(long)index);
            self.tableView = self.evaluatingTab;
            [self changeContentOfSet:self.changeEvaluat];
            
        } else if (index == 1) {
            self.tableView = self.trainTab;
            [self changeContentOfSet:self.changeTrain];
            
        }else if (index == 0){
            self.tableView = self.otherBuyTab;
            [self changeContentOfSet:self.changeOther];
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
