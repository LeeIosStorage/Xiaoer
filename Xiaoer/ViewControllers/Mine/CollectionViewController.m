//
//  CollectionViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/20.
//
//

#import "CollectionViewController.h"
#import "XEEngine.h"
#import "CategoryItemCell.h"
#import "XERecipesInfo.h"
#import "XEDoctorInfo.h"
#import "XEProgressHUD.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIImageView+WebCache.h"
#import "CollectActivityViewCell.h"
#import "XELinkerHandler.h"
#import "ExpertIntroViewController.h"

#define INFORMATION_TYPE     0
#define EXPERT_TYPE          1

@interface CollectionViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *informationList;
@property (nonatomic, strong) IBOutlet UITableView *informationTableView;
@property (strong, nonatomic) NSMutableArray *expertList;
@property (nonatomic, strong) IBOutlet UITableView *expertTableView;

@property (assign, nonatomic) NSInteger selectedSegmentIndex;
@property (assign, nonatomic) SInt64  informationNextCursor;
@property (assign, nonatomic) BOOL informationCanLoadMore;
@property (assign, nonatomic) SInt64  expertNextCursor;
@property (assign, nonatomic) BOOL expertCanLoadMore;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.pullRefreshView = [[PullToRefreshView alloc] initWithScrollView:self.informationTableView];
    self.pullRefreshView.delegate = self;
    [self.informationTableView addSubview:self.pullRefreshView];
    
    self.pullRefreshView2 = [[PullToRefreshView alloc] initWithScrollView:self.expertTableView];
    self.pullRefreshView2.delegate = self;
    [self.expertTableView addSubview:self.pullRefreshView2];
    
    [self feedsTypeSwitch:INFORMATION_TYPE needRefreshFeeds:YES];
    
    __weak CollectionViewController *weakSelf = self;
    [self.informationTableView addInfiniteScrollingWithActionHandler:^{
        if (!weakSelf) {
            return;
        }
        if (!weakSelf.informationCanLoadMore) {
            [weakSelf.informationTableView.infiniteScrollingView stopAnimating];
            weakSelf.informationTableView.showsInfiniteScrolling = NO;
            return ;
        }
        
        int tag = [[XEEngine shareInstance] getConnectTag];
        [[XEEngine shareInstance] getMyCollectInfoListWithUid:[XEEngine shareInstance].uid page:(int)weakSelf.informationNextCursor tag:tag];
        [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
            if (!weakSelf) {
                return;
            }
            
            [weakSelf.informationTableView.infiniteScrollingView stopAnimating];
            NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
            if (!jsonRet || errorMsg) {
                if (!errorMsg.length) {
                    errorMsg = @"请求失败";
                }
                [XEProgressHUD AlertError:errorMsg];
                return;
            }
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"infos"];
            for (NSDictionary *dic in object) {
                XERecipesInfo *recipesInfo = [[XERecipesInfo alloc] init];
                [recipesInfo setRecipesInfoByDic:dic];
                [weakSelf.informationList addObject:recipesInfo];
            }
            
            weakSelf.informationCanLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
            if (!weakSelf.informationCanLoadMore) {
                weakSelf.informationTableView.showsInfiniteScrolling = NO;
            }else{
                weakSelf.informationTableView.showsInfiniteScrolling = YES;
                weakSelf.informationNextCursor ++;
            }
            
            [weakSelf.informationTableView reloadData];
            
        } tag:tag];
    }];
    
    [self.expertTableView addInfiniteScrollingWithActionHandler:^{
        if (!weakSelf) {
            return;
        }
        if (!weakSelf.expertCanLoadMore) {
            [weakSelf.expertTableView.infiniteScrollingView stopAnimating];
            weakSelf.expertTableView.showsInfiniteScrolling = NO;
            return ;
        }
        
        int tag = [[XEEngine shareInstance] getConnectTag];
        [[XEEngine shareInstance] getMyCollectExpertListWithUid:[XEEngine shareInstance].uid page:(int)weakSelf.expertNextCursor tag:tag];
        [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
            if (!weakSelf) {
                return;
            }
            
            [weakSelf.expertTableView.infiniteScrollingView stopAnimating];
            NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
            if (!jsonRet || errorMsg) {
                if (!errorMsg.length) {
                    errorMsg = @"请求失败";
                }
                [XEProgressHUD AlertError:errorMsg];
                return;
            }
            
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"experts"];
            for (NSDictionary *dic in object) {
                XEDoctorInfo *doctorInfo = [[XEDoctorInfo alloc] init];
                [doctorInfo setDoctorInfoByJsonDic:dic];
                [weakSelf.expertList addObject:doctorInfo];
            }
            
            weakSelf.expertCanLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
            if (!weakSelf.expertCanLoadMore) {
                weakSelf.expertTableView.showsInfiniteScrolling = NO;
            }else{
                weakSelf.expertTableView.showsInfiniteScrolling = YES;
                weakSelf.expertNextCursor ++;
            }
            
            [weakSelf.expertTableView reloadData];
            
        } tag:tag];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    [self setSegmentedControlWithSelector:@selector(segmentedControlAction:) items:@[@"资讯",@"专家"]];
}

