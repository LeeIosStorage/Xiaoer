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
#import "TicketListViewController.h"
#import "InformationViewController.h"
#import "MineTabViewController.h"
#import "MainTabScrollCell.h"
#import "focusAndHabitViewController.h"
#import "EveryOneWeekController.h"
#import "MotherLookController.h"
#import "BabyProfileViewController.h"
#import "BabyImpressMainController.h"
#import "AppDelegate.h"


@interface MainPageViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,XEScrollPageDelegate,UICollectionViewDataSource,UICollectionViewDelegate,selestDelegate>{
    ODRefreshControl *_themeControl;
    XEScrollPage *scrollPageView;
    NSInteger  _cardNum;
    NSInteger  _ticketNum;
    
    BOOL _isScrollViewDrag;
    
    NSString *_mallurl;
    NSString *_parklonUrl;  //爬行
    NSString *_intelUrl;    //智能
}
/**
 *  每周 一练的ScrollView
 */
@property (weak, nonatomic) IBOutlet UIScrollView *oneWeekScrollView;

/**
 *  每周一练的月份数量
 */
@property (nonatomic,assign)NSInteger index;

@property (nonatomic, strong) NSMutableArray *adsThemeArray;
@property (nonatomic, strong) XEUserInfo *userInfo;

@property (nonatomic, strong) IBOutlet UIView *adsViewContainer;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
/**
 *  我的信箱未读消息
 */
//@property (strong, nonatomic) IBOutlet UILabel *unreadLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UILabel *birthday;
@property (weak, nonatomic) IBOutlet UILabel *historyLab;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
/**
 *  我的信箱未读消息小红点
 */
//@property (strong, nonatomic) IBOutlet UIImageView *roundImageView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
/**
 *  我的 信箱按钮
 *
 */
//- (IBAction)mineMsgAction:(id)sender;
- (IBAction)historyAction:(id)sender;
/**
 *  妈妈任务
 */
//- (IBAction)taskAction:(id)sender;

/**
 *  纪录每周一练下点击查看的button
 */
@property (nonatomic,strong)UIButton *btn;
//点击每周一练下的小btn是否push
@property (nonatomic,assign)BOOL  ifPush;

@property (nonatomic,strong)NSMutableArray *allWeeksConclude;

@property (nonatomic,assign)NSInteger month;

@property (nonatomic,assign)BOOL ifPostFinished;
@end

@implementation MainPageViewController

- (NSMutableArray *)allWeeksConclude{
    if (!_allWeeksConclude) {
        self.allWeeksConclude = [NSMutableArray array];
    }
    return _allWeeksConclude;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.ifPostFinished = YES;
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
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMsgChanged:) name:XE_MSGINFO_CHANGED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCardChanged:) name:XE_CARD_CHANGED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTicketChanged:) name:XE_TICKET_CHANGED_NOTIFICATION object:nil];
    

  //获取每周一练线条的数据
    [self getOneWeekScrollviewInfomation];
    
    //获取上传照片完成情况
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(begainPostImage:) name:@"begainPostImage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endPostImage:) name:@"endPostImage" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)begainPostImage:(NSNotificationCenter *)sender{
    NSLog(@"收到开始上传通知");
    self.ifPostFinished = NO;
}
- (void)endPostImage:(NSNotificationCenter *)sender{
    NSLog(@"收到正在上传通知");
    
    self.ifPostFinished = YES;
}


