//
//  ExpertListViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import "ExpertListViewController.h"
#import "ExpertListViewCell.h"
#import "UIImageView+WebCache.h"
#import "ExpertIntroViewController.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XEDoctorInfo.h"
#import "XEPublicViewController.h"
#import "ODRefreshControl.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "PerfectInfoViewController.h"
#import "XEAlertView.h"
#import "BabyListViewController.h"

@interface ExpertListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
//    ODRefreshControl *_refreshControl;
//    BOOL _isScrollViewDrag;
}
@property (nonatomic, strong) NSMutableArray *expertList;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIImageView *nurserNoneTipView;
@property (assign, nonatomic) SInt64  nextCursor;
@property (assign, nonatomic) BOOL canLoadMore;

@end

@implementation ExpertListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = UIColorRGB(240, 240, 240);
//    _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
//    [_refreshControl addTarget:self action:@selector(refreshControlBeginPull:) forControlEvents:UIControlEventValueChanged];
    
    self.pullRefreshView = [[PullToRefreshView alloc] initWithScrollView:self.tableView];
    self.pullRefreshView.delegate = self;
    [self.tableView addSubview:self.pullRefreshView];
    
    __weak ExpertListViewController *weakSelf = self;
    if (_vcType == VcType_Expert) {
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            if (!weakSelf) {
                return;
            }
            if (!weakSelf.canLoadMore) {
                [weakSelf.tableView.infiniteScrollingView stopAnimating];
                weakSelf.tableView.showsInfiniteScrolling = NO;
                return ;
            }
            
            int tag = [[XEEngine shareInstance] getConnectTag];
            [[XEEngine shareInstance] getExpertListWithPage:(int)weakSelf.nextCursor tag:tag];
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
                    [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
                    return;
                }
                //            [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
                
                NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"experts"];
                for (NSDictionary *dic in object) {
                    XEDoctorInfo *doctorInfo = [[XEDoctorInfo alloc] init];
                    [doctorInfo setDoctorInfoByJsonDic:dic];
                    [weakSelf.expertList addObject:doctorInfo];
                }
                weakSelf.canLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
                if (!weakSelf.canLoadMore) {
                    weakSelf.tableView.showsInfiniteScrolling = NO;
                }else{
                    weakSelf.tableView.showsInfiniteScrolling = YES;
                    weakSelf.nextCursor ++;
                }
                [weakSelf.tableView reloadData];
                
            } tag:tag];
        }];
        
        [self getCacheExpertInfo];
        [self refreshExpertList:YES];
    }else if (_vcType == VcType_Nurser){
        
//        if ([[XEEngine shareInstance] needUserLogin:@"绑定育婴师需登录，请先登录"]) {
//            
//        }
        
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            if (!weakSelf) {
                return;
            }
            if (!weakSelf.canLoadMore) {
                [weakSelf.tableView.infiniteScrollingView stopAnimating];
                weakSelf.tableView.showsInfiniteScrolling = NO;
                return ;
            }
            
            int tag = [[XEEngine shareInstance] getConnectTag];
            [[XEEngine shareInstance] getNurserListWithPage:(int)weakSelf.nextCursor uid:[XEEngine shareInstance].uid tag:tag];
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
                    [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
                    return;
                }
                
                NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"nursers"];
                for (NSDictionary *dic in object) {
                    XEDoctorInfo *doctorInfo = [[XEDoctorInfo alloc] init];
                    [doctorInfo setDoctorInfoByJsonDic:dic];
                    [weakSelf.expertList addObject:doctorInfo];
                }
                weakSelf.canLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
                if (!weakSelf.canLoadMore) {
                    weakSelf.tableView.showsInfiniteScrolling = NO;
                }else{
                    weakSelf.tableView.showsInfiniteScrolling = YES;
                    weakSelf.nextCursor ++;
                }
                [weakSelf.tableView reloadData];
                
            } tag:tag];
        }];
        
        [self getCacheNurserInfo];
        [self refreshNurserList];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    [self setTitle:@"晓儿专家"];
    if (_vcType == VcType_Nurser) {
        [self setTitle:@"晓儿测评师"];
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

-(void)refreshViewUI{
    if (_vcType == VcType_Nurser) {
        if (_expertList && _expertList.count == 0) {
            self.nurserNoneTipView.hidden = NO;
            self.tableView.hidden = YES;
            self.nurserNoneTipView.clipsToBounds = YES;
            self.nurserNoneTipView.contentMode = UIViewContentModeScaleAspectFill;
            CGRect frame = self.view.bounds;
            if (frame.size.height == 480) {
                frame = self.nurserNoneTipView.frame;
                frame.origin.y = 50;
                self.nurserNoneTipView.frame = frame;
            }
        }else{
            self.nurserNoneTipView.hidden = YES;
            self.tableView.hidden = NO;
        }
    }else{
        self.nurserNoneTipView.hidden = YES;
    }
}

#pragma mark - 育婴师
- (void)getCacheNurserInfo{
    __weak ExpertListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getNurserListWithPage:1 uid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            weakSelf.expertList = [[NSMutableArray alloc] init];
            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"nursers"];
            for (NSDictionary *dic in object) {
                XEDoctorInfo *doctorInfo = [[XEDoctorInfo alloc] init];
                [doctorInfo setDoctorInfoByJsonDic:dic];
                [weakSelf.expertList addObject:doctorInfo];
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)refreshNurserList{
    
    self.nextCursor = 1;
    __weak ExpertListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getNurserListWithPage:(int)self.nextCursor uid:[XEEngine shareInstance].uid tag:tag];
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
        
        weakSelf.expertList = [[NSMutableArray alloc] init];
        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"nursers"];
        for (NSDictionary *dic in object) {
            XEDoctorInfo *doctorInfo = [[XEDoctorInfo alloc] init];
            [doctorInfo setDoctorInfoByJsonDic:dic];
            [weakSelf.expertList addObject:doctorInfo];
        }
        
        weakSelf.canLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
        if (!weakSelf.canLoadMore) {
            weakSelf.tableView.showsInfiniteScrolling = NO;
        }else{
            weakSelf.tableView.showsInfiniteScrolling = YES;
            weakSelf.nextCursor ++;
        }
        [weakSelf refreshViewUI];
        [weakSelf.tableView reloadData];
        
    }tag:tag];
}

