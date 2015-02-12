//
//  MineTopicListViewController.m
//  Xiaoer
//
//  Created by KID on 15/2/3.
//
//

#import "MineTopicListViewController.h"
#import "XEEngine.h"
#import "XETopicInfo.h"
//#import "XETopicViewCell.h"
#import "XECateTopicViewCell.h"
#import "XEProgressHUD.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "TopicDetailsViewController.h"

#define TOPIC_TYPE_PUBLISH     0
#define TOPIC_TYPE_COLLECT     1

@interface MineTopicListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *publishTopicList;
@property (nonatomic, strong) IBOutlet UITableView *publishTableView;
@property (strong, nonatomic) NSMutableArray *collectTopicList;
@property (nonatomic, strong) IBOutlet UITableView *collectTableView;

@property (assign, nonatomic) NSInteger selectedSegmentIndex;
@property (assign, nonatomic) SInt64  publishNextCursor;
@property (assign, nonatomic) BOOL publishCanLoadMore;
@property (assign, nonatomic) SInt64  collectNextCursor;
@property (assign, nonatomic) BOOL collectCanLoadMore;

@end

@implementation MineTopicListViewController

-(void)dealloc{
    XELog(@"MineTopicListViewController dealloc !!!");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.publishTableView setEditing:NO];
    [self.collectTableView setEditing:NO];//设置NO，因为实现了canEditRowAtIndexPath代理 防止返回crash
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.pullRefreshView = [[PullToRefreshView alloc] initWithScrollView:self.publishTableView];
    self.pullRefreshView.delegate = self;
    [self.publishTableView addSubview:self.pullRefreshView];
    
    self.pullRefreshView2 = [[PullToRefreshView alloc] initWithScrollView:self.collectTableView];
    self.pullRefreshView2.delegate = self;
    [self.collectTableView addSubview:self.pullRefreshView2];
    
    [self feedsTypeSwitch:TOPIC_TYPE_PUBLISH needRefreshFeeds:YES];
    
    __weak MineTopicListViewController *weakSelf = self;
    [self.publishTableView addInfiniteScrollingWithActionHandler:^{
        if (!weakSelf) {
            return;
        }
        if (!weakSelf.publishCanLoadMore) {
            [weakSelf.publishTableView.infiniteScrollingView stopAnimating];
            weakSelf.publishTableView.showsInfiniteScrolling = NO;
            return ;
        }
        
        int tag = [[XEEngine shareInstance] getConnectTag];
        [[XEEngine shareInstance] getMyPublishTopicListWithUid:[XEEngine shareInstance].uid page:(int)weakSelf.publishNextCursor tag:tag];
        [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
            if (!weakSelf) {
                return;
            }
            
            [weakSelf.publishTableView.infiniteScrollingView stopAnimating];
            NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
            if (!jsonRet || errorMsg) {
                if (!errorMsg.length) {
                    errorMsg = @"请求失败";
                }
                [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
                return;
            }
            NSArray *object = [[jsonRet objectForKey:@"object"] objectForKey:@"pubs"];
            for (NSDictionary *dic in object) {
                XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
                [topicInfo setTopicInfoByJsonDic:dic];
                
                [weakSelf.publishTopicList addObject:topicInfo];
            }
            weakSelf.publishCanLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
            if (!weakSelf.publishCanLoadMore) {
                weakSelf.publishTableView.showsInfiniteScrolling = NO;
            }else{
                weakSelf.publishTableView.showsInfiniteScrolling = YES;
                weakSelf.publishNextCursor ++;
            }
            [weakSelf.publishTableView reloadData];
            
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
        [[XEEngine shareInstance] getMyCollectTopicListWithUid:[XEEngine shareInstance].uid page:(int)weakSelf.collectNextCursor tag:tag];
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
            
            NSArray *object = [[jsonRet objectForKey:@"object"] objectForKey:@"favs"];
            for (NSDictionary *dic in object) {
                XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
                [topicInfo setTopicInfoByJsonDic:dic];
                [weakSelf.publishTopicList addObject:topicInfo];
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
    [self setSegmentedControlWithSelector:@selector(segmentedControlAction:) items:@[@"我发布的",@"我收藏的"]];
}

-(void)feedsTypeSwitch:(int)tag needRefreshFeeds:(BOOL)needRefresh
{
    if (tag == TOPIC_TYPE_PUBLISH) {
        //减速率
        self.collectTableView.decelerationRate = 0.0f;
        self.publishTableView.decelerationRate = 1.0f;
        self.collectTableView.hidden = YES;
        self.publishTableView.hidden = NO;
        
        if (!_publishTopicList) {
            [self getCachePublishTopic];
            [self refreshPublishTopicList];
            return;
        }
        if (needRefresh) {
            [self refreshPublishTopicList];
        }
    }else if (tag == TOPIC_TYPE_COLLECT){
        
        self.collectTableView.decelerationRate = 1.0f;
        self.publishTableView.decelerationRate = 0.0f;
        self.publishTableView.hidden = YES;
        self.collectTableView.hidden = NO;
        if (!_collectTopicList) {
            [self getCacheCollectTopic];
            [self refreshCollectTopicList];
            return;
        }
        if (needRefresh) {
            [self refreshCollectTopicList];
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

#pragma mark - 我发布的
- (void)getCachePublishTopic{
    __weak MineTopicListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getMyPublishTopicListWithUid:[XEEngine shareInstance].uid page:1 tag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            weakSelf.publishTopicList = [[NSMutableArray alloc] init];
            
            NSArray *object = [[jsonRet objectForKey:@"object"] objectForKey:@"pubs"];
            for (NSDictionary *dic in object) {
                XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
                [topicInfo setTopicInfoByJsonDic:dic];
                
                [weakSelf.publishTopicList addObject:topicInfo];
            }
            [weakSelf.publishTableView reloadData];
        }
    }];
}
- (void)refreshPublishTopicList{
    
    _publishNextCursor = 1;
    __weak MineTopicListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getMyPublishTopicListWithUid:[XEEngine shareInstance].uid page:(int)weakSelf.publishNextCursor tag:tag];
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
        weakSelf.publishTopicList = [[NSMutableArray alloc] init];
        
        NSArray *object = [[jsonRet objectForKey:@"object"] objectForKey:@"pubs"];
        for (NSDictionary *dic in object) {
            XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
            [topicInfo setTopicInfoByJsonDic:dic];
            
            [weakSelf.publishTopicList addObject:topicInfo];
        }
        weakSelf.publishCanLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
        if (!weakSelf.publishCanLoadMore) {
            weakSelf.publishTableView.showsInfiniteScrolling = NO;
        }else{
            weakSelf.publishTableView.showsInfiniteScrolling = YES;
            weakSelf.publishNextCursor ++;
        }
        [weakSelf.publishTableView reloadData];
        
    }tag:tag];
}

#pragma mark - 我收藏的
- (void)getCacheCollectTopic{
    __weak MineTopicListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getMyCollectTopicListWithUid:[XEEngine shareInstance].uid page:1 tag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            weakSelf.collectTopicList = [[NSMutableArray alloc] init];
            NSArray *object = [[jsonRet objectForKey:@"object"] objectForKey:@"favs"];
            for (NSDictionary *dic in object) {
                XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
                [topicInfo setTopicInfoByJsonDic:dic];
                [weakSelf.publishTopicList addObject:topicInfo];
            }
            [weakSelf.collectTableView reloadData];
        }
    }];
}
- (void)refreshCollectTopicList{
    
    _collectNextCursor = 1;
    __weak MineTopicListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getMyCollectTopicListWithUid:[XEEngine shareInstance].uid page:(int)_collectNextCursor tag:tag];
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
        
        weakSelf.collectTopicList = [[NSMutableArray alloc] init];
        NSArray *object = [[jsonRet objectForKey:@"object"] objectForKey:@"favs"];
        for (NSDictionary *dic in object) {
            XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
            [topicInfo setTopicInfoByJsonDic:dic];
            [weakSelf.collectTopicList addObject:topicInfo];
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

-(void)unCollectTopicWith:(XETopicInfo*)topicInfo{
    if ([[XEEngine shareInstance] needUserLogin:nil]) {
        return;
    }
    __weak MineTopicListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] unCollectTopicWithTopicId:topicInfo.tId uid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        NSInteger index = [weakSelf.collectTopicList indexOfObject:topicInfo];
        if (index == NSNotFound || index < 0 || index >= weakSelf.collectTopicList.count) {
            return;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [weakSelf.collectTopicList removeObjectAtIndex:indexPath.row];
        [weakSelf.collectTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }tag:tag];
}

