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
//#import "XECateTopicViewCell.h"
#import "XETopicViewCell.h"
#import "XEQuestionViewCell.h"
#import "XEProgressHUD.h"
#import "ODRefreshControl.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "TopicListViewController.h"
#import "TopicDetailsViewController.h"
#import "XEPublishMenu.h"
#import "XEPublicViewController.h"
#import "ExpertListViewController.h"
#import "QuestionDetailsViewController.h"

#define TOPIC_TYPE_NOURISH   101
#define TOPIC_TYPE_NUTRI     102
#define TOPIC_TYPE_KINDER    103
#define TOPIC_TYPE_MIND      104

#define INFO_TYPE_TOPIC      105
#define INFO_TYPE_QUESTION   106

#define XEDisplayMotionHeight 160

@interface ExpertChatViewController ()<UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate>{
    int _topicType;
    XEPublishMenu *_menuView;
}

@property (assign, nonatomic) int  tNextCursor;
@property (assign, nonatomic) int  qNextCursor;
@property (assign, nonatomic) BOOL topicLoadMore;
@property (assign, nonatomic) BOOL questionLoadMore;
//@property (assign, nonatomic) BOOL bClick;
@property (assign, nonatomic) BOOL bQuestion;

@property (nonatomic, strong) NSMutableArray *topicArray;
@property (nonatomic, strong) NSMutableArray *questionArray;

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIView *headView2;

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIView *footerView2;

