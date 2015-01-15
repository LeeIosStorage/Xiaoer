//
//  MainPageViewController.m
//  Xiaoer
//
//  Created by KID on 14/12/30.
//
//

#import "MainPageViewController.h"
#import "XETabBarViewController.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XEThemeInfo.h"
#import "MainTabCell.h"
#import "XEScrollPage.h"
#import "XELinkerHandler.h"

@interface MainPageViewController ()<UITableViewDataSource, UITableViewDelegate,XEScrollPageDelegate,UIScrollViewDelegate>{
    XEScrollPage *scrollPageView;
    BOOL _isScrollViewDrag;
}

@property (nonatomic, strong) NSMutableArray *adsThemeArray;

@property (nonatomic, strong) IBOutlet UIView *adsViewContainer;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"首页"];
    
    [self getThemeInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)getThemeInfo{
    [XEProgressHUD AlertLoading];
    __weak MainPageViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getBannerWithTag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg];
            return;
        }
        NSLog(@"jsonRet===============%@",jsonRet);
        [weakSelf.adsThemeArray removeAllObjects];
        //解析数据
        weakSelf.adsThemeArray = [NSMutableArray array];
        
        NSArray *themeDicArray = [jsonRet arrayObjectForKey:@"object"];
        for (NSDictionary *dic  in themeDicArray) {
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            XEThemeInfo *theme = [[XEThemeInfo alloc] init];
            [theme setThemeInfoByDic:dic];
            [weakSelf.adsThemeArray addObject:theme];
        }
        
        //刷新广告
        if (weakSelf.adsThemeArray.count) {
            [weakSelf refreshAdsScrollView];
        }
        
        [XEProgressHUD AlertSuccess:@"获取成功."];
    }tag:tag];
}

///刷新广告位
- (void)refreshAdsScrollView {
    if (!_adsThemeArray.count) {
        self.tableView.tableHeaderView = nil;
        return;
    }
    //移除老view
    for (UIView *view in _adsViewContainer.subviews) {
        [view removeFromSuperview];
    }
    
    CGRect frame = _adsViewContainer.bounds;
    scrollPageView = [[XEScrollPage alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    scrollPageView.duration = 4;
    scrollPageView.adsType = AdsType_Theme;
    scrollPageView.dataArray = _adsThemeArray;
    scrollPageView.delegate = self;
    [self.adsViewContainer addSubview:scrollPageView];
    
    self.tableView.tableHeaderView = self.headView;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    
    [self setLeftButtonWithSelector:@selector(settingAction:)];
//    [self setRightButtonWithTitle:@"按钮" selector:@selector(settingAction:)];
}

- (UINavigationController *)navigationController{
    if ([super navigationController]) {
        return [super navigationController];
    }
    return self.tabController.navigationController;
}



#pragma mark - IBAction
//-(void)backAction:(id)sender{
//    
//}
-(void)settingAction:(id)sender{
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return SINGLE_HEADER_HEADER;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SINGLE_HEADER_HEADER)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MainTabCell";
    MainTabCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section is %ld",(long)indexPath.row);
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isScrollViewDrag = YES;
}

//#pragma LSScrollPage delegate
- (void)didTouchPageView:(NSInteger)index{
    if (index < 0) {
        return;
    }
    
    XEThemeInfo *theme = [_adsThemeArray objectAtIndex:index];
    if (!theme) {
        return;
    }
    
    id vc = [XELinkerHandler handleDealWithHref:theme.themeImageUrl From:self.navigationController];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:XE_MAIN_SHOW_ADS_VIEW_NOTIFICATION object:[NSNumber numberWithBool:YES]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:XE_MAIN_STOP_ADS_VIEW_NOTIFICATION object:[NSNumber numberWithBool:YES]];
}

- (void)applicationWillResignActive:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:XE_MAIN_STOP_ADS_VIEW_NOTIFICATION object:[NSNumber numberWithBool:YES]];
}

- (void)appWillEnterForeground:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:XE_MAIN_SHOW_ADS_VIEW_NOTIFICATION object:[NSNumber numberWithBool:YES]];
}

@end
