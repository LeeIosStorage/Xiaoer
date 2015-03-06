//
//  EvaluationViewController.m
//  Xiaoer
//
//  Created by KID on 14/12/30.
//
//

#import "EvaluationViewController.h"
#import "XETabBarViewController.h"
#import "XEEngine.h"
#import "XEScrollPage.h"
#import "UIImageView+WebCache.h"
#import "XEThemeInfo.h"
#import "XEProgressHUD.h"
#import "ODRefreshControl.h"
#import "XELinkerHandler.h"

@interface EvaluationViewController ()<XEScrollPageDelegate,UIScrollViewDelegate>{
    ODRefreshControl *_themeControl;
    XEScrollPage *scrollPageView;
    BOOL _isScrollViewDrag;
}

@property (strong, nonatomic) IBOutlet UIImageView *babyImageView;
@property (strong, nonatomic) IBOutlet UILabel *babyName;
@property (strong, nonatomic) IBOutlet UILabel *birthLabel;
@property (strong, nonatomic) IBOutlet UIButton *readybutton;

@property (nonatomic, strong) XEUserInfo *userInfo;
@property (nonatomic, strong) NSMutableArray *adsThemeArray;
@property (nonatomic, strong) IBOutlet UIView *adsViewContainer;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


- (IBAction)criticalAction:(id)sender;
- (IBAction)readyAction:(id)sender;

@end

@implementation EvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self refreshUserInfoShow];
    
    _themeControl = [[ODRefreshControl alloc] initInScrollView:self.scrollView];
    [_themeControl addTarget:self action:@selector(themeBeginPull:) forControlEvents:UIControlEventValueChanged];
    
//    [self getCacheThemeInfo];
//    [self getThemeInfo];
    [self getEvaDataSource];
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT*1.2)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    
    [self setTitle:@"评测"];
}

- (UINavigationController *)navigationController{
    if ([super navigationController]) {
        return [super navigationController];
    }
    return self.tabController.navigationController;
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

- (void)refreshUserInfoShow
{
    if ([self isVisitor]) {
        [self.babyImageView setImage:[UIImage imageNamed:@"tmp_avatar_icon"]];
        self.babyImageView.layer.CornerRadius = 8;
    }else{
        XEUserInfo *userInfo = [self getBabyUserInfo:0];
        self.babyImageView.clipsToBounds = YES;
        self.babyImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.babyImageView sd_setImageWithURL:_userInfo.bgImgUrl placeholderImage:[UIImage imageNamed:@"user_default_bg_img"]];
        [self.babyImageView sd_setImageWithURL:_userInfo.smallAvatarUrl placeholderImage:[UIImage imageNamed:@"topic_load_icon"]];
        self.babyImageView.layer.CornerRadius = 8;
        NSString *babyNick = userInfo.babyNick;
        if (babyNick.length == 0) {
            babyNick = @"未设置宝宝信息";
        }
        self.babyName.text = babyNick;
        self.birthLabel.text = [XEUIUtils dateDiscription1FromNowBk: userInfo.birthdayDate];
    }
}

- (void)getEvaDataSource{
    __weak EvaluationViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getEvaInfoWithUid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//        _isScrollViewDrag = NO;
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
//            [_themeControl endRefreshing:NO];
            return;
        }
        
        NSLog(@"=================%@",jsonRet);
//        [_themeControl endRefreshing:YES];
//        
//        [weakSelf.adsThemeArray removeAllObjects];
//        //解析数据
//        weakSelf.adsThemeArray = [NSMutableArray array];
//        
//        NSArray *themeDicArray = [jsonRet arrayObjectForKey:@"object"];
//        for (NSDictionary *dic  in themeDicArray) {
//            if (![dic isKindOfClass:[NSDictionary class]]) {
//                continue;
//            }
//            
//            XEThemeInfo *theme = [[XEThemeInfo alloc] init];
//            [theme setThemeInfoByDic:dic];
//            [weakSelf.adsThemeArray addObject:theme];
//        }
//        
//        //刷新广告
//        if (weakSelf.adsThemeArray.count) {
//            [weakSelf refreshAdsScrollView];
//        }
    }tag:tag];
}


-(void)getCacheThemeInfo {
    __weak EvaluationViewController *weakSelf = self;
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
    __weak EvaluationViewController *weakSelf = self;
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

- (void)refreshAdsScrollView{
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
    
    id vc = [XELinkerHandler handleDealWithHref:theme.themeActionUrl From:self.navigationController];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)criticalAction:(id)sender {
    
}

- (IBAction)readyAction:(id)sender {
    
}

@end