- (void)getOneWeekScrollviewInfomation{
    __weak MainPageViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
//    [XEEngine shareInstance].serverPlatform = OnlinePlatform;
    NSString *userid = [XEEngine shareInstance].uid;
    if (!userid) {
        NSInteger index = 5;
        [self configureOneWeekScrollviewwith:index];
        
    }else{
        [[XEEngine shareInstance]getOneWeekScrollviewInfomationWith:userid tag:tag];
        [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
            /**
             *  获取失败信息
             */
            NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
            if (errorMsg) {
                [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
                return;
            }
            
            if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
                [XEProgressHUD AlertError:@"每周一练数据获取失败，请检查网络设置" At:weakSelf.view];

                return;
            }
            /**
             * 该用户的默认宝宝所处周数
             */
//            NSString *index = jsonRet[@"object"][@"defaultWeek"];
            /**
             *  后台包含了哪些周
             */
            
            NSMutableString *string = jsonRet[@"object"][@"cweeks"];
            NSLog(@"string === %@",string);
            if ([string isKindOfClass:[NSNull class]]) {
                [XEProgressHUD AlertError:@"每周一练数据获取失败，请检查网络设置" At:weakSelf.view];
                NSInteger indes = 5;
                [self configureOneWeekScrollviewwith:indes];
                return;
            }
            NSArray *array  = [string componentsSeparatedByString:@","];
            if (self.allWeeksConclude.count > 0) {
                [self.allWeeksConclude removeAllObjects];
            }
            for (NSString *string in array) {
                [self.allWeeksConclude addObject:string];
            }
            [self configureOneWeekScrollviewwith:self.allWeeksConclude.count];
            
        } tag:tag];
  
    }

}
/**
 *  每周一练没有用户的时候需要登录
 */
