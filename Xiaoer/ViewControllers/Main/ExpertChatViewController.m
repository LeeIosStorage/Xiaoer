//
//  ExpertChatViewController.m
//  Xiaoer
//
//  Created by KID on 14/12/30.
//
//

#import "ExpertChatViewController.h"
#import "XETabBarViewController.h"
#import "XEEngine.h"
#import "XELinkerHandler.h"
#import "XETopicViewCell.h"
#import "XEQuestionViewCell.h"
#import "XEProgressHUD.h"
#import "ODRefreshControl.h"
#import "UIScrollView+SVInfiniteScrolling.h"

#define INFO_TYPE_TOPIC      101
#define INFO_TYPE_QUESTION   102

@interface ExpertChatViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) int  tNextCursor;
@property (assign, nonatomic) int  qNextCursor;
@property (assign, nonatomic) BOOL topicLoadMore;
@property (assign, nonatomic) BOOL questionLoadMore;
@property (assign, nonatomic) NSInteger selectedTag;

@property (nonatomic, strong) NSMutableArray *topicArray;
@property (nonatomic, strong) NSMutableArray *questionArray;

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (strong, nonatomic) IBOutlet UITableView *topicTableView;
@property (strong, nonatomic) IBOutlet UITableView *questionTableView;
@property (strong, nonatomic) IBOutlet UIButton *topicBtn;
@property (strong, nonatomic) IBOutlet UIButton *questionBtn;

@property (strong, nonatomic) IBOutlet UIView *sectionView;

- (IBAction)selectAction:(id)sender;

@end

@implementation ExpertChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"专家聊"];
    
    self.pullRefreshView = [[PullToRefreshView alloc] initWithScrollView:self.topicTableView];
    self.pullRefreshView.delegate = self;
    [self.topicTableView addSubview:self.pullRefreshView];
    
    self.pullRefreshView2 = [[PullToRefreshView alloc] initWithScrollView:self.questionTableView];
    self.pullRefreshView2.delegate = self;
    [self.questionTableView addSubview:self.pullRefreshView2];
//    self.topicTableView.tableHeaderView = self.headView;
    self.topicTableView.tableFooterView = self.footerView;
    [self feedsTypeSwitch:INFO_TYPE_TOPIC needRefreshFeeds:YES];
    
    __weak ExpertChatViewController *weakSelf = self;
    [self.topicTableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.topicTableView.tableFooterView = nil;
        if (!weakSelf) {
            return;
        }
        if (!weakSelf.topicLoadMore) {
            [weakSelf.topicTableView.infiniteScrollingView stopAnimating];
            weakSelf.topicTableView.showsInfiniteScrolling = NO;
            return ;
        }
        
        int tag = [[XEEngine shareInstance] getConnectTag];
        [[XEEngine shareInstance] getHotTopicWithWithPagenum:weakSelf.tNextCursor tag:tag];
        [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
            if (!weakSelf) {
                return;
            }
            [weakSelf.topicTableView.infiniteScrollingView stopAnimating];
            NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
            if (!jsonRet || errorMsg) {
                if (!errorMsg.length) {
                    errorMsg = @"请求失败";
                }
                [XEProgressHUD AlertError:errorMsg];
                return;
            }
            [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
            
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"topics"];
            for (NSDictionary *dic in object) {
                XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
                [topicInfo setTopicInfoByJsonDic:dic];
                [weakSelf.topicArray addObject:topicInfo];
            }
            
            weakSelf.topicLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
            if (!weakSelf.topicLoadMore) {
                weakSelf.topicTableView.showsInfiniteScrolling = NO;
            }else{
                weakSelf.topicTableView.showsInfiniteScrolling = YES;
                weakSelf.tNextCursor ++;
            }
            [weakSelf.topicTableView reloadData];
            
        } tag:tag];
    }];
    [self.questionTableView addInfiniteScrollingWithActionHandler:^{
        if (!weakSelf) {
            return;
        }
        if (!weakSelf.questionLoadMore) {
            [weakSelf.questionTableView.infiniteScrollingView stopAnimating];
            weakSelf.questionTableView.showsInfiniteScrolling = NO;
            return ;
        }
        
        int tag = [[XEEngine shareInstance] getConnectTag];
        [[XEEngine shareInstance] getQuestionListWithPagenum:weakSelf.qNextCursor tag:tag];
        [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
            if (!weakSelf) {
                return;
            }
            [weakSelf.questionTableView.infiniteScrollingView stopAnimating];
            NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
            if (!jsonRet || errorMsg) {
                if (!errorMsg.length) {
                    errorMsg = @"请求失败";
                }
                [XEProgressHUD AlertError:errorMsg];
                return;
            }
            [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
            
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"qas"];
            for (NSDictionary *dic in object) {
                XEQuestionInfo *questionInfo = [[XEQuestionInfo alloc] init];
                [questionInfo setQuestionInfoByJsonDic:dic];
                [weakSelf.topicArray addObject:questionInfo];
            }
            
            weakSelf.questionLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
            if (!weakSelf.questionLoadMore) {
                weakSelf.questionTableView.showsInfiniteScrolling = NO;
            }else{
                weakSelf.questionTableView.showsInfiniteScrolling = YES;
                weakSelf.qNextCursor ++;
            }
            [weakSelf.questionTableView reloadData];
            
        } tag:tag];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UINavigationController *)navigationController{
    if ([super navigationController]) {
        return [super navigationController];
    }
    return self.tabController.navigationController;
}

