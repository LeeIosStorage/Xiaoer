//
//  ActivityViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/16.
//
//

#import "ActivityViewController.h"
#import "XEProgressHUD.h"
#import "XEEngine.h"
#import "XEActivityInfo.h"
#import "ActivityViewCell.h"
#import "XERecipesInfo.h"
#import "CategoryItemCell.h"
#import "ActivityDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "CollectionViewController.h"
#import "ODRefreshControl.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "XELinkerHandler.h"

#define ACTIVITY_TYPE_APPLY     0
#define ACTIVITY_TYPE_HISTORY   1

@interface ActivityViewController ()<UITableViewDataSource,UITableViewDelegate>
{
//    ODRefreshControl *_applyRefreshControl;
//    ODRefreshControl *_historyRefreshControl;
//    BOOL _isScrollViewDrag;
}
@property (strong, nonatomic) NSMutableArray *activityList;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *historyActivityList;
@property (nonatomic, strong) IBOutlet UITableView *historyTableView;

@property (assign, nonatomic) NSInteger selectedSegmentIndex;
@property (assign, nonatomic) SInt64  applyNextCursor;
@property (assign, nonatomic) BOOL applyCanLoadMore;
@property (assign, nonatomic) SInt64  historyNextCursor;
@property (assign, nonatomic) BOOL historyCanLoadMore;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = UIColorRGB(240, 240, 240);
    
