//
//  MineActivityListViewController.m
//  Xiaoer
//
//  Created by KID on 15/2/3.
//
//

#import "MineActivityListViewController.h"
#import "XEEngine.h"
#import "XEActivityInfo.h"
#import "XEProgressHUD.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "ActivityApplyViewCell.h"
#import "ActivityDetailsViewController.h"

#define ACTIVITY_TYPE_APPLY     0
#define ACTIVITY_TYPE_COLLECT   1

@interface MineActivityListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
}
@property (strong, nonatomic) NSMutableArray *applyActivityList;
@property (nonatomic, strong) IBOutlet UITableView *applyTableView;
@property (strong, nonatomic) NSMutableArray *collectActivityList;
@property (nonatomic, strong) IBOutlet UITableView *collectTableView;

@property (assign, nonatomic) NSInteger selectedSegmentIndex;
@property (assign, nonatomic) SInt64  applyNextCursor;
@property (assign, nonatomic) BOOL applyCanLoadMore;
@property (assign, nonatomic) SInt64  collectNextCursor;
@property (assign, nonatomic) BOOL collectCanLoadMore;

@end

@implementation MineActivityListViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.applyTableView setEditing:NO];
    [self.collectTableView setEditing:NO];//设置NO，因为实现了canEditRowAtIndexPath代理 防止返回crash
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.pullRefreshView = [[PullToRefreshView alloc] initWithScrollView:self.applyTableView];
    self.pullRefreshView.delegate = self;
    [self.applyTableView addSubview:self.pullRefreshView];
    
    self.pullRefreshView2 = [[PullToRefreshView alloc] initWithScrollView:self.collectTableView];
    self.pullRefreshView2.delegate = self;
    [self.collectTableView addSubview:self.pullRefreshView2];
    
    [self feedsTypeSwitch:ACTIVITY_TYPE_APPLY needRefreshFeeds:YES];
    
    __weak MineActivityListViewController *weakSelf = self;
    [self.applyTableView addInfiniteScrollingWithActionHandler:^{
        if (!weakSelf) {
            return;
        }
        if (!weakSelf.applyCanLoadMore) {
            [weakSelf.applyTableView.infiniteScrollingView stopAnimating];
            weakSelf.applyTableView.showsInfiniteScrolling = NO;
            return ;
        }
        
        int tag = [[XEEngine shareInstance] getConnectTag];
        [[XEEngine shareInstance] getMyApplyActivityListWithUid:[XEEngine shareInstance].uid page:(int)weakSelf.applyNextCursor tag:tag];
        [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
            if (!weakSelf) {
                return;
            }
            
            [weakSelf.applyTableView.infiniteScrollingView stopAnimating];
            NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
            if (!jsonRet || errorMsg) {
                if (!errorMsg.length) {
                    errorMsg = @"请求失败";
                }
                [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
                return;
            }
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"activity"];
            for (NSDictionary *dic in object) {
                XEActivityInfo *activityInfo = [[XEActivityInfo alloc] init];
                [activityInfo setActivityInfoByJsonDic:dic];
                [weakSelf.applyActivityList addObject:activityInfo];
            }
            weakSelf.applyCanLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
            if (!weakSelf.applyCanLoadMore) {
                weakSelf.applyTableView.showsInfiniteScrolling = NO;
            }else{
                weakSelf.applyTableView.showsInfiniteScrolling = YES;
                weakSelf.applyNextCursor ++;
            }
            [weakSelf.applyTableView reloadData];
            
        } tag:tag];
    }];
    
    [self.collectTableView addInfiniteScrollingWithActionHandler:^{
        if (!weakSelf) {
            return;
        }
        if (!weakSelf.collectCanLoadMore) {
            [weakSelf.collectTableView.infiniteScrollingView stopAnimating];
            weakSelf.collectTableView.showsInfiniteScrolling = NO;
            return ;
        }
        
        int tag = [[XEEngine shareInstance] getConnectTag];
        [[XEEngine shareInstance] getMyCollectActivityListWithUid:[XEEngine shareInstance].uid page:(int)weakSelf.collectNextCursor tag:tag];
        [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
            if (!weakSelf) {
                return;
            }
            
            [weakSelf.collectTableView.infiniteScrollingView stopAnimating];
            NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
            if (!jsonRet || errorMsg) {
                if (!errorMsg.length) {
                    errorMsg = @"请求失败";
                }
                [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
                return;
            }
            
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"activity"];
            for (NSDictionary *dic in object) {
                XEActivityInfo *activityInfo = [[XEActivityInfo alloc] init];
                [activityInfo setActivityInfoByJsonDic:dic];
                [weakSelf.collectActivityList addObject:activityInfo];
            }
            
            weakSelf.collectCanLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
            if (!weakSelf.collectCanLoadMore) {
                weakSelf.collectTableView.showsInfiniteScrolling = NO;
            }else{
                weakSelf.collectTableView.showsInfiniteScrolling = YES;
                weakSelf.collectNextCursor ++;
            }
            
            [weakSelf.collectTableView reloadData];
            
        } tag:tag];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    [self setSegmentedControlWithSelector:@selector(segmentedControlAction:) items:@[@"我报名的",@"我收藏的"]];
}

