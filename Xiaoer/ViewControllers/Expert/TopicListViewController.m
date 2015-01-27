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
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "UIScrollView+SVInfiniteScrolling.h"

@interface TopicListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) int nextCursor;
@property (assign, nonatomic) BOOL loadMore;
@property (strong, nonatomic) NSMutableArray *topicArray;
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
                
                NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"topics"];
                for (NSDictionary *dic in object) {
                    XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
                    [topicInfo setTopicInfoByJsonDic:dic];
                    [weakSelf.topicArray addObject:topicInfo];
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
                    [weakSelf.topicArray addObject:topicInfo];
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
        weakSelf.topicArray = [[NSMutableArray alloc] init];
        //先放下
        
        NSLog(@"asdasdsa==========%@",[jsonRet objectForKey:@"object"]);
        if ([jsonRet stringObjectForKey:@"object"].length < 10) {
            return;
        }
        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"topics"];
        
        for (NSDictionary *dic in object) {
            XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
            [topicInfo setTopicInfoByJsonDic:dic];
            [weakSelf.topicArray addObject:topicInfo];
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
        weakSelf.topicArray = [[NSMutableArray alloc] init];
        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"topics"];
        for (NSDictionary *dic in object) {
            XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
            [topicInfo setTopicInfoByJsonDic:dic];
            [weakSelf.topicArray addObject:topicInfo];
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
    return _topicArray.count;
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
    }
    
    XEQuestionInfo *info = _topicArray[indexPath.row];
    cell.questionInfo = info;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];

    XETopicInfo *topicInfo = _topicArray[indexPath.row];
    //        ActivityDetailsViewController *vc = [[ActivityDetailsViewController alloc] init];
    //        vc.activityInfo = activityInfo;
    //        [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"===============%@",topicInfo.tId);
}

- (void)askAction{
    
}

- (void)dealloc{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tableView.showsInfiniteScrolling = NO;
}

@end
