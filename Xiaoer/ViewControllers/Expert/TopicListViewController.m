//
//  TopicListViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/27.
//
//

#import "TopicListViewController.h"
#import "XETopicViewCell.h"
#import "XEQuestionViewCell.h"
#import "XETopicInfo.h"
#import "XEQuestionInfo.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "TopicDetailsViewController.h"

@interface TopicListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) int nextCursor;
@property (assign, nonatomic) BOOL loadMore;
@property (strong, nonatomic) NSMutableArray *dateArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TopicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    __weak TopicListViewController *weakSelf = self;
    if (_bQuestion) {
        [self refreshQuestionList];
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            if (!weakSelf) {
                return;
            }
            if (!weakSelf.loadMore) {
                [weakSelf.tableView.infiniteScrollingView stopAnimating];
                weakSelf.tableView.showsInfiniteScrolling = NO;
                return ;
            }
            
            int tag = [[XEEngine shareInstance] getConnectTag];
            [[XEEngine shareInstance] getQuestionListWithUid:[XEEngine shareInstance].uid pagenum:weakSelf.nextCursor tag:tag];
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
                
                NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"questions"];
                for (NSDictionary *dic in object) {
                    XEQuestionInfo *questionInfo = [[XEQuestionInfo alloc] init];
                    [questionInfo setQuestionInfoByJsonDic:dic];
                    [weakSelf.dateArray addObject:questionInfo];
                }
                
                weakSelf.loadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
                if (!weakSelf.loadMore) {
                    weakSelf.tableView.showsInfiniteScrolling = NO;
                }else{
                    weakSelf.tableView.showsInfiniteScrolling = YES;
                    weakSelf.nextCursor ++;
                }
                [weakSelf.tableView reloadData];
                
            } tag:tag];
        }];
    }else {
        [self refreshTopicList];
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            
            if (!weakSelf) {
                return;
            }
            if (!weakSelf.loadMore) {
                [weakSelf.tableView.infiniteScrollingView stopAnimating];
                weakSelf.tableView.showsInfiniteScrolling = NO;
                return ;
            }
            
            int tag = [[XEEngine shareInstance] getConnectTag];
            [[XEEngine shareInstance] getHotTopicListWithCat:weakSelf.topicType pagenum:weakSelf.nextCursor tag:tag];
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
                
                NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"topics"];
                for (NSDictionary *dic in object) {
                    XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
                    [topicInfo setTopicInfoByJsonDic:dic];
                    [weakSelf.dateArray addObject:topicInfo];
                }
                
                weakSelf.loadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
                if (!weakSelf.loadMore) {
                    weakSelf.tableView.showsInfiniteScrolling = NO;
                }else{
                    weakSelf.tableView.showsInfiniteScrolling = YES;
                    weakSelf.nextCursor ++;
                }
                [weakSelf.tableView reloadData];
                
            } tag:tag];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    if (_bQuestion) {
        [self setTitle:@"我的问答"];
        [self setRightButtonWithImageName:@"common_collect_icon" selector:@selector(askAction)];
    }else {
        if (self.topicType == TopicType_Nutri) {
            [self setTitle:@"营养话题"];
        }else if (self.topicType == TopicType_Nourish) {
            [self setTitle:@"养育话题"];
        }else if (self.topicType == TopicType_Mind) {
            [self setTitle:@"心理话题"];
        }else if (self.topicType == TopicType_Kinder) {
            [self setTitle:@"入园话题"];
        }
    }
}

- (void)refreshQuestionList{
    _nextCursor = 1;
    __weak TopicListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getQuestionListWithUid:[XEEngine shareInstance].uid pagenum:_nextCursor tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        
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
        weakSelf.dateArray = [[NSMutableArray alloc] init];
        //先放下
        if ([jsonRet stringObjectForKey:@"object"].length < 10) {
            return;
        }
        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"questions"];
        
        for (NSDictionary *dic in object) {
            XEQuestionInfo *questionInfo = [[XEQuestionInfo alloc] init];
            [questionInfo setQuestionInfoByJsonDic:dic];
            [weakSelf.dateArray addObject:questionInfo];
        }
        
        weakSelf.loadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
        if (!weakSelf.loadMore) {
            weakSelf.tableView.showsInfiniteScrolling = NO;
        }else{
            weakSelf.tableView.showsInfiniteScrolling = YES;
            weakSelf.nextCursor ++;
        }
        
        [weakSelf.tableView reloadData];
    }tag:tag];
}

- (void)refreshTopicList{
    _nextCursor = 1;
    __weak TopicListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getHotTopicListWithCat:self.topicType pagenum:_nextCursor tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
  
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
        weakSelf.dateArray = [[NSMutableArray alloc] init];
        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"topics"];
        for (NSDictionary *dic in object) {
            XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
            [topicInfo setTopicInfoByJsonDic:dic];
            [weakSelf.dateArray addObject:topicInfo];
        }
        
        weakSelf.loadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
        if (!weakSelf.loadMore) {
            weakSelf.tableView.showsInfiniteScrolling = NO;
        }else{
            weakSelf.tableView.showsInfiniteScrolling = YES;
            weakSelf.nextCursor ++;
        }

        [weakSelf.tableView reloadData];
    }tag:tag];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dateArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.bQuestion) {
        XEQuestionInfo *questionInfo = _dateArray[indexPath.row];
        return [XEQuestionViewCell heightForQuestionInfo:questionInfo];
    }
    XETopicInfo *topicInfo = _dateArray[indexPath.row];
    return [XETopicViewCell heightForTopicInfo:topicInfo];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.bQuestion) {
        static NSString *CellIdentifier = @"XETopicViewCell";
        XETopicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
            cell.backgroundColor = [UIColor clearColor];
        }
        XETopicInfo *topicInfo = _dateArray[indexPath.row];
        cell.isExpertChat = YES;
        cell.topicInfo = topicInfo;
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"XEQuestionViewCell";
    XEQuestionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    XEQuestionInfo *info = _dateArray[indexPath.row];
    cell.questionInfo = info;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
    XETopicInfo *topicInfo = _dateArray[indexPath.row];
    TopicDetailsViewController *vc = [[TopicDetailsViewController alloc] init];
    vc.topicInfo = topicInfo;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)askAction{
    
}

- (void)dealloc{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tableView.showsInfiniteScrolling = NO;
}

@end
