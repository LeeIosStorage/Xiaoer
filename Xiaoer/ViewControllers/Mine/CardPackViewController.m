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
#import "XEAlertView.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "CardDetailViewController.h"
#import "PerfectInfoViewController.h"
#import "XELinkerHandler.h"
#import "CardOfEastWebViewController.h"
#import "CardOfEastVerifyController.h"

@interface CardPackViewController ()<UITableViewDelegate,UITableViewDataSource,XECardDelegate>

@property (assign, nonatomic) int nextCursor;
@property (assign, nonatomic) BOOL loadMore;
@property (strong, nonatomic) NSMutableArray *cardInfos;
@property (strong, nonatomic) IBOutlet UITableView *cardTableView;

@end

@implementation CardPackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.pullRefreshView = [[PullToRefreshView alloc] initWithScrollView:self.cardTableView];
    self.pullRefreshView.delegate = self;
    [self.cardTableView addSubview:self.pullRefreshView];
    
    [self getCacheCardList];
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
        [[XEEngine shareInstance] getCardListWithUid:[XEEngine shareInstance].uid pagenum:weakSelf.nextCursor tag:tag];
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
                [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
                return;
            }
            
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"cps"];
            for (NSDictionary *dic in object) {
                XECardInfo *cardInfo = [[XECardInfo alloc] init];
                [cardInfo setCardInfoByJsonDic:dic];
                [weakSelf.cardInfos addObject:cardInfo];
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
    [[XEEngine shareInstance] getCardListWithUid:[XEEngine shareInstance].uid pagenum:1 tag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            weakSelf.cardInfos = [[NSMutableArray alloc] init];
            //先放下
            if ([jsonRet stringObjectForKey:@"object"].length < 10) {
                return;
            }
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"cps"];
            for (NSDictionary *dic in object) {
                XECardInfo *cardInfo = [[XECardInfo alloc] init];
                [cardInfo setCardInfoByJsonDic:dic];
                [weakSelf.cardInfos addObject:cardInfo];
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
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        weakSelf.cardInfos = [[NSMutableArray alloc] init];

        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"cps"];
        
        for (NSDictionary *dic in object) {
            XECardInfo *cardInfo = [[XECardInfo alloc] init];
            [cardInfo setCardInfoByJsonDic:dic];
            [weakSelf.cardInfos addObject:cardInfo];
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

- (void)receiveCardWithInfo:(XECardInfo *)cardInfo{
    __weak CardPackViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] receiveCardWithUid:[XEEngine shareInstance].uid cid:cardInfo.cid tag:tag];
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
        for (XECardInfo *info in weakSelf.cardInfos) {
            if ([info.cid isEqual:cardInfo.cid]) {
                info.status = 4;
                break;
            }
        }
        [weakSelf.cardTableView reloadData];
        [weakSelf refreshCardCount];
    }tag:tag];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cardInfos.count;
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
    
    XECardInfo *info = _cardInfos[indexPath.row];
    cell.cardInfo = info;
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
    CardDetailViewController *cdVc = [[CardDetailViewController alloc] init];
    XECardInfo *info = _cardInfos[indexPath.row];

    cdVc.cardInfo = info;
    if ([cdVc.cardInfo.title isEqualToString:@"东方有线卡"]) {
        CardOfEastWebViewController *eastWed = [[CardOfEastWebViewController alloc]initWithNibName:@"CardOfEastWebViewController" bundle:nil];
        eastWed.hideCardInfo = YES;
        [self.navigationController pushViewController:eastWed animated:YES];
        
    }else{
        [self.navigationController pushViewController:cdVc animated:YES];
    }
    
}

#pragma mark XECardDelegate
- (void)didTouchCellWithCardInfo:(XECardInfo *)cardInfo cardTitleLabelText:(NSString *)titleText{
    
    if ([titleText isEqualToString:@"东方有线卡"]) {
        CardOfEastVerifyController *verify = [[CardOfEastVerifyController alloc]init];
        [self.navigationController pushViewController:verify animated:YES];
        
        
    }else{
        if ([XEEngine shareInstance].userInfo.profileStatus == 0) {
            [self receiveCardWithInfo:cardInfo];
        }else{
            __weak CardPackViewController *weakSelf = self;
            XEAlertView *alertView = [[XEAlertView alloc] initWithTitle:nil message:@"您需要完善资料才能领取" cancelButtonTitle:@"取消" cancelBlock:^{
            } okButtonTitle:@"确定" okBlock:^{
                PerfectInfoViewController *piVc = [[PerfectInfoViewController alloc] init];
                piVc.userInfo = [XEEngine shareInstance].userInfo;
                piVc.isFromCard = YES;
                piVc.cardInfo = cardInfo;
                piVc.finishedCallBack = ^(BOOL isFinish){
                    if (isFinish) {
                        [weakSelf.cardTableView reloadData];
                        [weakSelf refreshCardCount];
                    }
                };
                [weakSelf.navigationController pushViewController:piVc animated:YES];
            }];
            [alertView show];
        }
    }
    
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

//全局卡包未领数量先简单计算一下
- (void)refreshCardCount{
    NSString *cardKey = [NSString stringWithFormat:@"%@_%@", mineCardCountKey, [XEEngine shareInstance].uid];
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:cardKey];
    if (count > 0) {
        count--;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:cardKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:XE_CARD_CHANGED_NOTIFICATION object:self];
}

@end
