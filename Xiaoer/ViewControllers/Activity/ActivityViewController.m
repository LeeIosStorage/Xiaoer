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

#define ACTIVITY_TYPE_APPLY     0
#define ACTIVITY_TYPE_HISTORY   1

@interface ActivityViewController ()<UITableViewDataSource,UITableViewDelegate>

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
    
    [self refreshActivityList];
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
            [self refreshActivityList];
            return;
        }
        if (needRefresh) {
            [self refreshActivityList];
        }
    }else if (tag == ACTIVITY_TYPE_HISTORY){
        
        self.historyTableView.decelerationRate = 1.0f;
        self.tableView.decelerationRate = 0.0f;
        self.tableView.hidden = YES;
        self.historyTableView.hidden = NO;
        if (!_historyActivityList) {
            [self refreshHistoryActivityList];
            return;
        }
        if (needRefresh) {
            [self refreshHistoryActivityList];
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

- (void)refreshActivityList{
    
    [XEProgressHUD AlertLoading:@"努力加载中..."];
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
        [weakSelf.tableView reloadData];
        
    }tag:tag];
}

- (void)refreshHistoryActivityList{
    
    [XEProgressHUD AlertLoading:@"努力加载中..."];
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
        
        [weakSelf.historyTableView reloadData];
        
    }tag:tag];
}

#pragma mark - custom
-(void)mineCollectAction:(id)sender{
    
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
        return 100;
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
        [cell.infoImageView setImage:[UIImage imageNamed:@"tmp_avatar_icon"]];
        cell.titleLabel.text = recipesInfo.title;
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
        
    }
}

@end