- (void)dengLu{
    if ([[XEEngine shareInstance] needUserLogin:nil]) {
        return;
    }
}
#pragma mark  计算每周一练应当滑倒哪一周
- (void)calculateWeeks{
    XEUserInfo *userInfo = [self getBabyUserInfo:0];
    NSLog(@"----------%@",userInfo.birthdayDate);
    self.birthday.text = [XEUIUtils dateDiscription1FromNowBk: userInfo.birthdayDate];
    NSDate* nowDate = [NSDate date];
    if (userInfo.birthdayDate == nil) {
        self.ifPush = NO;
        return ;
    }
    self.month = 0;
    int distance = [nowDate timeIntervalSinceDate:userInfo.birthdayDate];
    if (distance < 0) {
        distance = 0 ;
        self.month = 1;
    }
    NSLog(@"distance ===== %d",distance);
    //大于一年
    if (distance > 60*60*24*365) {
        self.month = distance/(60*60*24*7) + 1;
    }
    //大于一个月 包括小于一年
    if (distance < 60*60*24*365) {
        self.month = distance/(60*60*24*7) + 1;
    }
    //小于一个月
    if (distance < 60*60*24*30) {
        self.month =distance/(60*60*24*7)+ 1;
    }
    //小于一周
    if (distance < 60*60*24*7) {
        self.month = 1;
    }
    //小于一天
    if (distance < 60*60*24) {
        self.month = 1;
    }
    self.ifPush = NO;
    /**
     *  如果已经布局过了，在此处再次写一遍
     */
//    for (UIButton *button in self.oneWeekScrollView.subviews) {
//        if (button.tag == self.month ) {
//            self.btn = button;
//            [self AutomaticMoveSmallBtn:self.btn];
//        }
//    }
    
}
- (void)AutomaticMoveSmallBtn:(UIButton *)sender{
    if (self.btn == sender) {
        [self.btn setBackgroundImage:[UIImage imageNamed:@"oneSmallBtn"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.1 animations:^{
            self.btn.transform = CGAffineTransformMakeScale(1.5,1.5);
        }];
    }
    [self animationWithBtn];
}
#pragma mark 布局每周一练的scrollview小按钮
- (void)configureSmallBtnWith:(NSInteger) index{
    /**
     *  布局下面的横线
     */
    CGFloat flo = self.oneWeekScrollView.contentSize.width;
    UIScrollView *ScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(40, 32, flo- 60, 2)];
    ScrollView.userInteractionEnabled = NO;
    ScrollView.backgroundColor = [UIColor colorWithRed:18/255.0 green:169/255.0 blue:229/255.0 alpha:1];
    [self.oneWeekScrollView addSubview:ScrollView];
    for (int i = 0; i < index; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        XEUserInfo *userInfo = [self getBabyUserInfo:0];
        if (!userInfo.babyNick) {
            NSString *str = [NSString stringWithFormat:@"%d",i + 1];
            NSInteger inde = [str integerValue];
            button.tag = inde;
            button.frame = CGRectMake(i * (self.oneWeekScrollView.contentSize.width /index ) + 40, 23, 20, 20);

        }else{

            button.frame = CGRectMake(i * (self.oneWeekScrollView.contentSize.width /index ) + 40, 23, 20, 20);
            if (self.allWeeksConclude.count > 0) {
                 NSString *string = (NSString *)[self.allWeeksConclude objectAtIndex:i];
                button.tag = [string integerValue];
            }else{
                NSString *string = [NSString stringWithFormat:@"%d",i + 1];
                button.tag = [string integerValue];
            }
        }
        button.layer.cornerRadius = 10;
        button.backgroundColor = [UIColor colorWithRed:18/255.0 green:169/255.0 blue:229/255.0 alpha:1];
        [button addTarget:self action:@selector(touchSmallBtn:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(i * (self.oneWeekScrollView.contentSize.width /index ) + 20, 50, 60, 10)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:12];
        lable.text = [NSString stringWithFormat:@"第%ld周",(long)button.tag];
        [self.oneWeekScrollView addSubview:button];
        [self.oneWeekScrollView addSubview:lable];
    }
    /**
     *  虽然在视图将要出现的时候已经计算好的 ，但是scrollview还没布局好，所以移到这里进行移动
     */
//    for (UIButton *button in self.oneWeekScrollView.subviews) {
//        if (button.tag == self.month ) {
//            self.btn = button;
//            [self AutomaticMoveSmallBtn:self.btn];
//        }
//    }
//    XEUserInfo *userInfo = [self getBabyUserInfo:0];
//    if (!userInfo.babyNick) {
//        //用户不存在 scrollview居中显示
//        [self.oneWeekScrollView setContentOffset:CGPointMake(([UIScreen mainScreen].bounds.size.width - 60* 4)/2 - 60, 0)];
//    } else {
//        
//    }
}


#pragma mark 点击每周一练上scrollview上的小按钮

- (void)touchSmallBtn:(UIButton *)sender{
    self.ifPush = YES;
    if (!self.btn) {
        self.btn = sender;
        
        [self.btn setBackgroundImage:[UIImage imageNamed:@"oneSmallBtn"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.1 animations:^{
            self.btn.transform = CGAffineTransformMakeScale(1.5,1.5);
        }];
    }
    if (self.btn != sender) {
        [self.btn setBackgroundImage:nil forState:UIControlStateNormal];
        [UIView animateWithDuration:0.1 animations:^{
            self.btn.transform = CGAffineTransformMakeScale(1.0,1.0);
        }];
        self.btn = sender;
        [self.btn setBackgroundImage:[UIImage imageNamed:@"oneSmallBtn"] forState:UIControlStateNormal];

        [UIView animateWithDuration:0.1 animations:^{
            self.btn.transform = CGAffineTransformMakeScale(1.5,1.5);
        }];
    }else if (self.btn == sender){
        [self.btn setBackgroundImage:[UIImage imageNamed:@"oneSmallBtn"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.1 animations:^{
            self.btn.transform = CGAffineTransformMakeScale(1.5,1.5);
        }];
    }
    [self animationWithBtn];
//    XEUserInfo *userInfo = [self getBabyUserInfo:0];
//    if (!userInfo.babyNick) {
//        //用户不存在  不偏移
//        if ([[XEEngine shareInstance] needUserLogin:nil]) {
//            return;
//        }
//    } else {
//        
//        [self animationWithBtn];
//    }
}

#pragma mark 小按钮偏移到屏幕中间
- (void)animationWithBtn{
    [UIView animateWithDuration:0.3 animations:^{
        if (self.btn.tag > 2 && self.btn.tag <= 4) {
            [self.oneWeekScrollView setContentOffset:CGPointMake(self.btn.frame.origin.x - (SCREEN_WIDTH  / 2), 0)];
        }else if (self.btn.tag > 4 && self.btn.tag < self.allWeeksConclude.count - 3){
//            [self.oneWeekScrollView setContentOffset:CGPointMake( SCREEN_WIDTH + ( self.btn.frame.origin.x)- (SCREEN_WIDTH + SCREEN_WIDTH / 2)  , 0)];
            NSInteger inde =  self.oneWeekScrollView.contentOffset.x / SCREEN_WIDTH;
            [self.oneWeekScrollView setContentOffset:CGPointMake(inde * SCREEN_WIDTH + ( self.btn.frame.origin.x)- (SCREEN_WIDTH * inde + SCREEN_WIDTH / 2), 0)];

        }
    } completion:^(BOOL finished) {
        if (self.ifPush == NO) {
            
        }else{
            if ([[XEEngine shareInstance] needUserLogin:nil]) {
                    return;
            }else{
                
                NSLog(@"%ld",(long)self.btn.tag);
                EveryOneWeekController *everyOne= [[EveryOneWeekController alloc]init];
                everyOne.cweek = self.btn.tag;
                [self.navigationController pushViewController:everyOne animated:YES];
                self.ifPush = NO;
            }

        }

    }];
}



#pragma mark  配置每周一练的scrollview

- (void)configureOneWeekScrollviewwith:(NSInteger)index{
    
    NSLog(@"index =====  %ld",(long)index);
    self.oneWeekScrollView.showsHorizontalScrollIndicator = YES;
    self.oneWeekScrollView.directionalLockEnabled = YES;
    self.oneWeekScrollView.contentSize = CGSizeMake( 80 *index , 65);
    self.oneWeekScrollView.alwaysBounceHorizontal = YES;
    self.oneWeekScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [self configureSmallBtnWith:index];

}

- (BOOL)isVisitor{
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
    [self.avatarImageView sd_setImageWithURL:userInfo.babySmallAvatarUrl placeholderImage:[UIImage imageNamed:@"首页默认头像"]];
    self.avatarImageView.layer.cornerRadius = 8;
    self.avatarImageView.clipsToBounds = YES;
    if (!userInfo.babyNick) {
        self.nickName.text = @"暂无宝宝信息";
        self.historyLab.text = @"添加宝宝";
    }else{
        self.nickName.text = userInfo.babyNick;
        self.historyLab.text = @"历史评测成绩";
        [self getOneWeekScrollviewInfomation];

    }
    self.birthday.text = [XEUIUtils dateDiscription1FromNowBk: userInfo.birthdayDate];
    self.tableView.tableHeaderView = self.headView;
    ///底部加点间隙
//    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 19)];
//    footer.userInteractionEnabled = NO;
//    footer.backgroundColor = [UIColor whiteColor];
//    _tableView.tableFooterView = footer;
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
//            weakSelf.unreadLabel.text = [NSString stringWithFormat:@"%@条新消息",[[jsonRet objectForKey:@"object"] objectForKey:@"msgnum"]];
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
//            weakSelf.roundImageView.hidden = NO;
        }
        
        NSString *key = [NSString stringWithFormat:@"%@_%@", mineMsgCountKey, [XEEngine shareInstance].uid];
        [[NSUserDefaults standardUserDefaults] setInteger:count forKey:key];
//        weakSelf.unreadLabel.text = [NSString stringWithFormat:@"%d条新消息",count];
        
        _mallurl = [[jsonRet objectForKey:@"object"] objectForKey:@"mallurl"];
        if (![[[jsonRet objectForKey:@"object"] objectForKey:@"devices"] isEqual:[NSNull null]]) {
            _intelUrl = [[jsonRet objectForKey:@"object"] objectForKey:@"devices"][0];
            _parklonUrl = [[jsonRet objectForKey:@"object"] objectForKey:@"devices"][1];
        }
        
        int cardCount = [[jsonRet objectForKey:@"object"] intValueForKey:@"cpnum"];
        NSString *cardKey = [NSString stringWithFormat:@"%@_%@",mineCardCountKey,[XEEngine shareInstance].uid];
        [[NSUserDefaults standardUserDefaults] setInteger:cardCount forKey:cardKey];
        _cardNum = cardCount;
        
        int ticketCount = [[jsonRet objectForKey:@"object"] intValueForKey:@"ticketnum"];
        NSString *ticketKey = [NSString stringWithFormat:@"%@_%@",mineTicketCountKey,[XEEngine shareInstance].uid];
        [[NSUserDefaults standardUserDefaults] setInteger:ticketCount forKey:ticketKey];
        _ticketNum = ticketCount;
        
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
    [[NSNotificationCenter defaultCenter] postNotificationName:XE_MAIN_STOP_ADS_VIEW_NOTIFICATION object:[NSNumber numberWithBool:YES]];
    if (!_adsThemeArray.count) {
//        self.tableView.tableHeaderView = nil;
        self.adsViewContainer = nil;
        return;
    }
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
    
//    [self setTitle:@"晓儿"];
    self.titleNavImageView.hidden = NO;
    if (SCREEN_HEIGHT <= 568) {
        CGRect frame = self.containerView.frame;
        frame.origin.y = frame.origin.y ;
        self.containerView.frame = frame;
        
        frame = self.headView.frame;
        frame.size.height = 391;
        self.headView.frame = frame;
    }
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
    if (collectionView == self.collectionView) {
        return 4;
    }
    return 0;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == self.collectionView) {
        return 1;
    }
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView) {
        XECollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XECollectionViewCell" forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            //评测
            [cell.avatarImgView setImage:[UIImage imageNamed:@"home_evaluation_icon"]];
            cell.roundImgView.hidden = YES;
            cell.nameLabel.text = @"评测";
        } else if (indexPath.row == 1) {
            
            //卡券
            [cell.avatarImgView setImage:[UIImage imageNamed:@"home_rush_icon"]];

            cell.nameLabel.text = @"卡券";
            if (_cardNum > 0) {
                cell.roundImgView.hidden = NO;
            }else{
                cell.roundImgView.hidden = YES;
            }
            
        }else if (indexPath.row == 2){
            //抢票
            [cell.avatarImgView setImage:[UIImage imageNamed:@"home_card_icon"]];
            cell.nameLabel.text = @"抢票";
            if (_ticketNum > 0) {
                cell.roundImgView.hidden = NO;
            }else{
                cell.roundImgView.hidden = YES;
            }

        }else if (indexPath.row == 3){
            //咨询
            [cell.avatarImgView setImage:[UIImage imageNamed:@"资讯"]];
            cell.nameLabel.text = @"资讯";
        }
        return cell;

    }
    return nil;