-(void)feedsTypeSwitch:(int)tag needRefreshFeeds:(BOOL)needRefresh
{
    if (tag == ACTIVITY_TYPE_APPLY) {
        //减速率
        self.collectTableView.decelerationRate = 0.0f;
        self.applyTableView.decelerationRate = 1.0f;
        self.collectTableView.hidden = YES;
        self.applyTableView.hidden = NO;
        
        if (!_applyActivityList) {
            [self getCacheApplyActivity];
            [self refreshApplyActivityList];
            return;
        }
        if (needRefresh) {
            [self refreshApplyActivityList];
        }
    }else if (tag == ACTIVITY_TYPE_COLLECT){
        
        self.collectTableView.decelerationRate = 1.0f;
        self.applyTableView.decelerationRate = 0.0f;
        self.applyTableView.hidden = YES;
        self.collectTableView.hidden = NO;
        if (!_collectActivityList) {
            [self getCacheCollectActivity];
            [self refreshCollectActivityList];
            return;
        }
        if (needRefresh) {
            [self refreshCollectActivityList];
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

#pragma mark - 我报名的
- (void)getCacheApplyActivity{
    __weak MineActivityListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getMyApplyActivityListWithUid:[XEEngine shareInstance].uid page:1 tag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            weakSelf.applyActivityList = [[NSMutableArray alloc] init];
            
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"activity"];
            for (NSDictionary *dic in object) {
                XEActivityInfo *activityInfo = [[XEActivityInfo alloc] init];
                [activityInfo setActivityInfoByJsonDic:dic];
                [weakSelf.applyActivityList addObject:activityInfo];
            }
            [weakSelf.applyTableView reloadData];
        }
    }];
}
- (void)refreshApplyActivityList{
    
    _applyNextCursor = 1;
    __weak MineActivityListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getMyApplyActivityListWithUid:[XEEngine shareInstance].uid page:(int)_applyNextCursor tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        [self.pullRefreshView finishedLoading];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        weakSelf.applyActivityList = [[NSMutableArray alloc] init];
        
        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"activity"];
        for (NSDictionary *dic in object) {
            XEActivityInfo *activityInfo = [[XEActivityInfo alloc] init];
            [activityInfo setActivityInfoByJsonDic:dic];
            [weakSelf.applyActivityList addObject:activityInfo];
        }
        
        weakSelf.applyCanLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
        if (!weakSelf.applyCanLoadMore) {
            weakSelf.applyTableView.showsInfiniteScrolling = NO;
        }else{
            weakSelf.applyTableView.showsInfiniteScrolling = YES;
            weakSelf.applyNextCursor ++;
        }
        
        [weakSelf.applyTableView reloadData];
        
    }tag:tag];
}