@property (strong, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UITableView *topicTableView;
@property (weak, nonatomic) IBOutlet UITableView *questionTableView;
@property (strong, nonatomic) IBOutlet UIButton *topicBtn;
@property (strong, nonatomic) IBOutlet UIButton *questionBtn;
@property (weak, nonatomic) IBOutlet UILabel *loadmoreLabel;

@property (strong, nonatomic) IBOutlet UIView *sectionView;
@property (strong, nonatomic) IBOutlet UIView *sectionView2;

- (IBAction)selectAction:(id)sender;

- (IBAction)topicAction:(id)sender;

- (IBAction)loadMoreAction:(id)sender;

@end

@implementation ExpertChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"专家聊"];
    
    UIButton *topicBtn2 = (UIButton *)[self.sectionView2 viewWithTag:INFO_TYPE_TOPIC];
    [topicBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [topicBtn2 setBackgroundImage:[[UIImage imageNamed:@"public_type_open_icon"] stretchableImageWithLeftCapWidth:18 topCapHeight:8] forState:UIControlStateNormal];
    
    self.pullRefreshView = [[PullToRefreshView alloc] initWithScrollView:self.topicTableView];
    self.pullRefreshView.delegate = self;
    [self.topicTableView addSubview:self.pullRefreshView];
    self.topicTableView.tableHeaderView = self.headView;
    self.topicTableView.tableFooterView = self.footerView;
    
    self.pullRefreshView2 = [[PullToRefreshView alloc] initWithScrollView:self.questionTableView];
    self.pullRefreshView2.delegate = self;
    [self.questionTableView addSubview:self.pullRefreshView2];
    self.questionTableView.tableHeaderView = self.headView2;
    self.questionTableView.tableFooterView = self.footerView2;
    
//    UIPanGestureRecognizer *panRecognizer1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom1:)];
//    [panRecognizer1 setMaximumNumberOfTouches:1];
//    panRecognizer1.delegate = self;
//    [_topicTableView addGestureRecognizer:panRecognizer1];
//    UIPanGestureRecognizer *panRecognizer2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom2:)];
//    [panRecognizer2 setMaximumNumberOfTouches:1];
//    panRecognizer2.delegate = self;
//    [_questionTableView addGestureRecognizer:panRecognizer2];
    [self getCacheTopicInfo];
    [self feedsTypeSwitch:INFO_TYPE_TOPIC needRefreshFeeds:YES];
//    上拉先拿掉
//    __weak ExpertChatViewController *weakSelf = self;
//    [self.topicTableView addInfiniteScrollingWithActionHandler:^{
//        if (!weakSelf) {
//            return;
//        }
//        if (!weakSelf.topicLoadMore) {
//            [weakSelf.topicTableView.infiniteScrollingView stopAnimating];
//            weakSelf.topicTableView.showsInfiniteScrolling = NO;
//            return ;
//        }
//        
//        int tag = [[XEEngine shareInstance] getConnectTag];
//        [[XEEngine shareInstance] getHotTopicWithWithPagenum:weakSelf.tNextCursor tag:tag];
//        [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//            if (!weakSelf) {
//                return;
//            }
//            [weakSelf.topicTableView.infiniteScrollingView stopAnimating];
//            NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
//            if (!jsonRet || errorMsg) {
//                if (!errorMsg.length) {
//                    errorMsg = @"请求失败";
//                }
//                [XEProgressHUD AlertError:errorMsg];
//                return;
//            }
//            
//            weakSelf.bClick = YES;
//            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"topics"];
//            for (NSDictionary *dic in object) {
//                XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
//                [topicInfo setTopicInfoByJsonDic:dic];
//                [weakSelf.topicArray addObject:topicInfo];
//            }
//            
//            weakSelf.topicLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
//            if (!weakSelf.topicLoadMore) {
//                weakSelf.topicTableView.showsInfiniteScrolling = NO;
//            }else{
//                weakSelf.topicTableView.showsInfiniteScrolling = YES;
//                weakSelf.tNextCursor ++;
//            }
//            [weakSelf.topicTableView reloadData];
//            
//        } tag:tag];
//    }];
//    [self.questionTableView addInfiniteScrollingWithActionHandler:^{
//        if (!weakSelf) {
//            return;
//        }
//        if (!weakSelf.questionLoadMore) {
//            [weakSelf.questionTableView.infiniteScrollingView stopAnimating];
//            weakSelf.questionTableView.showsInfiniteScrolling = NO;
//            return ;
//        }
//        
//        int tag = [[XEEngine shareInstance] getConnectTag];
//        [[XEEngine shareInstance] getQuestionListWithPagenum:weakSelf.qNextCursor tag:tag];
//        [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//            if (!weakSelf) {
//                return;
//            }
//            [weakSelf.questionTableView.infiniteScrollingView stopAnimating];
//            NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
//            if (!jsonRet || errorMsg) {
//                if (!errorMsg.length) {
//                    errorMsg = @"请求失败";
//                }
//                [XEProgressHUD AlertError:errorMsg];
//                return;
//            }
//
//            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"qas"];
//            for (NSDictionary *dic in object) {
//                XEQuestionInfo *questionInfo = [[XEQuestionInfo alloc] init];
//                [questionInfo setQuestionInfoByJsonDic:dic];
//                [weakSelf.questionArray addObject:questionInfo];
//            }
//            
//            weakSelf.questionLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
//            if (!weakSelf.questionLoadMore) {
//                weakSelf.questionTableView.showsInfiniteScrolling = NO;
//            }else{
//                weakSelf.questionTableView.showsInfiniteScrolling = YES;
//                weakSelf.qNextCursor ++;
//            }
//            [weakSelf.questionTableView reloadData];
//            
//        } tag:tag];
//    }];
}

- (void)initNormalTitleNavBarSubviews{
    if (![XEEngine shareInstance].bVisitor) {
        //[self setLeftButtonWithTitle:@"我的问答" selector:@selector(mineAction)];
        [self setLeft2ButtonWithImageName:@"expert_question_icon" selector:@selector(mineAction)];
    }
    [self setRightButtonWithImageName:@"expert_public_icon" selector:@selector(showAction)];
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
        self.topicTableView.hidden = NO;
        if (!_topicArray) {
            [self refreshTopicList:YES];
            return;
        }
        if (needRefresh) {
            [self refreshTopicList:YES];
        }
    }else if (tag == INFO_TYPE_QUESTION){
        self.questionTableView.decelerationRate = 1.0f;
        self.topicTableView.decelerationRate = 0.0f;
        self.topicTableView.hidden = YES;
        self.questionTableView.hidden = NO;
        if (!_questionArray) {
            [self refreshQuestionList:YES];
            return;
        }
        if (needRefresh) {
            [self refreshQuestionList:YES];
        }
    }
}