//    XECollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XECollectionViewCell" forIndexPath:indexPath];
//    if(indexPath.row == 0){
//        [cell.avatarImgView setImage:[UIImage imageNamed:@"home_recipes_icon"]];
//        cell.roundImgView.hidden = YES;
//        [cell.nameLabel setText:@"食谱"];
//    }else if(indexPath.row == 1){
//        [cell.avatarImgView setImage:[UIImage imageNamed:@"home_nourish_icon"]];
//        cell.roundImgView.hidden = YES;
//        cell.nameLabel.text = @"养育";
//    }else if(indexPath.row == 2){
//        [cell.avatarImgView setImage:[UIImage imageNamed:@"home_evaluation_icon"]];
//        cell.roundImgView.hidden = YES;
//        cell.nameLabel.text = @"评测";
//    }else if(indexPath.row == 3){
//        [cell.avatarImgView setImage:[UIImage imageNamed:@"home_expert_icon"]];
//        cell.roundImgView.hidden = YES;
//        cell.nameLabel.text = @"专家";
//    }else if(indexPath.row == 4){
//        [cell.avatarImgView setImage:[UIImage imageNamed:@"home_activity_icon"]];
//        cell.roundImgView.hidden = YES;
//        cell.nameLabel.text = @"活动";
//    }else if(indexPath.row == 5){
//        [cell.avatarImgView setImage:[UIImage imageNamed:@"home_mall_icon"]];
//        cell.roundImgView.hidden = YES;
//        cell.nameLabel.text = @"商城";
//    }else if(indexPath.row == 6){
//        [cell.avatarImgView setImage:[UIImage imageNamed:@"home_rush_icon"]];
//        cell.nameLabel.text = @"抢票";
//        if (_ticketNum > 0) {
//            cell.roundImgView.hidden = NO;
//        }else{
//            cell.roundImgView.hidden = YES;
//        }
//    }else if(indexPath.row == 7){
//        [cell.avatarImgView setImage:[UIImage imageNamed:@"home_card_icon"]];
//        cell.nameLabel.text = @"卡券";
//        if (_cardNum > 0) {
//            cell.roundImgView.hidden = NO;
//        }else{
//            cell.roundImgView.hidden = YES;
//        }
//    }
    
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView) {
        return CGSizeMake((SCREEN_WIDTH - 120) / 4, (SCREEN_WIDTH - 120) / 4 + 17);

    }
    return CGSizeMake((SCREEN_WIDTH - 120) / 4, (SCREEN_WIDTH - 120) / 4 + 17);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView == self.collectionView) {
        return UIEdgeInsetsMake(20, 15, 15, 15);
    }
    return UIEdgeInsetsMake(20, 15, 15, 15);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