//    _applyRefreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
//    [_applyRefreshControl addTarget:self action:@selector(applyRefreshControlBeginPull:) forControlEvents:UIControlEventValueChanged];
//    _historyRefreshControl = [[ODRefreshControl alloc] initInScrollView:self.historyTableView];
//    [_historyRefreshControl addTarget:self action:@selector(historyRefreshControlBeginPull:) forControlEvents:UIControlEventValueChanged];
    
    self.pullRefreshView = [[PullToRefreshView alloc] initWithScrollView:self.tableView];
    self.pullRefreshView.delegate = self;
    [self.tableView addSubview:self.pullRefreshView];
    
    self.pullRefreshView2 = [[PullToRefreshView alloc] initWithScrollView:self.historyTableView];
    self.pullRefreshView2.delegate = self;
    [self.historyTableView addSubview:self.pullRefreshView2];
    
    [self feedsTypeSwitch:ACTIVITY_TYPE_APPLY needRefreshFeeds:YES];
    
    __weak ActivityViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        if (!weakSelf) {
            return;
        }
        if (!weakSelf.applyCanLoadMore) {
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            weakSelf.tableView.showsInfiniteScrolling = NO;
            return ;
        }
        
        int tag = [[XEEngine shareInstance] getConnectTag];
        [[XEEngine shareInstance] getApplyActivityListWithPage:(int)weakSelf.applyNextCursor uid:[XEEngine shareInstance].uid tag:tag];
        [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
            if (!weakSelf) {
                return;
            }
            
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
            if (!jsonRet || errorMsg) {
                if (!errorMsg.length) {
                    errorMsg = @"请求失败";
                }
                [XEProgressHUD AlertError:errorMsg];
                return;
            }
            [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
            
            NSArray *object = [[jsonRet objectForKey:@"object"] objectForKey:@"activity"];
            for (NSDictionary *dic in object) {
                XEActivityInfo *activityInfo = [[XEActivityInfo alloc] init];
                [activityInfo setActivityInfoByJsonDic:dic];
                [weakSelf.activityList addObject:activityInfo];
            }
            weakSelf.applyCanLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
            if (!weakSelf.applyCanLoadMore) {
                weakSelf.tableView.showsInfiniteScrolling = NO;
            }else{
                weakSelf.tableView.showsInfiniteScrolling = YES;
                weakSelf.applyNextCursor ++;
            }
            [weakSelf.tableView reloadData];
            
        } tag:tag];
    }];
    
    [self.historyTableView addInfiniteScrollingWithActionHandler:^{
        if (!weakSelf) {
            return;
        }
        if (!weakSelf.historyCanLoadMore) {
            [weakSelf.historyTableView.infiniteScrollingView stopAnimating];
            weakSelf.historyTableView.showsInfiniteScrolling = NO;
            return ;
        }
        
        int tag = [[XEEngine shareInstance] getConnectTag];
        [[XEEngine shareInstance] getHistoryActivityListWithPage:(int)weakSelf.historyNextCursor tag:tag];
        [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
            if (!weakSelf) {
                return;
            }
            
            [weakSelf.historyTableView.infiniteScrollingView stopAnimating];
            NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
            if (!jsonRet || errorMsg) {
                if (!errorMsg.length) {
                    errorMsg = @"请求失败";
                }
                [XEProgressHUD AlertError:errorMsg];
                return;
            }
            [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
            
            NSArray *object = [[jsonRet objectForKey:@"object"] objectForKey:@"activity"];
            for (NSDictionary *dic in object) {
                XERecipesInfo *recipesInfo = [[XERecipesInfo alloc] init];
                [recipesInfo setRecipesInfoByDic:dic];
                [weakSelf.historyActivityList addObject:recipesInfo];
            }
            weakSelf.historyCanLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
            if (!weakSelf.historyCanLoadMore) {
                weakSelf.historyTableView.showsInfiniteScrolling = NO;
            }else{
                weakSelf.historyTableView.showsInfiniteScrolling = YES;
                weakSelf.historyNextCursor ++;
            }
            [weakSelf.historyTableView reloadData];
            
        } tag:tag];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
//    [self setRightButtonWithTitle:@"我的收藏" selector:@selector(mineCollectAction:)];
    [self setRightButtonWithImageName:@"common_collect_icon" selector:@selector(mineCollectAction:)];
    [self setSegmentedControlWithSelector:@selector(segmentedControlAction:) items:@[@"活动报名",@"历史活动"]];
}

-(void)feedsTypeSwitch:(int)tag needRefreshFeeds:(BOOL)needRefresh
{
    if (tag == ACTIVITY_TYPE_APPLY) {
        //减速率
        self.historyTableView.decelerationRate = 0.0f;
        self.tableView.decelerationRate = 1.0f;
        self.historyTableView.hidden = YES;
        self.tableView.hidden = NO;
        
        if (!_activityList) {
            [self refreshActivityList:YES];
            return;
        }
        if (needRefresh) {
            [self refreshActivityList:YES];
        }
    }else if (tag == ACTIVITY_TYPE_HISTORY){
        
        self.historyTableView.decelerationRate = 1.0f;
        self.tableView.decelerationRate = 0.0f;
        self.tableView.hidden = YES;
        self.historyTableView.hidden = NO;
        if (!_historyActivityList) {
            [self refreshHistoryActivityList:YES];
            return;
        }
        if (needRefresh) {
            [self refreshHistoryActivityList:YES];
        }
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

- (void)refreshActivityList:(BOOL)isAlert{
    
    if (isAlert) {
        [XEProgressHUD AlertLoading:@"努力加载中..."];
    }
    _applyNextCursor = 1;
    __weak ActivityViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getApplyActivityListWithPage:(int)_applyNextCursor uid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        [XEProgressHUD AlertLoadDone];
        [self.pullRefreshView finishedLoading];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg];
            return;
        }
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
        weakSelf.activityList = [[NSMutableArray alloc] init];
        
        NSArray *object = [[jsonRet objectForKey:@"object"] objectForKey:@"activity"];
        for (NSDictionary *dic in object) {
            XEActivityInfo *activityInfo = [[XEActivityInfo alloc] init];
            [activityInfo setActivityInfoByJsonDic:dic];
            [weakSelf.activityList addObject:activityInfo];
        }
        
        weakSelf.applyCanLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
        if (!weakSelf.applyCanLoadMore) {
            weakSelf.tableView.showsInfiniteScrolling = NO;
        }else{
            weakSelf.tableView.showsInfiniteScrolling = YES;
            weakSelf.applyNextCursor ++;
        }
        
        [weakSelf.tableView reloadData];
        
    }tag:tag];
}

