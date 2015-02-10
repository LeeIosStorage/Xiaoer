//
//  MineMsgViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/20.
//
//

#import "MineMsgViewController.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "XELinkerHandler.h"
#import "XEQuestionInfo.h"
#import "QuestionDetailsViewController.h"
#import "URLHelper.h"
#import "XEMsgInfo.h"

#define ANNOUNCEMENT_TYPE     0
#define QUESTION_TYPE         1

@interface MineMsgViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *announcementList;
@property (nonatomic, strong) IBOutlet UITableView *announcementTableView;
@property (strong, nonatomic) NSMutableArray *questionList;
@property (nonatomic, strong) IBOutlet UITableView *questionTableView;

@property (assign, nonatomic) NSInteger selectedSegmentIndex;
@property (assign, nonatomic) SInt64  announcementNextCursor;
@property (assign, nonatomic) BOOL announcementCanLoadMore;
@property (assign, nonatomic) SInt64  questionNextCursor;
@property (assign, nonatomic) BOOL questionCanLoadMore;

@end

@implementation MineMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.pullRefreshView = [[PullToRefreshView alloc] initWithScrollView:self.announcementTableView];
    self.pullRefreshView.delegate = self;
    [self.announcementTableView addSubview:self.pullRefreshView];
    
    self.pullRefreshView2 = [[PullToRefreshView alloc] initWithScrollView:self.questionTableView];
    self.pullRefreshView2.delegate = self;
    [self.questionTableView addSubview:self.pullRefreshView2];
    
    [self feedsTypeSwitch:ANNOUNCEMENT_TYPE needRefreshFeeds:YES];
    
    __weak MineMsgViewController *weakSelf = self;
    [self.announcementTableView addInfiniteScrollingWithActionHandler:^{
        if (!weakSelf) {
            return;
        }
        if (!weakSelf.announcementCanLoadMore) {
            [weakSelf.announcementTableView.infiniteScrollingView stopAnimating];
            weakSelf.announcementTableView.showsInfiniteScrolling = NO;
            return ;
        }
        
        int tag = [[XEEngine shareInstance] getConnectTag];
        [[XEEngine shareInstance] getNoticeMessagesListWithUid:[XEEngine shareInstance].uid page:(int)weakSelf.announcementNextCursor tag:tag];
        [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
            if (!weakSelf) {
                return;
            }
            
            [weakSelf.announcementTableView.infiniteScrollingView stopAnimating];
            NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
            if (!jsonRet || errorMsg) {
                if (!errorMsg.length) {
                    errorMsg = @"请求失败";
                }
                [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
                return;
            }
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"notices"];
            for (NSDictionary *dic in object) {
                XEMsgInfo *msgInfo = [[XEMsgInfo alloc] init];
                [msgInfo setMsgInfoByJsonDic:dic];
                [weakSelf.announcementList addObject:msgInfo];
            }
            
            weakSelf.announcementCanLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
            if (!weakSelf.announcementCanLoadMore) {
                weakSelf.announcementTableView.showsInfiniteScrolling = NO;
            }else{
                weakSelf.announcementTableView.showsInfiniteScrolling = YES;
                weakSelf.announcementNextCursor ++;
            }
            
            [weakSelf.announcementTableView reloadData];
            
        } tag:tag];
    }];
    
    [self.questionTableView addInfiniteScrollingWithActionHandler:^{
        if (!weakSelf) {
            return;
        }
        if (!weakSelf.questionCanLoadMore) {
            [weakSelf.questionTableView.infiniteScrollingView stopAnimating];
            weakSelf.questionTableView.showsInfiniteScrolling = NO;
            return ;
        }
        
        int tag = [[XEEngine shareInstance] getConnectTag];
        [[XEEngine shareInstance] getQuestionMessagesListWithUid:[XEEngine shareInstance].uid page:(int)weakSelf.questionNextCursor tag:tag];
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
                [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
                return;
            }
            
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"answers"];
            for (NSDictionary *dic in object) {
                XEMsgInfo *msgInfo = [[XEMsgInfo alloc] init];
                [msgInfo setMsgInfoByJsonDic:dic];
                [weakSelf.questionList addObject:msgInfo];
            }
            
            weakSelf.questionCanLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
            if (!weakSelf.questionCanLoadMore) {
                weakSelf.questionTableView.showsInfiniteScrolling = NO;
            }else{
                weakSelf.questionTableView.showsInfiniteScrolling = YES;
                weakSelf.questionNextCursor ++;
            }
            
            [weakSelf.questionTableView reloadData];
            
        } tag:tag];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    [self setSegmentedControlWithSelector:@selector(segmentedControlAction:) items:@[@"公告",@"问答"]];
}