#pragma mark - 专家
- (void)getCacheExpertInfo{
    __weak ExpertListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getExpertListWithPage:1 tag:tag];
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
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)refreshExpertList:(BOOL)isAlert{
    
//    if (isAlert) {
//        [XEProgressHUD AlertLoading:@"数据加载中..."];
//    }
    self.nextCursor = 1;
    __weak ExpertListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getExpertListWithPage:(int)self.nextCursor tag:tag];
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
//        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
        
        weakSelf.expertList = [[NSMutableArray alloc] init];
        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"experts"];
        for (NSDictionary *dic in object) {
            XEDoctorInfo *doctorInfo = [[XEDoctorInfo alloc] init];
            [doctorInfo setDoctorInfoByJsonDic:dic];
            [weakSelf.expertList addObject:doctorInfo];
        }
        
        weakSelf.canLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
        if (!weakSelf.canLoadMore) {
            weakSelf.tableView.showsInfiniteScrolling = NO;
        }else{
            weakSelf.tableView.showsInfiniteScrolling = YES;
            weakSelf.nextCursor ++;
        }
//        weakSelf.canLoadMore = YES;
//        weakSelf.tableView.showsInfiniteScrolling = YES;
//        weakSelf.nextCursor ++;
        
        [weakSelf.tableView reloadData];
        
    }tag:tag];
    
    
}

#pragma mark - custom

//#pragma mark - ODRefreshControl
//- (void)refreshControlBeginPull:(ODRefreshControl *)refreshControl
//{
//    if (_isScrollViewDrag) {
//        [self refreshExpertList:NO];
//    }
//}
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    _isScrollViewDrag = YES;
//}

#pragma mark PullToRefreshViewDelegate
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    if (_vcType == VcType_Expert) {
        [self refreshExpertList:NO];
    }else if (_vcType == VcType_Nurser){
        [self refreshNurserList];
    }
}

- (NSDate *)pullToRefreshViewLastUpdated:(PullToRefreshView *)view {
    return [NSDate date];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _expertList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.row == 1) {
//        return 110;
//    }
    XEDoctorInfo *doctorInfo = _expertList[indexPath.row];
    return [ExpertListViewCell heightForDoctorInfo:doctorInfo];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ExpertListViewCell";
    ExpertListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        [cell.consultButton addTarget:self action:@selector(handleClickAt:event:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (_vcType == VcType_Nurser) {
        cell.isNurser = YES;
    }else if (_vcType == VcType_Expert){
        cell.isNurser = NO;
    }
    XEDoctorInfo *doctorInfo = _expertList[indexPath.row];
    cell.doctorInfo = doctorInfo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
    if (_vcType == VcType_Nurser) {
        return;
    }
    
//    if (_isNeedSelect) {
//        XEDoctorInfo *doctorInfo = _expertList[indexPath.row];
//        XEPublicViewController *vc = [[XEPublicViewController alloc] init];
//        vc.publicType = Public_Type_Expert;
//        vc.doctorInfo = doctorInfo;
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
    XEDoctorInfo *doctorInfo = _expertList[indexPath.row];
    ExpertIntroViewController *vc = [[ExpertIntroViewController alloc] init];
    vc.doctorInfo = doctorInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)handleClickAt:(id)sender event:(id)event{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil){
//        NSLog(@"indexPath: row:%d", indexPath.row);
//        _isNeedSelect = YES;
//        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        
        XEDoctorInfo *doctorInfo = _expertList[indexPath.row];
        if (_vcType == VcType_Nurser) {
            [self bindNurser:doctorInfo];
            return;
        }
        XEPublicViewController *vc = [[XEPublicViewController alloc] init];
        vc.publicType = Public_Type_Expert;
        vc.doctorInfo = doctorInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(XEUserInfo *)getBabyUserInfo:(NSInteger)index{
    if ([XEEngine shareInstance].userInfo.babys.count > index) {
        XEUserInfo *babyUserInfo = [[XEEngine shareInstance].userInfo.babys objectAtIndex:index];
        return babyUserInfo;
    }
    return nil;
}

-(void)bindNurser:(XEDoctorInfo *)doctorInfo{
    if ([[XEEngine shareInstance] needUserLogin:@"绑定育婴师需登录，请先登录"]) {
        return;
    }
    XEUserInfo *userInfo = [self getBabyUserInfo:0];
    if (userInfo == nil || userInfo.babyId.length == 0) {
        __weak ExpertListViewController *weakSelf = self;
        XEAlertView *alertView = [[XEAlertView alloc] initWithTitle:nil message:@"绑定育婴师需有宝宝，请先添加宝宝" cancelButtonTitle:@"取消" cancelBlock:^{
        } okButtonTitle:@"确定" okBlock:^{
            BabyListViewController *vc = [[BabyListViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        [alertView show];
        return;
    }
    [XEProgressHUD AlertLoading:@"绑定中..." At:self.view];
    __weak ExpertListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] bindNurserWithNurserId:doctorInfo.doctorId uid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"] At:weakSelf.view];
        doctorInfo.status = 2;
        [weakSelf.tableView reloadData];
        
    }tag:tag];
}

@end