//            RecipesViewController *rVc = [[RecipesViewController alloc] init];
//            rVc.infoType = TYPE_EVALUATION;
//            [self.navigationController pushViewController:rVc animated:YES];
            AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate.mainTabViewController.tabBar selectIndex:1];
        }
            break;

        case 1:{
            
            if ([[XEEngine shareInstance] needUserLogin:@"登录或注册后才能查阅卡券"]) {
                return;
            }
            CardPackViewController *vc = [[CardPackViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];

        }
//            if ([[XEEngine shareInstance] needUserLogin:@"登录或注册后才能进行抢票"]) {
//            return;
//            }
            break;
        case 2:{

            TicketListViewController *vc = [[TicketListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
            break;
        }
        case 3:{
            InformationViewController *infomation = [[InformationViewController alloc]init];
            [self.navigationController pushViewController:infomation  animated:YES];
            break;
        }
        default:
           break;
    }

//    switch (indexPath.row) {
//        case 7:{
//            if ([[XEEngine shareInstance] needUserLogin:@"登录或注册后才能查阅卡券"]) {
//                return;
//            }
//            CardPackViewController *vc = [[CardPackViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
//        case 6:{
////            if ([[XEEngine shareInstance] needUserLogin:@"登录或注册后才能进行抢票"]) {
////                return;
////            }
//            TicketListViewController *vc = [[TicketListViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 5:{
//            id vc = [XELinkerHandler handleDealWithHref:_mallurl From:self.navigationController];
//            if (vc) {
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//            break;
//        }
//        case 4:{
//            ActivityViewController *vc = [[ActivityViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
//        case 3:{
//            ExpertListViewController *vc = [[ExpertListViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
//        case 2:{
////            RecipesViewController *rVc = [[RecipesViewController alloc] init];
////            rVc.infoType = TYPE_EVALUATION;
////            [self.navigationController pushViewController:rVc animated:YES];
//            AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//            [appDelegate.mainTabViewController.tabBar selectIndex:1];
//        }
//            break;
//        case 1:{
//            RecipesViewController *rVc = [[RecipesViewController alloc] init];
//            rVc.infoType = TYPE_NOURISH;
//            [self.navigationController pushViewController:rVc animated:YES];
//            break;
//        }
//        case 0:{
//            RecipesViewController *rVc = [[RecipesViewController alloc] init];
//            rVc.infoType = TYPE_RECIPES;
//            [self.navigationController pushViewController:rVc animated:YES];
//            break;
//        }
//        default:
//            break;
//    }
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView) {
        return YES;
    }
    return YES;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 23;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return 44;
    }
        return 180;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 23)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, view.frame.size.height)];
    indexLabel.backgroundColor = [UIColor clearColor];
    indexLabel.textColor = [UIColor lightGrayColor];
    indexLabel.font = [UIFont systemFontOfSize:13];
    if (section == 0) {
        indexLabel.text = @"育儿事项";
    }else if(section == 1){
        indexLabel.text = @"热销商品";
    }
    [view addSubview:indexLabel];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"MainTabCell";
        MainTabCell *cell;
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"教子有方";
            cell.subTitleLabel.text = @"迅速掌握育儿秘籍的第一课堂";