#pragma mark PullToRefreshViewDelegate
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    if (view == self.pullRefreshView) {
        [self refreshPublishTopicList];
    }else if (view == self.pullRefreshView2){
        [self refreshCollectTopicList];
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
            XETopicInfo *topicInfo = self.collectTopicList[indexPath.row];
            [self unCollectTopicWith:topicInfo];
        }
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"取消收藏";
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.collectTableView) {
        return self.collectTopicList.count;
    }
    return self.publishTopicList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.collectTableView) {
        XETopicInfo *topicInfo = self.collectTopicList[indexPath.row];
        return [XECateTopicViewCell heightForTopicInfo:topicInfo];
    }
    XETopicInfo *topicInfo = self.publishTopicList[indexPath.row];
    return [XECateTopicViewCell heightForTopicInfo:topicInfo];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.collectTableView) {
        static NSString *CellIdentifier = @"XECateTopicViewCell";
        XECateTopicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
            cell.backgroundColor = [UIColor clearColor];
        }
        XETopicInfo *topicInfo = self.collectTopicList[indexPath.row];
        cell.isExpertChat = YES;
        cell.topicInfo = topicInfo;
        return cell;
    }
    
    static NSString *CellIdentifier2 = @"XECateTopicViewCell";
    XECateTopicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier2 owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    XETopicInfo *topicInfo = self.publishTopicList[indexPath.row];
    cell.isExpertChat = YES;
    cell.topicInfo = topicInfo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
    XETopicInfo *topicInfo;
    if (tableView == self.collectTableView) {
        topicInfo = _collectTopicList[indexPath.row];
    }else{
        topicInfo = self.publishTopicList[indexPath.row];
    }
    TopicDetailsViewController *vc = [[TopicDetailsViewController alloc] init];
    vc.topicInfo = topicInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