- (void)getCacheTopicInfo{
    __weak ExpertChatViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getHotTopicWithWithTag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            weakSelf.topicArray = [[NSMutableArray alloc] init];
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"topics"];
            for (NSDictionary *dic in object) {
                XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
                [topicInfo setTopicInfoByJsonDic:dic];
                [weakSelf.topicArray addObject:topicInfo];
            }
            [weakSelf.topicTableView reloadData];
        }
    }];
}

- (void)refreshTopicList:(BOOL)isAlert{
//    if (isAlert) {
//        [XEProgressHUD AlertLoading:@"努力加载中..."];
//    }
    //_tNextCursor = 1;
    __weak ExpertChatViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
//    [[XEEngine shareInstance] getHotTopicWithWithPagenum:_tNextCursor tag:tag];
    [[XEEngine shareInstance] getHotTopicWithWithTag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//        [XEProgressHUD AlertLoadDone];
        [self.pullRefreshView finishedLoading];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        weakSelf.topicArray = [[NSMutableArray alloc] init];
        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"topics"];
        for (NSDictionary *dic in object) {
            XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
            [topicInfo setTopicInfoByJsonDic:dic];
            [weakSelf.topicArray addObject:topicInfo];
        }
        
//        weakSelf.topicLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
//        if (!weakSelf.topicLoadMore || !weakSelf.bClick) {
//            weakSelf.topicTableView.showsInfiniteScrolling = NO;
//        }else{
//            weakSelf.topicTableView.showsInfiniteScrolling = YES;
//            weakSelf.tNextCursor ++;
//        }
//        int count = [[[jsonRet objectForKey:@"object"] objectForKey:@"count"] intValue];
//        if (count > 20 && !weakSelf.bClick) {
//        [weakSelf.footerView setHidden:NO];
//        weakSelf.loadmoreLabel.text = @"点击查看全部话题";
//        }
        [weakSelf.topicTableView reloadData];
    }tag:tag];
}

- (void)refreshQuestionList:(BOOL)isAlert{
//    if (isAlert) {
//        [XEProgressHUD AlertLoading:@"努力加载中..."];
//    }
    //_qNextCursor = 1;
    __weak ExpertChatViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    //[[XEEngine shareInstance] getQuestionListWithPagenum:_qNextCursor tag:tag];
    [[XEEngine shareInstance] getHotQuestionWithTag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//        [XEProgressHUD AlertLoadDone];
        [self.pullRefreshView2 finishedLoading];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        weakSelf.questionArray = [[NSMutableArray alloc] init];
        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"questions"];
        for (NSDictionary *dic in object) {
            XEQuestionInfo *questionInfo = [[XEQuestionInfo alloc] init];
            [questionInfo setQuestionInfoByJsonDic:dic];
            [weakSelf.questionArray addObject:questionInfo];
        }
        
//        weakSelf.questionLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
//        if (!weakSelf.questionLoadMore) {
//            weakSelf.questionTableView.showsInfiniteScrolling = NO;
//        }else{
//            weakSelf.questionTableView.showsInfiniteScrolling = YES;
//            weakSelf.qNextCursor ++;
//        }

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

#pragma mark - UIScrollViewDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"============%f",scrollView.contentOffset.y);
    CGFloat offset = scrollView.contentOffset.y;
    if (offset <= 100) {
        if (self.questionTableView.hidden) {
            self.questionTableView.contentOffset = CGPointMake(0, offset);
        }else{
            self.topicTableView.contentOffset = CGPointMake(0, offset);
        }
    }
}

//- (void)handlePanFrom1:(UIPanGestureRecognizer*)recognizer
//{
//    CGPoint translation = [recognizer translationInView:_topicTableView];
//    CGFloat offsetY = 0.0;
//    offsetY = -translation.y;
//    [self didChangeLayoutWithOffset:offsetY andTableView:_topicTableView];
//}
//
//- (void)handlePanFrom2:(UIPanGestureRecognizer*)recognizer
//{
//    CGPoint translation = [recognizer translationInView:_questionTableView];
//    CGFloat offsetY = 0.0;
//    offsetY = -translation.y;
//    [self didChangeLayoutWithOffset:offsetY andTableView:_questionTableView];
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return YES;
//}