//            cell.titleLabel.text = @"妈妈必看";
//            cell.subTitleLabel.text = @"注意力不集中影响宝宝智力发育";
            cell.itemImageView.image = [UIImage imageNamed:@"home_attention_icon"];
            return cell;
            
        }else if (indexPath.row == 1) {
            cell.titleLabel.text = @"宝宝印像";
            cell.subTitleLabel.text = @"你负责拍，我负责印";
//            cell.titleLabel.text = @"好习惯指导和注意力指导";
//            cell.subTitleLabel.text = @"当宝宝的好习惯和注意力指导老师";
            cell.itemImageView.image = [UIImage imageNamed:@"babyImpressMain"];
            return cell;
        }
    }else{
        
        
        if (indexPath.row == 0) {
            static NSString *Identifier = @"acell";
            MainTabScrollCell *cell1 = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if (cell1 == nil) {
                NSArray* cells1 = [[NSBundle mainBundle] loadNibNamed:@"MainTabScrollCell" owner:nil options:nil];
                cell1 = [cells1 objectAtIndex:0];
            }
            [cell1 configureCollectionViewWith:@"123"];
            cell1.delegate = self;
            return cell1;
        }
        
        
    }

    return nil;
}


#warning 商品展示的代理的点击相应方法，未完善
- (void)pushToShopWith:(NSString *)string{
    NSLog(@"string === %@",string);

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
//        RecipesViewController *rVc = [[RecipesViewController alloc] init];
        if (indexPath.row == 0) {
            //原来的 妈妈必看
            MotherLookController *mother = [[MotherLookController alloc]init];
          [self.navigationController pushViewController:mother animated:YES];
            
            
            //        rVc.infoType = TYPE_ATTENTION;
            //        [self.navigationController pushViewController:rVc animated:YES];
            
        } else if (indexPath.row == 1) {
//            rVc.infoType = TYPE_ATTENTION;
//            [self.navigationController pushViewController:rVc animated:YES];
            //        rVc.infoType = TYPE_HABIT;
            //        [self.navigationController pushViewController:rVc animated:YES];
            
            //原来的 专注力和好习惯
//            focusAndHabitViewController *focus = [[focusAndHabitViewController alloc]init];
//            [self.navigationController pushViewController:focus animated:YES];
            if ([[XEEngine shareInstance] needUserLogin:@"登录或注册后才能预览"]) {
                return;
            }
            BabyImpressMainController *impress = [[BabyImpressMainController alloc]init];

            if (self.ifPostFinished == YES) {
                impress.ifPostFinished = self.ifPostFinished;
            }else{
                impress.ifPostFinished = self.ifPostFinished;
            }
            [self.navigationController pushViewController:impress animated:YES];
            
            
        }
    }else if (indexPath.section == 1){
        
        NSLog(@"跳转主页推荐商品");
        
    }
    
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.oneWeekScrollView) {
        NSLog(@"oneweek");
    }else{
        _isScrollViewDrag = YES;
        NSLog(@"yes");
    }
    
}

