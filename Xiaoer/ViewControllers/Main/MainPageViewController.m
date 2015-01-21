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
#import "RecipesViewController.h"
#import "ExpertListViewController.h"
#import "ActivityViewController.h"
#import "XELinkerHandler.h"
#import "XECollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "ODRefreshControl.h"
#import "MineMsgViewController.h"
#import "WelcomeViewController.h"
#import "XEAlertView.h"

@interface MainPageViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,XEScrollPageDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    ODRefreshControl *_themeControl;
    XEScrollPage *scrollPageView;
    BOOL _isScrollViewDrag;
    NSString *_mallurl;
}

@property (nonatomic, strong) NSMutableArray *adsThemeArray;
@property (nonatomic, strong) XEUserInfo *userInfo;

@property (nonatomic, strong) IBOutlet UIView *adsViewContainer;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *unreadLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UILabel *birthday;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;

- (IBAction)mineMsgAction:(id)sender;
- (IBAction)historyAction:(id)sender;
- (IBAction)taskAction:(id)sender;

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"首页"];
    [self refreshAdsScrollView];
    [self refreshUserInfoShow];
    
    //获取首页信息
    [self getHomePageInfo];
    //获取广告位信息
    [self getThemeInfo];
    
    //此句不加程序崩
    [self.collectionView registerClass:[XECollectionViewCell class] forCellWithReuseIdentifier:@"XECollectionViewCell"];
    
    _themeControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [_themeControl addTarget:self action:@selector(themeBeginPull:) forControlEvents:UIControlEventValueChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (BOOL)isVisitor{
    if ([XEEngine shareInstance].bVisitor) {
        return YES;
    }
    return NO;
}

-(XEUserInfo *)getBabyUserInfo:(NSInteger)index{
    _userInfo = [XEEngine shareInstance].userInfo;
    if (_userInfo.babys.count > index) {
        XEUserInfo *babyUserInfo = [_userInfo.babys objectAtIndex:index];
        return babyUserInfo;
    }
    return nil;
}

- (void)refreshUserInfoShow{
    XEUserInfo *userInfo = [self getBabyUserInfo:0];
    [self.avatarImageView sd_setImageWithURL:userInfo.smallAvatarUrl placeholderImage:[UIImage imageNamed:@"home_placeholder_avatar"]];
    self.avatarImageView.layer.CornerRadius = 8;
    self.nickName.text = _userInfo.nickName;
    self.birthday.text = [XEUIUtils dateDiscription1FromNowBk: userInfo.birthdayDate];
    self.tableView.tableHeaderView = self.headView;
    ///底部加点间隙
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 19)];
    footer.userInteractionEnabled = NO;
    footer.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footer;
}

- (void)getHomePageInfo{
    [XEProgressHUD AlertLoading];
    __weak MainPageViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getHomepageInfosWithUid:[XEEngine shareInstance].uid tag:tag];
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
        //NSLog(@"jsonRet===============%@",jsonRet);
        weakSelf.unreadLabel.text = [NSString stringWithFormat:@"%@条新消息",[[jsonRet objectForKey:@"object"] objectForKey:@"msgnum"]];
        _mallurl = [[jsonRet objectForKey:@"object"] objectForKey:@"mallurl"];
        [XEProgressHUD AlertSuccess:@"获取成功."];
    }tag:tag];
}

- (void)getThemeInfo{
    __weak MainPageViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getBannerWithTag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg];
            [_themeControl endRefreshing:NO];
            return;
        }
        [_themeControl endRefreshing:YES];
        
        //NSLog(@"jsonRet===============%@",jsonRet);
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
        
//        [XEProgressHUD AlertSuccess:@"获取成功."];
    }tag:tag];
}

///刷新广告位
- (void)refreshAdsScrollView {
//    if (!_adsThemeArray.count) {
//        self.tableView.tableHeaderView = nil;
//        return;
//    }
    //移除老view
    for (UIView *view in _adsViewContainer.subviews) {
        [view removeFromSuperview];
    }
    
    scrollPageView = [[XEScrollPage alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(_adsViewContainer.frame))];
    scrollPageView.duration = 4;
    scrollPageView.adsType = AdsType_Theme;
    scrollPageView.dataArray = _adsThemeArray;
    scrollPageView.delegate = self;
    [self.adsViewContainer addSubview:scrollPageView];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    
    //...
}