//- (void)didChangeLayoutWithOffset:(CGFloat)offset andTableView:(UITableView *)tableview{
//    if (offset > 0) {
//        [UIView animateWithDuration:0.5 animations:^{
//            CGRect frame = self.containerView.frame;
//            frame.origin.y = 64 - XEDisplayMotionHeight;
//            self.containerView.frame = frame;
//            CGRect frame2;
//            if (tableview == self.topicTableView) {
//                frame2 = self.topicTableView.frame;
//            }else if (tableview == self.questionTableView) {
//                frame2 = self.questionTableView.frame;
//            }
//            frame2.origin.y = frame.origin.y + frame.size.height;
//            frame2.size.height = SCREEN_HEIGHT - 44 - frame2.origin.y;
//            self.topicTableView.frame = frame2;
//            self.questionTableView.frame = frame2;
//        }];
//    }else if (offset < -100) {
//        [UIView animateWithDuration:0.5 animations:^{
//            CGRect frame = self.containerView.frame;
//            frame.origin.y = 64;
//            self.containerView.frame = frame;
//            CGRect frame2;
//            if (tableview == self.topicTableView) {
//                frame2 = self.topicTableView.frame;
//            }else if (tableview == self.questionTableView) {
//                frame2 = self.questionTableView.frame;
//            }
//            frame2.origin.y = frame.origin.y + frame.size.height;
//            frame2.size.height = SCREEN_HEIGHT - 44 - frame2.origin.y;
//            self.topicTableView.frame = frame2;
//            self.questionTableView.frame = frame2;
//        }];
//    }
//}

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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.questionTableView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        CGRect frame = self.sectionView.frame;
        frame.size.width = SCREEN_WIDTH;
        self.sectionView.frame = frame;
        [view addSubview:self.sectionView];
        return view;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        CGRect frame = self.sectionView2.frame;
        frame.size.width = SCREEN_WIDTH;
        self.sectionView2.frame = frame;
        [view addSubview:self.sectionView2];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (tableView == self.questionTableView) {
//        XEQuestionInfo *questionInfo = _questionArray[indexPath.row];
//        return [XEQuestionViewCell heightForQuestionInfo:questionInfo];
//    }
//    XETopicInfo *topicInfo = _topicArray[indexPath.row];
//    return [XECateTopicViewCell heightForTopicInfo:topicInfo];
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.topicTableView) {
        static NSString *CellIdentifier = @"XETopicViewCell";
        XETopicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        XETopicInfo *topicInfo = _topicArray[indexPath.row];
//        cell.isExpertChat = YES;
        cell.topicInfo = topicInfo;
        return cell;
    }else{
        static NSString *CellIdentifier = @"XEQuestionViewCell";
        XEQuestionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        
        XEQuestionInfo *info = _questionArray[indexPath.row];
        cell.isExpertChat = YES;
        cell.questionInfo = info;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    if (tableView == self.questionTableView) {
        XEQuestionInfo *info = _questionArray[indexPath.row];
        QuestionDetailsViewController *vc = [[QuestionDetailsViewController alloc] init];
        vc.questionInfo = info;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (tableView == self.topicTableView){
        XETopicInfo *topicInfo = _topicArray[indexPath.row];
        TopicDetailsViewController *vc = [[TopicDetailsViewController alloc] init];
        vc.topicInfo = topicInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)selectAction:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == INFO_TYPE_TOPIC) {
        self.bQuestion = NO;
        [self.topicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.topicBtn setBackgroundImage:[[UIImage imageNamed:@"public_type_open_icon"] stretchableImageWithLeftCapWidth:18 topCapHeight:8] forState:UIControlStateNormal];
        [self.questionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.questionBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [self feedsTypeSwitch:INFO_TYPE_TOPIC needRefreshFeeds:NO];
    }else if(btn.tag == INFO_TYPE_QUESTION){
        self.bQuestion = YES;
        [self.questionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.questionBtn setBackgroundImage:[[UIImage imageNamed:@"public_type_open_icon"] stretchableImageWithLeftCapWidth:18 topCapHeight:8] forState:UIControlStateNormal];
        [self.topicBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.topicBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [self feedsTypeSwitch:INFO_TYPE_QUESTION needRefreshFeeds:NO];
    }
}

- (IBAction)topicAction:(id)sender {
    UIButton *btn = sender;
    TopicListViewController *tlVc = [[TopicListViewController alloc] init];
    tlVc.topicType = (int)btn.tag - 100;
    [self.navigationController pushViewController:tlVc animated:YES];
}

- (IBAction)loadMoreAction:(id)sender {
//    _bClick = YES;
//    __weak ExpertChatViewController *weakSelf = self;
//    int tag = [[XEEngine shareInstance] getConnectTag];
//    [[XEEngine shareInstance] getHotTopicWithWithPagenum:weakSelf.tNextCursor tag:tag];
//    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//        if (!weakSelf) {
//            return;
//        }
//        [weakSelf.topicTableView.infiniteScrollingView stopAnimating];
//        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
//        if (!jsonRet || errorMsg) {
//            if (!errorMsg.length) {
//                errorMsg = @"请求失败";
//            }
//            [XEProgressHUD AlertError:errorMsg];
//            return;
//        }
//        
//        weakSelf.bClick = YES;
//        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"topics"];
//        for (NSDictionary *dic in object) {
//            XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
//            [topicInfo setTopicInfoByJsonDic:dic];
//            [weakSelf.topicArray addObject:topicInfo];
//        }
//        
//        weakSelf.topicLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
//        if (!weakSelf.topicLoadMore) {
//            weakSelf.topicTableView.showsInfiniteScrolling = NO;
//        }else{
//            weakSelf.topicTableView.showsInfiniteScrolling = YES;
//            weakSelf.tNextCursor ++;
//        }
//        weakSelf.topicTableView.tableFooterView = nil;
//        [weakSelf.topicTableView reloadData];
//        
//    } tag:tag];
    TopicListViewController *tlVc = [[TopicListViewController alloc] init];
    tlVc.bQuestion = self.bQuestion;
    if (self.bQuestion) {
        tlVc.topicType = TopicType_NONE;
    }
    [self.navigationController pushViewController:tlVc animated:YES];
}

- (void)mineAction {
    TopicListViewController *tlVc = [[TopicListViewController alloc] init];
    tlVc.bQuestion = YES;
    [self.navigationController pushViewController:tlVc animated:YES];
}

- (void)showAction {
//    if ([[XEEngine shareInstance] needUserLogin:@"当前为游客状态，是否切换到登录状态？"]) {
//        return;
//    }
    _menuView = [[XEPublishMenu alloc] init];
    __weak ExpertChatViewController *weakSelf = self;
    [_menuView addMenuItemWithTitle:@"发话题" andIcon:[UIImage imageNamed:@"expert_public_topic_icon"] andSelectedBlock:^{
        XEPublicViewController *pVc = [[XEPublicViewController alloc] init];
        pVc.publicType = Public_Type_Topic;
        [weakSelf.navigationController pushViewController:pVc animated:YES];
    }];
    [_menuView addMenuItemWithTitle:@"问专家" andIcon:[UIImage imageNamed:@"expert_public_ask_icon"] andSelectedBlock:^{
        ExpertListViewController *elVc = [[ExpertListViewController alloc] init];
        elVc.isNeedSelect = YES;
        [weakSelf.navigationController pushViewController:elVc animated:YES];
    }];
    [_menuView show];
}

#pragma mark -XETabBarControllerSubVcProtocol
- (void)tabBarController:(XETabBarViewController *)tabBarController reSelectVc:(UIViewController *)viewController {
    if (viewController == self) {
        [self.topicTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        [self.questionTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}

- (void)dealloc{
    self.topicTableView.delegate = nil;
    self.topicTableView.dataSource = nil;
    //self.topicTableView.showsInfiniteScrolling = NO;
    self.questionTableView.delegate = nil;
    self.questionTableView.dataSource = nil;
    //self.questionTableView.showsInfiniteScrolling = NO;
}

@end