#pragma mark - ODRefreshControl
- (void)themeBeginPull:(ODRefreshControl *)refreshControl
{
    if (_isScrollViewDrag) {
//        [self performSelector:@selector(getThemeInfo) withObject:self afterDelay:0.5];
        [self getThemeInfo];
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
#pragma mark 在试图将要出现的时候 再次刷新宝宝的生日  防止更改之后之前现实的周没有改变
- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:XE_MAIN_SHOW_ADS_VIEW_NOTIFICATION object:[NSNumber numberWithBool:YES]];
    [super viewDidAppear:animated];
    //判断全局变量btn存在与否，存在的话不计算，不存在计算
//    if (self.btn) {
//        
//    }else{
//        [self calculateWeeks];
//    }
//    [self refreshUserInfoShow];


}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:XE_MAIN_STOP_ADS_VIEW_NOTIFICATION object:[NSNumber numberWithBool:YES]];
    [super viewDidDisappear:animated];
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



/**
 *  我的信箱按钮
 *
 */
//- (IBAction)mineMsgAction:(id)sender {
//    if ([self isVisitor]) {
//        [self showAlter];
//    }else{
//        MineMsgViewController *mmVc = [[MineMsgViewController alloc] init];
//        [self.navigationController pushViewController:mmVc animated:YES];
//    }
//}

