//
//  TicketListViewController.m
//  Xiaoer
//
//  Created by KID on 15/3/17.
//
//

#import "TicketListViewController.h"
#import "TicketListViewCell.h"
#import "XEActivityInfo.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "ActivityDetailsViewController.h"
#import "XEAlertView.h"
#import "PerfectInfoViewController.h"
#import "ApplyActivityViewController.h"

@interface TicketListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *ticketList;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (assign, nonatomic) SInt64 nextCursor;
@property (assign, nonatomic) BOOL canLoadMore;

@end

@implementation TicketListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = UIColorRGB(240, 240, 240);
    
    self.pullRefreshView = [[PullToRefreshView alloc] initWithScrollView:self.tableView];
    self.pullRefreshView.delegate = self;
    [self.tableView addSubview:self.pullRefreshView];
    
    [self getCacheApplyTicketActivity];
    [self refreshTicketActivityList];
    
    __weak TicketListViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        if (!weakSelf) {
            return;
        }
        if (!weakSelf.canLoadMore) {
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            weakSelf.tableView.showsInfiniteScrolling = NO;
            return ;
        }
        
        int tag = [[XEEngine shareInstance] getConnectTag];
        [[XEEngine shareInstance] getApplyActivityListWithPage:(int)weakSelf.nextCursor uid:[XEEngine shareInstance].uid type:1 tag:tag];
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
                [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
                return;
            }
            
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"activity"];
            for (NSDictionary *dic in object) {
                XEActivityInfo *activityInfo = [[XEActivityInfo alloc] init];
                [activityInfo setActivityInfoByJsonDic:dic];
                [weakSelf.ticketList addObject:activityInfo];
            }
            weakSelf.canLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
            if (!weakSelf.canLoadMore) {
                weakSelf.tableView.showsInfiniteScrolling = NO;
            }else{
                weakSelf.tableView.showsInfiniteScrolling = YES;
                weakSelf.nextCursor ++;
            }
            [weakSelf.tableView reloadData];
            
        } tag:tag];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    
    [self setTitle:@"抢票"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 活动报名
- (void)getCacheApplyTicketActivity{
    __weak TicketListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getApplyActivityListWithPage:1 uid:[XEEngine shareInstance].uid type:1 tag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            weakSelf.ticketList = [[NSMutableArray alloc] init];
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"activity"];
            for (NSDictionary *dic in object) {
                XEActivityInfo *activityInfo = [[XEActivityInfo alloc] init];
                [activityInfo setActivityInfoByJsonDic:dic];
                [weakSelf.ticketList addObject:activityInfo];
            }
            [weakSelf.tableView reloadData];
        }
    }];
}
- (void)refreshTicketActivityList{
    
    _nextCursor = 1;
    __weak TicketListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getApplyActivityListWithPage:(int)_nextCursor uid:[XEEngine shareInstance].uid type:1 tag:tag];
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
        weakSelf.ticketList = [[NSMutableArray alloc] init];
        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"activity"];
        for (NSDictionary *dic in object) {
            XEActivityInfo *activityInfo = [[XEActivityInfo alloc] init];
            [activityInfo setActivityInfoByJsonDic:dic];
            [weakSelf.ticketList addObject:activityInfo];
        }
        
        weakSelf.canLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
        if (!weakSelf.canLoadMore) {
            weakSelf.tableView.showsInfiniteScrolling = NO;
        }else{
            weakSelf.tableView.showsInfiniteScrolling = YES;
            weakSelf.nextCursor ++;
        }
        
        [weakSelf.tableView reloadData];
        
    }tag:tag];
}

#pragma mark PullToRefreshViewDelegate
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    if (view == self.pullRefreshView) {
        [self refreshTicketActivityList];
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
    return _ticketList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TicketListViewCell";
    TicketListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [cell.rushButton addTarget:self action:@selector(handleClickAt:event:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    XEActivityInfo *activityInfo = _ticketList[indexPath.row];
    cell.activityInfo = activityInfo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    [self refreshTicketCount];
    XEActivityInfo *activityInfo = _ticketList[indexPath.row];
    activityInfo.aType = 1;
    ActivityDetailsViewController *vc = [[ActivityDetailsViewController alloc] init];
    vc.activityInfo = activityInfo;
    vc.isTicketActivity = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)handleClickAt:(id)sender event:(id)event{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil){
        XEActivityInfo *activityInfo = _ticketList[indexPath.row];
        if ([[XEEngine shareInstance] needUserLogin:nil]) {
            return;
        }
        if ([XEEngine shareInstance].userInfo.profileStatus == 0) {
            [self applyActivity:activityInfo];
        }else{
            XEAlertView *alertView = [[XEAlertView alloc] initWithTitle:nil message:@"您需要完善资料才能报名活动" cancelButtonTitle:@"取消" cancelBlock:^{
            } okButtonTitle:@"确定" okBlock:^{
                PerfectInfoViewController *piVc = [[PerfectInfoViewController alloc] init];
                piVc.userInfo = [XEEngine shareInstance].userInfo;
                piVc.isFromActivity = YES;
                piVc.activityInfo = activityInfo;
                piVc.finishedCallBack = ^(BOOL isFinish){
                    if (isFinish) {
                        [self.tableView reloadData];
                    }
                };
                [self.navigationController pushViewController:piVc animated:YES];
            }];
            [alertView show];
        }
    }
    
}

-(void)applyActivity:(XEActivityInfo *)activityInfo{
    
    __weak TicketListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] applyActivityWithActivityId:activityInfo.aId uid:[XEEngine shareInstance].uid type:1 tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"] At:weakSelf.view];
        activityInfo.status = 3;
        activityInfo.regnum ++;
        [weakSelf.tableView reloadData];
        
        if (activityInfo.aType == 0) {
            ApplyActivityViewController *applyVc = [[ApplyActivityViewController alloc] init];
            applyVc.infoId = [jsonRet stringObjectForKey:@"object"];
            [self.navigationController pushViewController:applyVc animated:YES];
        }
        
    }tag:tag];
}

//全局抢票数先简单计算一下
- (void)refreshTicketCount{
    NSString *key = [NSString stringWithFormat:@"%@_%@", mineTicketCountKey, [XEEngine shareInstance].uid];
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    if (count > 0) {
        count--;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:XE_TICKET_CHANGED_NOTIFICATION object:self];
}

@end