#pragma mark - 我收藏的
- (void)getCacheCollectActivity{
    __weak MineActivityListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getMyCollectActivityListWithUid:[XEEngine shareInstance].uid page:1 tag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            weakSelf.collectActivityList = [[NSMutableArray alloc] init];
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"activity"];
            for (NSDictionary *dic in object) {
                XEActivityInfo *activityInfo = [[XEActivityInfo alloc] init];
                [activityInfo setActivityInfoByJsonDic:dic];
                [weakSelf.collectActivityList addObject:activityInfo];
            }
            [weakSelf.collectTableView reloadData];
        }
    }];
}
- (void)refreshCollectActivityList{
    
    _collectNextCursor = 1;
    __weak MineActivityListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getMyCollectActivityListWithUid:[XEEngine shareInstance].uid page:(int)_collectNextCursor tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        [self.pullRefreshView2 finishedLoading];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        
        weakSelf.collectActivityList = [[NSMutableArray alloc] init];
        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"activity"];
        for (NSDictionary *dic in object) {
            XEActivityInfo *activityInfo = [[XEActivityInfo alloc] init];
            [activityInfo setActivityInfoByJsonDic:dic];
            [weakSelf.collectActivityList addObject:activityInfo];
        }
        
        weakSelf.collectCanLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
        if (!weakSelf.collectCanLoadMore) {
            weakSelf.collectTableView.showsInfiniteScrolling = NO;
        }else{
            weakSelf.collectTableView.showsInfiniteScrolling = YES;
            weakSelf.collectNextCursor ++;
        }
        
        [weakSelf.collectTableView reloadData];
        
    }tag:tag];
}

#pragma mark - custom
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

-(void)unCollectActivityWith:(XEActivityInfo*)activityInfo{
    if ([[XEEngine shareInstance] needUserLogin:nil]) {
        return;
    }
    __weak MineActivityListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] unCollectActivityWithActivityId:activityInfo.aId uid:[XEEngine shareInstance].uid type:activityInfo.aType tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        NSInteger index = [weakSelf.collectActivityList indexOfObject:activityInfo];
        if (index == NSNotFound || index < 0 || index >= weakSelf.collectActivityList.count) {
            return;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [weakSelf.collectActivityList removeObjectAtIndex:indexPath.row];
        [weakSelf.collectTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }tag:tag];
}

#pragma mark PullToRefreshViewDelegate
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    if (view == self.pullRefreshView) {
        [self refreshApplyActivityList];
    }else if (view == self.pullRefreshView2){
        [self refreshCollectActivityList];
    }
}
- (NSDate *)pullToRefreshViewLastUpdated:(PullToRefreshView *)view {
    return [NSDate date];
}

#pragma mark - TableView Delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.collectTableView) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (tableView == self.collectTableView) {
            XEActivityInfo *activityInfo = _collectActivityList[indexPath.row];
            [self unCollectActivityWith:activityInfo];
            
        }
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"取消收藏";
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.collectTableView) {
        return _collectActivityList.count;
    }
    return _applyActivityList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ActivityApplyViewCell";
    ActivityApplyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    XEActivityInfo *activityInfo;
    if (tableView == self.collectTableView) {
        activityInfo = _collectActivityList[indexPath.row];
    }else{
        activityInfo = _applyActivityList[indexPath.row];
    }
    cell.activityInfo = activityInfo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    XEActivityInfo *activityInfo;
    if (tableView == self.collectTableView) {
        activityInfo = _collectActivityList[indexPath.row];
    }else{
        activityInfo = _applyActivityList[indexPath.row];
    }
    ActivityDetailsViewController *vc = [[ActivityDetailsViewController alloc] init];
    vc.activityInfo = activityInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