- (IBAction)historyAction:(id)sender {
    if ([self isVisitor]) {
        [self showAlter];
    }else {
        XEUserInfo *userInfo = [self getBabyUserInfo:0];
        if (!userInfo.babyNick) {
            BabyProfileViewController *babyProfile = [[BabyProfileViewController alloc]init];
            [self.navigationController pushViewController:babyProfile animated:YES];
        }else{
            StageSelectViewController *vc = [[StageSelectViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }

    }
}
/**
 *  妈妈任务
 *
 */
//- (IBAction)taskAction:(id)sender {
//    if ([self isVisitor]) {
//        [self showAlter];
//    }else{
//        TaskViewController *tVc = [[TaskViewController alloc] init];
//        [self.navigationController pushViewController:tVc animated:YES];
//    }
//}

- (void)handleUserInfoChanged:(NSNotification *)notification{
    [self refreshUserInfoShow];
    [self.tableView reloadData];
}

//- (void)handleMsgChanged:(NSNotification *)notification{
//    NSString *key = [NSString stringWithFormat:@"%@_%@", mineMsgCountKey, [XEEngine shareInstance].uid];
//    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:key];
//    if (count > 0) {
//        self.roundImageView.hidden = NO;
//    }else {
//        self.roundImageView.hidden = YES;
//    }
//    self.unreadLabel.text = [NSString stringWithFormat:@"%d条新消息",(int)count];
//    [self.tableView reloadData];
//}

- (void)handleCardChanged:(NSNotification *)notification{
    NSString *key = [NSString stringWithFormat:@"%@_%@", mineCardCountKey, [XEEngine shareInstance].uid];
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    _cardNum = count;
    [self.collectionView reloadData];
}

- (void)handleTicketChanged:(NSNotification *)notification{
    NSString *key = [NSString stringWithFormat:@"%@_%@", mineTicketCountKey, [XEEngine shareInstance].uid];
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    _ticketNum = count;
    [self.collectionView reloadData];
}

#pragma mark -XETabBarControllerSubVcProtocol
- (void)tabBarController:(XETabBarViewController *)tabBarController reSelectVc:(UIViewController *)viewController {
    if (viewController == self) {
        [self.tableView setContentOffset:CGPointMake(0, 0 - self.tableView.contentInset.top) animated:NO];
    }
}

@end
