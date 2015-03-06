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
#import "XEBabyInfo.h"
#import "XEProgressHUD.h"
#import "ODRefreshControl.h"
#import "XELinkerHandler.h"
#import "StageSelectViewController.h"
#import "ReadyTestViewController.h"
#import "RecipesViewController.h"

@interface EvaluationViewController ()<XEScrollPageDelegate,UIScrollViewDelegate>{
    ODRefreshControl *_themeControl;
    XEScrollPage *scrollPageView;
    BOOL _isScrollViewDrag;
}

@property (strong, nonatomic) IBOutlet UIImageView *babyImageView;
@property (strong, nonatomic) IBOutlet UILabel *babyName;
@property (strong, nonatomic) IBOutlet UILabel *birthLabel;
@property (strong, nonatomic) IBOutlet UIButton *readybutton;
@property (strong, nonatomic) IBOutlet UILabel *stageLabel;
@property (strong, nonatomic) IBOutlet UIImageView *evaImageView;

@property (nonatomic, strong) XEUserInfo *userInfo;
@property (nonatomic, strong) NSMutableArray *adsThemeArray;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) XEBabyInfo *babyInfo;


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
    
    [self getEvaDataSource];
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT*1.1)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserInfoChanged:) name:XE_USERINFO_CHANGED_NOTIFICATION object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    
    [self setTitle:@"评测"];
//    if ([self isVisitor]) {
//        
//    }else{
//        
//    }
    [self setRightButtonWithImageName:@"expert_public_icon" selector:@selector(showAction)];
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

//-(XEUserInfo *)getBabyUserInfo:(NSInteger)index{
//    _userInfo = [XEEngine shareInstance].userInfo;
//    if (_userInfo.babys.count > index) {
//        XEUserInfo *babyUserInfo = [_userInfo.babys objectAtIndex:index];
//        return babyUserInfo;
//    }
//    return nil;
//}

- (void)refreshUserInfoShow
{
    if ([self isVisitor]) {
        [self.babyImageView setImage:[UIImage imageNamed:@"tmp_avatar_icon"]];
        self.babyImageView.layer.CornerRadius = 8;
    }else{
        self.babyImageView.clipsToBounds = YES;
        self.babyImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.babyImageView sd_setImageWithURL:_babyInfo.smallAvatarUrl placeholderImage:[UIImage imageNamed:@"topic_load_icon"]];
        self.babyImageView.layer.CornerRadius = 8;
        [self.evaImageView sd_setImageWithURL:_babyInfo.imgUrl placeholderImage:[UIImage imageNamed:@"recipes_load_icon"]];
        
        self.babyName.text = _babyInfo.babyName;
        self.stageLabel.text = [NSString stringWithFormat:@"第%d关键期", _babyInfo.stage];
        
        CGRect frame = self.babyName.frame;
        frame.size.width = [XECommonUtils widthWithText:self.babyName.text font:self.babyName.font lineBreakMode:self.babyName.lineBreakMode];
        self.babyName.frame = frame;
        
        frame = self.birthLabel.frame;
        frame.origin.x = self.babyName.frame.origin.x + self.babyName.frame.size.width + 5;
        self.birthLabel.frame = frame;
        self.birthLabel.text = _babyInfo.month;
    }
}

- (void)getEvaDataSource{
    __weak EvaluationViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getEvaInfoWithUid:[XEEngine shareInstance].uid tag:tag];
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
        NSLog(@"=================%@",jsonRet);
        NSDictionary *dic = [jsonRet objectForKey:@"object"];
        XEBabyInfo *babyInfo = [[XEBabyInfo alloc] init];
        [babyInfo setBabyInfoByJsonDic:dic];
        weakSelf.babyInfo = babyInfo;
        [weakSelf refreshUserInfoShow];
    }tag:tag];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isScrollViewDrag = YES;
}

#pragma mark - ODRefreshControl
- (void)themeBeginPull:(ODRefreshControl *)refreshControl
{
    if (_isScrollViewDrag) {
        [self performSelector:@selector(getEvaDataSource) withObject:self afterDelay:0.5];
    }
}

- (IBAction)criticalAction:(id)sender {
    StageSelectViewController *ssVc = [[StageSelectViewController alloc] init];
    [self.navigationController pushViewController:ssVc animated:YES];
}

- (IBAction)readyAction:(id)sender {
    ReadyTestViewController *rtVc = [[ReadyTestViewController alloc] init];
    [self.navigationController pushViewController:rtVc animated:YES];
}

- (void)handleUserInfoChanged:(NSNotification *)notification{
    [self refreshUserInfoShow];
}

- (void)showAction{
    RecipesViewController *rVc = [[RecipesViewController alloc] init];
    rVc.stage = _babyInfo.stage;
    rVc.infoType = TYPE_EVALUATION;
    rVc.bSpecific = YES;
    [self.navigationController pushViewController:rVc animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