- (UINavigationController *)navigationController{
    if ([super navigationController]) {
        return [super navigationController];
    }
    return self.tabController.navigationController;
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    XECollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XECollectionViewCell" forIndexPath:indexPath];
    if(indexPath.row == 0){
        [cell.avatarImgView setImage:[UIImage imageNamed:@"home_recipes_icon"]];
        [cell.nameLabel setText:@"食谱"];
    }else if(indexPath.row == 1){
        [cell.avatarImgView setImage:[UIImage imageNamed:@"home_nourish_icon"]];
        cell.nameLabel.text = @"养育";
    }else if(indexPath.row == 2){
        [cell.avatarImgView setImage:[UIImage imageNamed:@"home_evaluation_icon"]];
        cell.nameLabel.text = @"测评";
    }else if(indexPath.row == 3){
        [cell.avatarImgView setImage:[UIImage imageNamed:@"home_expert_icon"]];
        cell.nameLabel.text = @"专家";
    }else if(indexPath.row == 4){
        [cell.avatarImgView setImage:[UIImage imageNamed:@"home_activity_icon"]];
        cell.nameLabel.text = @"活动";
    }else if(indexPath.row == 5){
        [cell.avatarImgView setImage:[UIImage imageNamed:@"home_mall_icon"]];
        cell.nameLabel.text = @"商城";
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 110) / 3, 89);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 25, 15, 15);
}
                       
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 5:{
            NSLog(@"============商城");
            id vc = [XELinkerHandler handleDealWithHref:_mallurl From:self.navigationController];
            if (vc) {
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        }
        case 4:{
            NSLog(@"============活动");
            ActivityViewController *vc = [[ActivityViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            NSLog(@"============专家");
            ExpertListViewController *vc = [[ExpertListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{
            NSLog(@"============测评");
            RecipesViewController *rVc = [[RecipesViewController alloc] init];
            rVc.infoType = TYPE_EVALUATION;
            [self.navigationController pushViewController:rVc animated:YES];
        }
            break;
        case 1:{
            NSLog(@"============养育");
            RecipesViewController *rVc = [[RecipesViewController alloc] init];
            rVc.infoType = TYPE_NOURISH;
            [self.navigationController pushViewController:rVc animated:YES];
            break;
        }
        case 0:{
            NSLog(@"============食谱");
            RecipesViewController *rVc = [[RecipesViewController alloc] init];
            rVc.infoType = TYPE_RECIPES;
            [self.navigationController pushViewController:rVc animated:YES];
            break;
        }
        default:
            break;
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    view.backgroundColor = UIColorRGB(234,234,234);
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
    
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"智能垫";
        cell.itemImageView.image = [UIImage imageNamed:@"home_intelligent_icon"];
    }else if (indexPath.row == 1) {
        cell.titleLabel.text = @"爬行毯";
        cell.itemImageView.image = [UIImage imageNamed:@"home_parklon_icon"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section is %ld",(long)indexPath.row);
    
    id vc = [XELinkerHandler handleDealWithHref:@"http://www.baidu.com" From:self.navigationController];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isScrollViewDrag = YES;
}

#pragma mark - ODRefreshControl
- (void)themeBeginPull:(ODRefreshControl *)refreshControl
{
    if (_isScrollViewDrag) {
//        [self performSelector:@selector(getThemeInfo) withObject:self afterDelay:1.0];
        [self getThemeInfo];
    }
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
    
    //id vc = [XELinkerHandler handleDealWithHref:theme.themeImageUrl From:self.navigationController];
    NSString *url = [NSString stringWithFormat:@"http://192.168.16.29/info/detail?id=%@",theme.tid];
    id vc = [XELinkerHandler handleDealWithHref:url From:self.navigationController];
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

//提示错误
-(void) showAlter
{
    __weak MainPageViewController *weakSelf = self;
    XEAlertView *alertView = [[XEAlertView alloc] initWithTitle:nil message:@"注册或登录后可查看宝宝训练计划，我的信箱，宝宝历史评测成绩" cancelButtonTitle:@"取消" cancelBlock:^{
    } okButtonTitle:@"确认" okBlock:^{
        WelcomeViewController *welcomeVc = [[WelcomeViewController alloc] init];
        [weakSelf.navigationController pushViewController:welcomeVc animated:YES];
    }];
    [alertView show];
}

- (IBAction)mineMsgAction:(id)sender {
    if ([self isVisitor]) {
        [self showAlter];
    }else{
        MineMsgViewController *mmVc = [[MineMsgViewController alloc] init];
        [self.navigationController pushViewController:mmVc animated:YES];
    }
}

- (IBAction)historyAction:(id)sender {
    if ([self isVisitor]) {
        [self showAlter];
    }else {
        id vc = [XELinkerHandler handleDealWithHref:@"http://www.baidu.com" From:self.navigationController];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (IBAction)taskAction:(id)sender {
    if ([self isVisitor]) {
        [self showAlter];
    }else{
        id vc = [XELinkerHandler handleDealWithHref:@"http://www.baidu.com" From:self.navigationController];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