-(void)feedsTypeSwitch:(int)tag needRefreshFeeds:(BOOL)needRefresh
{
    if (tag == INFORMATION_TYPE) {
        //减速率
        self.expertTableView.decelerationRate = 0.0f;
        self.informationTableView.decelerationRate = 1.0f;
        self.expertTableView.hidden = YES;
        self.informationTableView.hidden = NO;
        
        if (!_informationList) {
            [self getCacheInformation];
            [self refreshInformationList];
            return;
        }
        if (needRefresh) {
            [self refreshInformationList];
        }
    }else if (tag == EXPERT_TYPE){
        
        self.expertTableView.decelerationRate = 1.0f;
        self.informationTableView.decelerationRate = 0.0f;
        self.informationTableView.hidden = YES;
        self.expertTableView.hidden = NO;
        if (!_expertList) {
            [self getCacheExpert];
            [self refreshExpertList];
            return;
        }
        if (needRefresh) {
            [self refreshExpertList];
        }
    }
}

#pragma mark - 资讯
- (void)getCacheInformation{
    __weak CollectionViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getMyCollectInfoListWithUid:[XEEngine shareInstance].uid page:1 tag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            weakSelf.informationList = [[NSMutableArray alloc] init];
            
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"infos"];
            for (NSDictionary *dic in object) {
                XERecipesInfo *recipesInfo = [[XERecipesInfo alloc] init];
                [recipesInfo setRecipesInfoByDic:dic];
                [weakSelf.informationList addObject:recipesInfo];
            }
            [weakSelf.informationTableView reloadData];
        }
    }];
}
- (void)refreshInformationList{
    
    _informationNextCursor = 1;
    __weak CollectionViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getMyCollectInfoListWithUid:[XEEngine shareInstance].uid page:(int)_informationNextCursor tag:tag];
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
        weakSelf.informationList = [[NSMutableArray alloc] init];
        
        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"infos"];
        for (NSDictionary *dic in object) {
            XERecipesInfo *recipesInfo = [[XERecipesInfo alloc] init];
            [recipesInfo setRecipesInfoByDic:dic];
            [weakSelf.informationList addObject:recipesInfo];
        }
        
        weakSelf.informationCanLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
        if (!weakSelf.informationCanLoadMore) {
            weakSelf.informationTableView.showsInfiniteScrolling = NO;
        }else{
            weakSelf.informationTableView.showsInfiniteScrolling = YES;
            weakSelf.informationNextCursor ++;
        }
        
        [weakSelf.informationTableView reloadData];
        
    }tag:tag];
}

#pragma mark - 专家
- (void)getCacheExpert{
    __weak CollectionViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getMyCollectExpertListWithUid:[XEEngine shareInstance].uid page:1 tag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            weakSelf.expertList = [[NSMutableArray alloc] init];
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"experts"];
            for (NSDictionary *dic in object) {
                XEDoctorInfo *doctorInfo = [[XEDoctorInfo alloc] init];
                [doctorInfo setDoctorInfoByJsonDic:dic];
                [weakSelf.expertList addObject:doctorInfo];
            }
            [weakSelf.expertTableView reloadData];
        }
    }];
}
- (void)refreshExpertList{
    
    _expertNextCursor = 1;
    __weak CollectionViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getMyCollectExpertListWithUid:[XEEngine shareInstance].uid page:(int)_expertNextCursor tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        [self.pullRefreshView2 finishedLoading];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg];
            return;
        }
        
        weakSelf.expertList = [[NSMutableArray alloc] init];
        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"experts"];
        for (NSDictionary *dic in object) {
            XEDoctorInfo *doctorInfo = [[XEDoctorInfo alloc] init];
            [doctorInfo setDoctorInfoByJsonDic:dic];
            [weakSelf.expertList addObject:doctorInfo];
        }
        
        weakSelf.expertCanLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
        if (!weakSelf.expertCanLoadMore) {
            weakSelf.expertTableView.showsInfiniteScrolling = NO;
        }else{
            weakSelf.expertTableView.showsInfiniteScrolling = YES;
            weakSelf.expertNextCursor ++;
        }
        
        [weakSelf.expertTableView reloadData];
        
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