-(void)feedsTypeSwitch:(int)tag needRefreshFeeds:(BOOL)needRefresh
{
    if (tag == ANNOUNCEMENT_TYPE) {
        //减速率
        self.questionTableView.decelerationRate = 0.0f;
        self.announcementTableView.decelerationRate = 1.0f;
        self.questionTableView.hidden = YES;
        self.announcementTableView.hidden = NO;
        
        if (!_announcementList) {
            [self getCacheAnnouncement];
            [self refreshAnnouncementList];
            return;
        }
        if (needRefresh) {
            [self refreshAnnouncementList];
        }
    }else if (tag == QUESTION_TYPE){
        
        self.questionTableView.decelerationRate = 1.0f;
        self.announcementTableView.decelerationRate = 0.0f;
        self.announcementTableView.hidden = YES;
        self.questionTableView.hidden = NO;
        if (!_questionList) {
            [self getCacheQuestion];
            [self refreshQuestionList];
            return;
        }
        if (needRefresh) {
            [self refreshQuestionList];
        }
    }
}

#pragma mark - 公告
- (void)getCacheAnnouncement{
    __weak MineMsgViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getNoticeMessagesListWithUid:[XEEngine shareInstance].uid page:1 tag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            weakSelf.announcementList = [[NSMutableArray alloc] init];
            
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"notices"];
            for (NSDictionary *dic in object) {
                XEMsgInfo *msgInfo = [[XEMsgInfo alloc] init];
                [msgInfo setMsgInfoByJsonDic:dic];
                [weakSelf.announcementList addObject:msgInfo];
            }
            [weakSelf.announcementTableView reloadData];
        }
    }];
}
- (void)refreshAnnouncementList{
    
    _announcementNextCursor = 1;
    __weak MineMsgViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getNoticeMessagesListWithUid:[XEEngine shareInstance].uid page:(int)_announcementNextCursor tag:tag];
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
        weakSelf.announcementList = [[NSMutableArray alloc] init];
        
        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"notices"];
        for (NSDictionary *dic in object) {
            XEMsgInfo *msgInfo = [[XEMsgInfo alloc] init];
            [msgInfo setMsgInfoByJsonDic:dic];
            [weakSelf.announcementList addObject:msgInfo];
        }
        
        weakSelf.announcementCanLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
        if (!weakSelf.announcementCanLoadMore) {
            weakSelf.announcementTableView.showsInfiniteScrolling = NO;
        }else{
            weakSelf.announcementTableView.showsInfiniteScrolling = YES;
            weakSelf.announcementNextCursor ++;
        }
        
        [weakSelf.announcementTableView reloadData];
        
    }tag:tag];
}

