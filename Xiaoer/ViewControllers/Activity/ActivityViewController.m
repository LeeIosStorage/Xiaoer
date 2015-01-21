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

#define ACTIVITY_TYPE_APPLY     0
#define ACTIVITY_TYPE_HISTORY   1

@interface ActivityViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    ODRefreshControl *_applyRefreshControl;
    ODRefreshControl *_historyRefreshControl;
    BOOL _isScrollViewDrag;
}
@property (strong, nonatomic) NSMutableArray *activityList;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *historyActivityList;
@property (nonatomic, strong) IBOutlet UITableView *historyTableView;

@property (assign, nonatomic) NSInteger selectedSegmentIndex;
@property (assign, nonatomic) SInt64  applyNextCursor;
@property (assign, nonatomic) SInt64  historyNextCursor;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = UIColorRGB(240, 240, 240);
    
    _applyRefreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [_applyRefreshControl addTarget:self action:@selector(applyRefreshControlBeginPull:) forControlEvents:UIControlEventValueChanged];
    _historyRefreshControl = [[ODRefreshControl alloc] initInScrollView:self.historyTableView];
    [_historyRefreshControl addTarget:self action:@selector(historyRefreshControlBeginPull:) forControlEvents:UIControlEventValueChanged];
    
    [self feedsTypeSwitch:ACTIVITY_TYPE_APPLY needRefreshFeeds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    [self setRightButtonWithTitle:@"我的收藏" selector:@selector(mineCollectAction:)];
    
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
    __weak ActivityViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getApplyActivityListWithPage:1 uid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [_applyRefreshControl endRefreshing:NO];
            [XEProgressHUD AlertError:errorMsg];
            return;
        }
        [_applyRefreshControl endRefreshing:YES];
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
        weakSelf.activityList = [[NSMutableArray alloc] init];
        
        NSArray *object = [[jsonRet objectForKey:@"object"] objectForKey:@"activity"];
        for (NSDictionary *dic in object) {
            XEActivityInfo *activityInfo = [[XEActivityInfo alloc] init];
            [activityInfo setActivityInfoByJsonDic:dic];
            [weakSelf.activityList addObject:activityInfo];
        }
        [weakSelf.tableView reloadData];
        
    }tag:tag];
}

- (void)refreshHistoryActivityList:(BOOL)isAlert{
    
    if (isAlert) {
        [XEProgressHUD AlertLoading:@"努力加载中..."];
    }
    __weak ActivityViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getHistoryActivityListWithPage:1 tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [_historyRefreshControl endRefreshing:NO];
            [XEProgressHUD AlertError:errorMsg];
            return;
        }
        [_historyRefreshControl endRefreshing:YES];
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
        
        weakSelf.historyActivityList = [[NSMutableArray alloc] init];
        NSArray *object = [[jsonRet objectForKey:@"object"] objectForKey:@"activity"];
        for (NSDictionary *dic in object) {
            XERecipesInfo *recipesInfo = [[XERecipesInfo alloc] init];
            [recipesInfo setRecipesInfoByDic:dic];
            [weakSelf.historyActivityList addObject:recipesInfo];
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

#pragma mark - ODRefreshControl
- (void)applyRefreshControlBeginPull:(ODRefreshControl *)refreshControl
{
    if (_isScrollViewDrag) {
        [self refreshActivityList:NO];
    }
}
- (void)historyRefreshControlBeginPull:(ODRefreshControl *)refreshControl
{
    if (_isScrollViewDrag) {
        [self refreshHistoryActivityList:NO];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isScrollViewDrag = YES;
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
        
    }else if (tableView == self.tableView){
        XEActivityInfo *activityInfo = _activityList[indexPath.row];
        ActivityDetailsViewController *vc = [[ActivityDetailsViewController alloc] init];
        vc.activityInfo = activityInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