-(void)unCollectInformationWith:(XERecipesInfo*)info{
    if ([[XEEngine shareInstance] needUserLogin:nil]) {
        return;
    }
    __weak CollectionViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] unCollectInfoWithInfoId:info.rid uid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg];
            return;
        }
        NSInteger index = [weakSelf.informationList indexOfObject:info];
        if (index == NSNotFound || index < 0 || index >= weakSelf.informationList.count) {
            return;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [weakSelf.informationList removeObjectAtIndex:indexPath.row];
        [weakSelf.informationTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }tag:tag];
}
-(void)unCollectExpertWith:(XEDoctorInfo*)doctorInfo{
    
    if ([[XEEngine shareInstance] needUserLogin:nil]) {
        return;
    }
    __weak CollectionViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] unCollectExpertWithExpertId:doctorInfo.doctorId uid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg];
            return;
        }
        NSInteger index = [weakSelf.expertList indexOfObject:doctorInfo];
        if (index == NSNotFound || index < 0 || index >= self.expertList.count) {
            return;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [weakSelf.expertList removeObjectAtIndex:indexPath.row];
        [weakSelf.expertTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }tag:tag];
}
#pragma mark PullToRefreshViewDelegate
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    if (view == self.pullRefreshView) {
        [self refreshInformationList];
    }else if (view == self.pullRefreshView2){
        [self refreshExpertList];
    }
}
- (NSDate *)pullToRefreshViewLastUpdated:(PullToRefreshView *)view {
    return [NSDate date];
}

#pragma mark - TableView Delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (tableView == self.informationTableView) {
            XERecipesInfo *info = [self.informationList objectAtIndex:indexPath.row];
            [self unCollectInformationWith:info];
            
        }else if (tableView == self.expertTableView){
            XEDoctorInfo *doctorInfo = self.expertList[indexPath.row];
            [self unCollectExpertWith:doctorInfo];
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
    if (tableView == self.expertTableView) {
        return self.expertList.count;
    }
    return self.informationList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.expertTableView) {
        return 51;
    }
    return 84;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.expertTableView) {
        static NSString *CellIdentifier = @"CollectActivityViewCell";
        CollectActivityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        XEDoctorInfo *doctorInfo = _expertList[indexPath.row];
        cell.doctorInfo = doctorInfo;
        return cell;
    }
    
    static NSString *CellIdentifier2 = @"CategoryItemCell";
    CategoryItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier2 owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    
    XERecipesInfo *info = [_informationList objectAtIndex:indexPath.row];
    if (![info.recipesImageUrl isEqual:[NSNull null]]) {
        [cell.infoImageView sd_setImageWithURL:info.smallRecipesImageUrl placeholderImage:[UIImage imageNamed:@"recipes_load_icon"]];
    }else{
        [cell.infoImageView sd_setImageWithURL:nil];
        [cell.infoImageView setImage:[UIImage imageNamed:@"information_placeholder_icon"]];
    }
    
    cell.titleLabel.text = info.title;
    cell.readLabel.hidden = YES;
    cell.collectLabel.hidden = YES;
    cell.collectImageView.hidden = YES;
    cell.readImageView.hidden = YES;
    
    if (info.isTop == 1) {
        cell.topImageView.hidden = NO;
    }else{
        cell.topImageView.hidden = YES;
    }
    if (indexPath.row == 0) {
        cell.topline.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
    if (tableView == self.expertTableView) {
        XEDoctorInfo *doctorInfo = _expertList[indexPath.row];
        ExpertIntroViewController *vc = [[ExpertIntroViewController alloc] init];
        vc.doctorInfo = doctorInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        XERecipesInfo *recipesInfo = [_informationList objectAtIndex:indexPath.row];
        id vc = [XELinkerHandler handleDealWithHref:recipesInfo.recipesActionUrl From:self.navigationController];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