#pragma mark - 问答
- (void)getCacheQuestion{
    __weak MineMsgViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getQuestionMessagesListWithUid:[XEEngine shareInstance].uid page:1 tag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            weakSelf.questionList = [[NSMutableArray alloc] init];
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"answers"];
            for (NSDictionary *dic in object) {
                XEMsgInfo *msgInfo = [[XEMsgInfo alloc] init];
                [msgInfo setMsgInfoByJsonDic:dic];
                [weakSelf.questionList addObject:msgInfo];
            }
            [weakSelf.questionTableView reloadData];
        }
    }];
}
- (void)refreshQuestionList{
    
    _questionNextCursor = 1;
    __weak MineMsgViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getQuestionMessagesListWithUid:[XEEngine shareInstance].uid page:(int)_questionNextCursor tag:tag];
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
        
        weakSelf.questionList = [[NSMutableArray alloc] init];
        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"answers"];
        for (NSDictionary *dic in object) {
            XEMsgInfo *msgInfo = [[XEMsgInfo alloc] init];
            [msgInfo setMsgInfoByJsonDic:dic];
            [weakSelf.questionList addObject:msgInfo];
        }
        
        weakSelf.questionCanLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
        if (!weakSelf.questionCanLoadMore) {
            weakSelf.questionTableView.showsInfiniteScrolling = NO;
        }else{
            weakSelf.questionTableView.showsInfiniteScrolling = YES;
            weakSelf.questionNextCursor ++;
        }
        
        [weakSelf.questionTableView reloadData];
        
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
            if ([[XEEngine shareInstance] needUserLogin:nil]) {
                return;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark PullToRefreshViewDelegate
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    if (view == self.pullRefreshView) {
        [self refreshAnnouncementList];
    }else if (view == self.pullRefreshView2){
        [self refreshQuestionList];
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
        return self.questionList.count;
    }
    return self.announcementList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}

static int topImage_tag = 201, titleLabel_tag = 202, timeLabel_tag = 203;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier2 = @"CellIdentifier2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-26, 0, 26, 26)];
        topImageView.image = [UIImage imageNamed:@"expert_top_icon"];
        topImageView.tag = topImage_tag;
        [cell addSubview:topImageView];
        topImageView.hidden = YES;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 6, self.view.bounds.size.width - 13 - 40, 44)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.numberOfLines = 2;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.tag = titleLabel_tag;
        [cell addSubview:titleLabel];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-130, 52, 120, 21)];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.numberOfLines = 1;
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = UIColorRGB(136, 136, 136);
        timeLabel.tag = timeLabel_tag;
        [cell addSubview:timeLabel];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 75, self.view.bounds.size.width, 1)];
        lineImageView.image = [UIImage imageNamed:@"s_n_set_line"];
        [cell addSubview:lineImageView];
        
    }
    UIImageView *topImageView = (UIImageView *)[cell viewWithTag:topImage_tag];
    topImageView.hidden = YES;
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:titleLabel_tag];
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:timeLabel_tag];
    
    if (tableView == self.questionTableView) {
        XEMsgInfo *msgInfo = [self.questionList objectAtIndex:indexPath.row];
        titleLabel.text = [NSString stringWithFormat:@"%@回答了你“%@”的问题",msgInfo.userName,msgInfo.title];
        timeLabel.text = [XEUIUtils dateDiscriptionFromNowBk:msgInfo.time];
    }else if (tableView == self.announcementTableView){
        XEMsgInfo *msgInfo = [self.announcementList objectAtIndex:indexPath.row];
        titleLabel.text = msgInfo.title;
        timeLabel.text = [XEUIUtils dateDiscriptionFromNowBk:msgInfo.time];
        BOOL isTop = msgInfo.isTop;
        if (isTop) {
            topImageView.hidden = NO;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
    if (tableView == self.questionTableView) {
        XEMsgInfo *msgInfo = [self.questionList objectAtIndex:indexPath.row];
        XEQuestionInfo *questionInfo = [[XEQuestionInfo alloc] init];
        questionInfo.sId = msgInfo.msgId;
        QuestionDetailsViewController *vc = [[QuestionDetailsViewController alloc] init];
        vc.questionInfo = questionInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        XEMsgInfo *msgInfo = [self.announcementList objectAtIndex:indexPath.row];
        
        id vc = [XELinkerHandler handleDealWithHref:msgInfo.detailsActionUrl From:self.navigationController];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
