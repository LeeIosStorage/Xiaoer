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
#import "BabyProfileViewController.h"
#import "TaskViewController.h"
#import "XENavigationController.h"
#import "BabyListViewController.h"
#import "CardPackViewController.h"
#import "StageSelectViewController.h"

@interface MainPageViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,XEScrollPageDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    ODRefreshControl *_themeControl;
    XEScrollPage *scrollPageView;
    NSInteger  _cardNum;
    BOOL _isScrollViewDrag;
    NSString *_mallurl;
   
    NSString *_parklonUrl;  //爬行
    NSString *_intelUrl;    //智能
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
@property (strong, nonatomic) IBOutlet UIImageView *roundImageView;
@property (strong, nonatomic) IBOutlet UIView *containerView;

- (IBAction)mineMsgAction:(id)sender;
- (IBAction)historyAction:(id)sender;
- (IBAction)taskAction:(id)sender;

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self refreshUserInfoShow];
    
    //获取广告位信息
    [self getCacheThemeInfo];
    [self getThemeInfo];
    
    //获取首页信息
    [self getCacheHomePageInfo];
    [self getHomePageInfo];
    
    //此句不加程序崩
    [self.collectionView registerClass:[XECollectionViewCell class] forCellWithReuseIdentifier:@"XECollectionViewCell"];

    _themeControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [_themeControl addTarget:self action:@selector(themeBeginPull:) forControlEvents:UIControlEventValueChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserInfoChanged:) name:XE_USERINFO_CHANGED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMsgChanged:) name:XE_MSGINFO_CHANGED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCardChanged:) name:XE_CARD_CHANGED_NOTIFICATION object:nil];
}

- (BOOL)isVisitor{
//    if ([XEEngine shareInstance].bVisitor) {
//        return YES;
//    }
    if (![[XEEngine shareInstance] hasAccoutLoggedin]) {
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
    [self.avatarImageView sd_setImageWithURL:userInfo.babySmallAvatarUrl placeholderImage:[UIImage imageNamed:@"home_placeholder_avatar"]];
    self.avatarImageView.layer.CornerRadius = 8;
    self.avatarImageView.clipsToBounds = YES;
    self.nickName.text = userInfo.babyNick;
    self.birthday.text = [XEUIUtils dateDiscription1FromNowBk: userInfo.birthdayDate];

    if (SCREEN_HEIGHT <= 568) {
        CGRect frame = self.containerView.frame;
        frame.origin.y = frame.origin.y - 30;
        self.containerView.frame = frame;
        
        frame = self.headView.frame;
        frame.size.height = 506;
        self.headView.frame = frame;
    }
    
    self.tableView.tableHeaderView = self.headView;
    ///底部加点间隙
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 19)];
    footer.userInteractionEnabled = NO;
    footer.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footer;
}

- (void)getCacheHomePageInfo{
    __weak MainPageViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getHomepageInfosWithUid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            weakSelf.unreadLabel.text = [NSString stringWithFormat:@"%@条新消息",[[jsonRet objectForKey:@"object"] objectForKey:@"msgnum"]];
            _mallurl = [[jsonRet objectForKey:@"object"] objectForKey:@"mallurl"];
        }
    }];
}

- (void)getHomePageInfo{
//    [XEProgressHUD AlertLoading];
    __weak MainPageViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getHomepageInfosWithUid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        
        int count = [[jsonRet objectForKey:@"object"] intValueForKey:@"msgnum"];
        if (count > 0) {
            weakSelf.roundImageView.hidden = NO;
        }
        
        NSString *key = [NSString stringWithFormat:@"%@_%@", mineMsgCountKey, [XEEngine shareInstance].uid];
        [[NSUserDefaults standardUserDefaults] setInteger:count forKey:key];
        weakSelf.unreadLabel.text = [NSString stringWithFormat:@"%d条新消息",count];
        
        _mallurl = [[jsonRet objectForKey:@"object"] objectForKey:@"mallurl"];
        if (![[[jsonRet objectForKey:@"object"] objectForKey:@"devices"] isEqual:[NSNull null]]) {
            _intelUrl = [[jsonRet objectForKey:@"object"] objectForKey:@"devices"][0];
            _parklonUrl = [[jsonRet objectForKey:@"object"] objectForKey:@"devices"][1];
        }
        
        int cardCount = [[jsonRet objectForKey:@"object"] intValueForKey:@"cpnum"];
        NSString *cardKey = [NSString stringWithFormat:@"%@_%@",mineCardCountKey,[XEEngine shareInstance].uid];
        [[NSUserDefaults standardUserDefaults] setInteger:cardCount forKey:cardKey];
        _cardNum = cardCount;
        [weakSelf.collectionView reloadData];
//        [XEProgressHUD AlertSuccess:@"获取成功."];
    }tag:tag];
}

-(void)getCacheThemeInfo {
    __weak MainPageViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getBannerWithTag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
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
            if (weakSelf.adsThemeArray.count) {
                [weakSelf refreshAdsScrollView];
            }
        }
    }];
}

- (void)getThemeInfo{
    __weak MainPageViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getBannerWithTag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        _isScrollViewDrag = NO;
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            [_themeControl endRefreshing:NO];
            return;
        }
        [_themeControl endRefreshing:YES];
        
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
    }tag:tag];
}

