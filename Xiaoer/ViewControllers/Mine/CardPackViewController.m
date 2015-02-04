//
//  CardPackViewController.m
//  Xiaoer
//
//  Created by KID on 15/2/3.
//
//

#import "CardPackViewController.h"
#import "XEEngine.h"
#import "CardViewCell.h"
#import "XECardInfo.h"
#import "XEProgressHUD.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "CardDetailViewController.h"

@interface CardPackViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) int nextCursor;
@property (assign, nonatomic) BOOL loadMore;
@property (strong, nonatomic) NSMutableArray *dateArray;
@property (strong, nonatomic) IBOutlet UITableView *cardTableView;

@end

@implementation CardPackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.pullRefreshView = [[PullToRefreshView alloc] initWithScrollView:self.cardTableView];
    self.pullRefreshView.delegate = self;
    [self.cardTableView addSubview:self.pullRefreshView];
    
    //[self getCacheCardList];
    [self refreshCardList];
    
    __weak CardPackViewController *weakSelf = self;
    [self.cardTableView addInfiniteScrollingWithActionHandler:^{
        if (!weakSelf) {
            return;
        }
        if (!weakSelf.loadMore) {
            [weakSelf.cardTableView.infiniteScrollingView stopAnimating];
            weakSelf.cardTableView.showsInfiniteScrolling = NO;
            return ;
        }
        
        int tag = [[XEEngine shareInstance] getConnectTag];
        [[XEEngine shareInstance] getQuestionListWithUid:[XEEngine shareInstance].uid pagenum:weakSelf.nextCursor tag:tag];
        [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
            if (!weakSelf) {
                return;
            }
            [weakSelf.cardTableView.infiniteScrollingView stopAnimating];
            NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
            if (!jsonRet || errorMsg) {
                if (!errorMsg.length) {
                    errorMsg = @"请求失败";
                }
                [XEProgressHUD AlertError:errorMsg];
                return;
            }
            
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"cps"];
            for (NSDictionary *dic in object) {
                XECardInfo *cardInfo = [[XECardInfo alloc] init];
                [cardInfo setCardInfoByJsonDic:dic];
                [weakSelf.dateArray addObject:cardInfo];
            }
            
            weakSelf.loadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
            if (!weakSelf.loadMore) {
                weakSelf.cardTableView.showsInfiniteScrolling = NO;
            }else{
                weakSelf.cardTableView.showsInfiniteScrolling = YES;
                weakSelf.nextCursor ++;
            }
            [weakSelf.cardTableView reloadData];
            
        } tag:tag];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    [self setTitle:@"全部卡包"];
}

- (void)getCacheCardList{
    __weak CardPackViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getQuestionListWithUid:[XEEngine shareInstance].uid pagenum:1 tag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            weakSelf.dateArray = [[NSMutableArray alloc] init];
            //先放下
            if ([jsonRet stringObjectForKey:@"object"].length < 10) {
                return;
            }
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"cps"];
            for (NSDictionary *dic in object) {
                XECardInfo *cardInfo = [[XECardInfo alloc] init];
                [cardInfo setCardInfoByJsonDic:dic];
                [weakSelf.dateArray addObject:cardInfo];
            }
            [weakSelf.cardTableView reloadData];
        }
    }];
}

- (void)refreshCardList{
    _nextCursor = 1;
    __weak CardPackViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getCardListWithUid:[XEEngine shareInstance].uid pagenum:_nextCursor tag:tag];
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
        weakSelf.dateArray = [[NSMutableArray alloc] init];

        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"cps"];
        
        for (NSDictionary *dic in object) {
            XECardInfo *cardInfo = [[XECardInfo alloc] init];
            [cardInfo setCardInfoByJsonDic:dic];
            [weakSelf.dateArray addObject:cardInfo];
        }
        
        weakSelf.loadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
        if (!weakSelf.loadMore) {
            weakSelf.cardTableView.showsInfiniteScrolling = NO;
        }else{
            weakSelf.cardTableView.showsInfiniteScrolling = YES;
            weakSelf.nextCursor ++;
        }
        
        [weakSelf.cardTableView reloadData];
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

    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"CardViewCell";
    CardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    XECardInfo *info = _dateArray[indexPath.row];
    cell.cardInfo = info;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
    CardDetailViewController *cdVc = [[CardDetailViewController alloc] init];
    XECardInfo *info = _dateArray[indexPath.row];
    cdVc.cardInfo = info;
    [self.navigationController pushViewController:cdVc animated:YES];
}

#pragma mark PullToRefreshViewDelegate
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    if (view == self.pullRefreshView) {
        [self refreshCardList];
    }
}

- (NSDate *)pullToRefreshViewLastUpdated:(PullToRefreshView *)view {
    return [NSDate date];
}

@end