- (void)refreshHistoryActivityList:(BOOL)isAlert{
    
    if (isAlert) {
        [XEProgressHUD AlertLoading:@"努力加载中..."];
    }
    _historyNextCursor = 1;
    __weak ActivityViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getHistoryActivityListWithPage:(int)_historyNextCursor tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        [XEProgressHUD AlertLoadDone];
        [self.pullRefreshView2 finishedLoading];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg];
            return;
        }
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
        
        weakSelf.historyActivityList = [[NSMutableArray alloc] init];
        NSArray *object = [[jsonRet objectForKey:@"object"] objectForKey:@"activity"];
        for (NSDictionary *dic in object) {
            XERecipesInfo *recipesInfo = [[XERecipesInfo alloc] init];
            [recipesInfo setRecipesInfoByDic:dic];
            [weakSelf.historyActivityList addObject:recipesInfo];
        }
        
        weakSelf.historyCanLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
        if (!weakSelf.historyCanLoadMore) {
            weakSelf.historyTableView.showsInfiniteScrolling = NO;
        }else{
            weakSelf.historyTableView.showsInfiniteScrolling = YES;
            weakSelf.historyNextCursor ++;
        }
        
        [weakSelf.historyTableView reloadData];
        
    }tag:tag];
}

#pragma mark - custom
-(void)mineCollectAction:(id)sender{
    CollectionViewController *cVc = [[CollectionViewController alloc] init];
    [self.navigationController pushViewController:cVc animated:YES];
}

-(void)segmentedControlAction:(UISegmentedControl *)sender{
    
    _selectedSegmentIndex = sender.selectedSegmentIndex;
    [self feedsTypeSwitch:(int)_selectedSegmentIndex needRefreshFeeds:NO];
    switch (_selectedSegmentIndex) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        default:
            break;
    }
}

//#pragma mark - ODRefreshControl
//- (void)applyRefreshControlBeginPull:(ODRefreshControl *)refreshControl
//{
//    if (_isScrollViewDrag) {
//        [self refreshActivityList:NO];
//    }
//}
//- (void)historyRefreshControlBeginPull:(ODRefreshControl *)refreshControl
//{
//    if (_isScrollViewDrag) {
//        [self refreshHistoryActivityList:NO];
//    }
//}
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    _isScrollViewDrag = YES;
//}

#pragma mark PullToRefreshViewDelegate
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    if (view == self.pullRefreshView) {
        [self refreshActivityList:NO];
    }else if (view == self.pullRefreshView2){
        [self refreshHistoryActivityList:NO];
    }
}

- (NSDate *)pullToRefreshViewLastUpdated:(PullToRefreshView *)view {
    return [NSDate date];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.historyTableView) {
        return _historyActivityList.count;
    }
    return _activityList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.historyTableView) {
        return 84;
    }
    return 220;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.historyTableView) {
        
        static NSString *CellIdentifier = @"CategoryItemCell";
        CategoryItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        
        XERecipesInfo *recipesInfo = _historyActivityList[indexPath.row];
        if (![recipesInfo.recipesImageUrl isEqual:[NSNull null]]) {
            [cell.infoImageView sd_setImageWithURL:[NSURL URLWithString:recipesInfo.recipesImageUrl] placeholderImage:[UIImage imageNamed:@"information_placeholder_icon"]];
        }else{
            [cell.infoImageView sd_setImageWithURL:nil];
            [cell.infoImageView setImage:[UIImage imageNamed:@"information_placeholder_icon"]];
        }
        cell.titleLabel.text = recipesInfo.title;
        
        if (indexPath.row == 0) {
            cell.topline.hidden = NO;
        }
        return cell;
    }
    static NSString *CellIdentifier = @"ActivityViewCell";
    ActivityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    XEActivityInfo *activityInfo = _activityList[indexPath.row];
    cell.activityInfo = activityInfo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    if (tableView == self.historyTableView) {
        id vc = [XELinkerHandler handleDealWithHref:@"http://www.baidu.com" From:self.navigationController];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (tableView == self.tableView){
        XEActivityInfo *activityInfo = _activityList[indexPath.row];
        ActivityDetailsViewController *vc = [[ActivityDetailsViewController alloc] init];
        vc.activityInfo = activityInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