///刷新广告位
- (void)refreshAdsScrollView {
    if (!_adsThemeArray.count) {
//        self.tableView.tableHeaderView = nil;
        self.adsViewContainer = nil;
        return;
    }
    //移除老view
    for (UIView *view in _adsViewContainer.subviews) {
        [view removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:XE_MAIN_STOP_ADS_VIEW_NOTIFICATION object:[NSNumber numberWithBool:YES]];
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
    
//    [self setTitle:@"晓儿"];
    self.titleNavImageView.hidden = NO;
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
    return 8;
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
    }else if(indexPath.row == 6){
        [cell.avatarImgView setImage:[UIImage imageNamed:@"home_rush_icon"]];
        cell.nameLabel.text = @"抢票";
    }else if(indexPath.row == 7){
        [cell.avatarImgView setImage:[UIImage imageNamed:@"home_card_icon"]];
        cell.nameLabel.text = @"卡券";
        if (_cardNum > 0) {
            cell.roundImgView.hidden = NO;
        }else{
            cell.roundImgView.hidden = YES;
        }
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 120) / 4, (SCREEN_WIDTH - 120) / 4 + 17);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 15, 15, 15);
}
                       
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 7:{
            CardPackViewController *vc = [[CardPackViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:{
            break;
        }
        case 5:{
            id vc = [XELinkerHandler handleDealWithHref:_mallurl From:self.navigationController];
            if (vc) {
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        }
        case 4:{
            ActivityViewController *vc = [[ActivityViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            ExpertListViewController *vc = [[ExpertListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{
            RecipesViewController *rVc = [[RecipesViewController alloc] init];
            rVc.infoType = TYPE_EVALUATION;
            [self.navigationController pushViewController:rVc animated:YES];
        }
            break;
        case 1:{
            RecipesViewController *rVc = [[RecipesViewController alloc] init];
            rVc.infoType = TYPE_NOURISH;
            [self.navigationController pushViewController:rVc animated:YES];
            break;
        }
        case 0:{
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
    
    return 23;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 23)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, view.frame.size.height)];
    indexLabel.backgroundColor = [UIColor clearColor];
    indexLabel.textColor = SKIN_TEXT_COLOR;
    indexLabel.font = [UIFont boldSystemFontOfSize:13];
    indexLabel.text = @"注意力和好习惯";
    [view addSubview:indexLabel];
    
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
        cell.titleLabel.text = @"注意力培养";
        cell.subTitleLabel.text = @"注意力不集中影响宝宝智力发育";
        cell.itemImageView.image = [UIImage imageNamed:@"home_attention_icon"];
    }else if (indexPath.row == 1) {
        cell.titleLabel.text = @"好习惯培养";
        cell.subTitleLabel.text = @"当宝宝的好习惯行为指导老师";
        cell.itemImageView.image = [UIImage imageNamed:@"home_parklon_icon"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecipesViewController *rVc = [[RecipesViewController alloc] init];
    if (indexPath.row == 0) {
        rVc.infoType = TYPE_ATTENTION;
    } else if (indexPath.row == 1) {
        rVc.infoType = TYPE_HABIT;
    }
    [self.navigationController pushViewController:rVc animated:YES];
    
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
        [self performSelector:@selector(getThemeInfo) withObject:self afterDelay:0.5];
        [self getHomePageInfo];
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
    
    id vc = [XELinkerHandler handleDealWithHref:theme.themeActionUrl From:self.navigationController];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//提示错误
-(void) showAlter
{
    __weak MainPageViewController *weakSelf = self;
    XEAlertView *alertView = [[XEAlertView alloc] initWithTitle:nil message:@"注册或登录后可查看宝宝训练计划，我的信箱，宝宝历史评测成绩" cancelButtonTitle:@"取消" cancelBlock:^{
    } okButtonTitle:@"确认" okBlock:^{
        WelcomeViewController *welcomeVc = [[WelcomeViewController alloc] init];
        welcomeVc.showBackButton = YES;
        XENavigationController* navigationController = [[XENavigationController alloc] initWithRootViewController:welcomeVc];
        navigationController.navigationBarHidden = YES;
        
        [weakSelf.navigationController presentViewController:navigationController animated:YES completion:nil];
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
        StageSelectViewController *vc = [[StageSelectViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)taskAction:(id)sender {
    TaskViewController *tVc = [[TaskViewController alloc] init];
    [self.navigationController pushViewController:tVc animated:YES];
}

- (void)handleUserInfoChanged:(NSNotification *)notification{
    [self refreshUserInfoShow];
    [self.tableView reloadData];
}

- (void)handleMsgChanged:(NSNotification *)notification{
    NSString *key = [NSString stringWithFormat:@"%@_%@", mineMsgCountKey, [XEEngine shareInstance].uid];
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    if (count > 0) {
        self.roundImageView.hidden = NO;
    }else {
        self.roundImageView.hidden = YES;
    }
    self.unreadLabel.text = [NSString stringWithFormat:@"%d条新消息",(int)count];
    [self.tableView reloadData];
}

- (void)handleCardChanged:(NSNotification *)notification{
    NSString *key = [NSString stringWithFormat:@"%@_%@", mineCardCountKey, [XEEngine shareInstance].uid];
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    _cardNum = count;
    [self.collectionView reloadData];
}

#pragma mark -XETabBarControllerSubVcProtocol
- (void)tabBarController:(XETabBarViewController *)tabBarController reSelectVc:(UIViewController *)viewController {
    if (viewController == self) {
        [self.tableView setContentOffset:CGPointMake(0, 0 - self.tableView.contentInset.top) animated:NO];
    }
}

@end