-(void)feedsTypeSwitch:(int)tag needRefreshFeeds:(BOOL)needRefresh
{
    if (tag == INFO_TYPE_TOPIC) {
        //减速率
        self.questionTableView.decelerationRate = 0.0f;
        self.topicTableView.decelerationRate = 1.0f;
        self.questionTableView.hidden = YES;
//        self.questionTableView.tableHeaderView = nil;
        self.topicTableView.hidden = NO;
//        self.topicTableView.tableHeaderView = self.headView;
        
        if (!_topicArray) {
            [self refreshTopicList:YES];
            return;
        }
        if (needRefresh) {
            [self refreshTopicList:YES];
        }
//        [self.topicTableView reloadData];
    }else if (tag == INFO_TYPE_QUESTION){
        
        self.questionTableView.decelerationRate = 1.0f;
        self.topicTableView.decelerationRate = 0.0f;
        self.topicTableView.hidden = YES;
//        self.topicTableView.tableHeaderView = nil;
        self.questionTableView.hidden = NO;
//        self.questionTableView.tableHeaderView = self.headView;
        if (!_questionArray) {
            [self refreshQuestionList:YES];
            return;
        }
        if (needRefresh) {
            [self refreshQuestionList:YES];
        }
//        [self.questionTableView reloadData];
    }
}

- (void)refreshTopicList:(BOOL)isAlert{
    if (isAlert) {
        [XEProgressHUD AlertLoading:@"努力加载中..."];
    }
    _tNextCursor = 1;
    __weak ExpertChatViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getHotTopicWithWithPagenum:_tNextCursor tag:tag];
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
        weakSelf.topicArray = [[NSMutableArray alloc] init];
        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"topics"];
        for (NSDictionary *dic in object) {
            XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
            [topicInfo setTopicInfoByJsonDic:dic];
            [weakSelf.topicArray addObject:topicInfo];
        }
        
        weakSelf.topicLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
        if (!weakSelf.topicLoadMore) {
            weakSelf.topicTableView.showsInfiniteScrolling = NO;
        }else{
            weakSelf.topicTableView.showsInfiniteScrolling = YES;
            weakSelf.tNextCursor ++;
        }
        
        [weakSelf.topicTableView reloadData];
    }tag:tag];
}

- (void)refreshQuestionList:(BOOL)isAlert{
    if (isAlert) {
        [XEProgressHUD AlertLoading:@"努力加载中..."];
    }
    _qNextCursor = 1;
    __weak ExpertChatViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getQuestionListWithPagenum:_qNextCursor tag:tag];
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
        weakSelf.questionArray = [[NSMutableArray alloc] init];
        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"qas"];
        for (NSDictionary *dic in object) {
            XEQuestionInfo *questionInfo = [[XEQuestionInfo alloc] init];
            [questionInfo setQuestionInfoByJsonDic:dic];
            [weakSelf.questionArray addObject:questionInfo];
        }
        
        weakSelf.questionLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
        if (!weakSelf.questionLoadMore) {
            weakSelf.questionTableView.showsInfiniteScrolling = NO;
        }else{
            weakSelf.questionTableView.showsInfiniteScrolling = YES;
            weakSelf.qNextCursor ++;
        }
        
        [weakSelf.questionTableView reloadData];
        
    }tag:tag];
}

#pragma mark PullToRefreshViewDelegate
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    if (view == self.pullRefreshView) {
        [self refreshTopicList:NO];
    }else if (view == self.pullRefreshView2){
        [self refreshQuestionList:NO];
    }
}

- (NSDate *)pullToRefreshViewLastUpdated:(PullToRefreshView *)view {
    return [NSDate date];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.questionTableView) {
        return _questionArray.count;
    }
    return _topicArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    return 44;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
//    [view addSubview:self.sectionView];
//    return view;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.topicTableView) {
        static NSString *CellIdentifier = @"XETopicViewCell";
        XETopicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
            cell.backgroundColor = [UIColor clearColor];
        }
        XETopicInfo *topicInfo = _topicArray[indexPath.row];
        cell.topicInfo = topicInfo;
        cell.isExpertChat = YES;
        return cell;
    }
    
    static NSString *CellIdentifier = @"XEQuestionViewCell";
    XEQuestionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    XEQuestionInfo *info = _questionArray[indexPath.row];
    cell.questionInfo = info;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    if (tableView == self.questionTableView) {
        XEQuestionInfo *info = _questionArray[indexPath.row];
//        id vc = [XELinkerHandler handleDealWithHref:info.recipesActionUrl From:self.navigationController];
//        if (vc) {
//            [self.navigationController pushViewController:vc animated:YES];
//        }
        NSLog(@"===============%@",info.sId);
    }else if (tableView == self.topicTableView){
        XETopicInfo *topicInfo = _topicArray[indexPath.row];
//        ActivityDetailsViewController *vc = [[ActivityDetailsViewController alloc] init];
//        vc.activityInfo = activityInfo;
//        [self.navigationController pushViewController:vc animated:YES];
        NSLog(@"===============%@",topicInfo.tId);
    }
    
}

- (IBAction)selectAction:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == INFO_TYPE_TOPIC) {
        [self.topicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.topicBtn setBackgroundImage:[UIImage imageNamed:@"expert_selected_bg"] forState:UIControlStateNormal];
        [self.questionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.questionBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [self feedsTypeSwitch:INFO_TYPE_TOPIC needRefreshFeeds:NO];
    }else if(btn.tag == INFO_TYPE_QUESTION){
        [self.questionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.questionBtn setBackgroundImage:[UIImage imageNamed:@"expert_selected_bg"] forState:UIControlStateNormal];
        [self.topicBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.topicBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [self feedsTypeSwitch:INFO_TYPE_QUESTION needRefreshFeeds:NO];
    }
}

@end
