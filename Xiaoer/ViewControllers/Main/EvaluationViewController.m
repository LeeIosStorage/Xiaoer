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
#import "WelcomeViewController.h"
#import "XENavigationController.h"
#import "PerfectInfoViewController.h"
#import "ExpertListViewController.h"

#define Tag_Stage_Previous   101
#define Tag_Stage_Next       102

@interface EvaluationViewController ()<XEScrollPageDelegate,UIScrollViewDelegate>{
    ODRefreshControl *_themeControl;
    XEScrollPage *scrollPageView;
    BOOL _isScrollViewDrag;
    BOOL _isReadMore;
    int stageIndex;
}

@property (strong, nonatomic) IBOutlet UIView *hideView;
@property (strong, nonatomic) IBOutlet UIImageView *hideImageView;
@property (strong, nonatomic) IBOutlet UIButton *hideButton;
@property (strong, nonatomic) IBOutlet UIImageView *hideBabyImage;
@property (strong, nonatomic) IBOutlet UILabel *hideNamelabel;

@property (strong, nonatomic) IBOutlet UIImageView *babyImageView;
@property (strong, nonatomic) IBOutlet UILabel *babyName;
@property (strong, nonatomic) IBOutlet UILabel *birthLabel;
@property (strong, nonatomic) IBOutlet UIButton *readyButton;
@property (strong, nonatomic) IBOutlet UILabel *stageLabel;
@property (strong, nonatomic) IBOutlet UIImageView *evaImageView;
@property (strong, nonatomic) IBOutlet UILabel *contextLabel;
@property (strong, nonatomic) IBOutlet UIButton *previousBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UIButton *moreBtn;
@property (strong, nonatomic) IBOutlet UIView *contextConView;
@property (strong, nonatomic) IBOutlet UIView *imageConView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIView *noticeView;

@property (nonatomic, strong) XEUserInfo *userInfo;
@property (nonatomic, strong) NSMutableArray *adsThemeArray;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) XEBabyInfo *babyInfo;

- (IBAction)criticalAction:(id)sender;
- (IBAction)readyAction:(id)sender;
- (IBAction)bottomAction:(id)sender;

@end

@implementation EvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    stageIndex = 0;
    if (![self isVisitor]) {
        [self getCacheEvaDataSource];
        [self getEvaDataSource];
    }
    [self refreshEvaWithStage:stageIndex];
    
    _themeControl = [[ODRefreshControl alloc] initInScrollView:self.scrollView];
    [_themeControl addTarget:self action:@selector(themeBeginPull:) forControlEvents:UIControlEventValueChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserInfoChanged:) name:XE_USERINFO_CHANGED_NOTIFICATION object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    
    [self setTitle:@"评测"];
    [self setRightButtonWithImageName:@"eva_recipes_icon" selector:@selector(showAction)];
    [self setLeftButtonWithTitle:@"测评师" selector:@selector(nurserAction)];
    if ([self isVisitor]) {
        [self.titleNavBarRightBtn setHidden:YES];
    }else{
        [self.titleNavBarRightBtn setHidden:NO];
    }
    
}

- (UINavigationController *)navigationController{
    if ([super navigationController]) {
        return [super navigationController];
    }
    return self.tabController.navigationController;
}

- (BOOL)isVisitor{
    if (![[XEEngine shareInstance] hasAccoutLoggedin]) {
        return YES;
    }
    return NO;
}

- (void)refreshEvaWithStage:(int)stage
{
    if ([self isVisitor] || !self.babyInfo.babyId) {
        self.hideView.hidden = NO;
        self.scrollView.hidden = YES;
        [self.hideImageView setImage:[UIImage imageNamed:@"eva_placeholder_img"]];
        [self.hideBabyImage setImage:[UIImage imageNamed:@"topic_load_icon"]];
        self.hideBabyImage.layer.cornerRadius = self.babyImageView.frame.size.width/2;
        self.hideBabyImage.layer.masksToBounds = YES;
        self.hideBabyImage.clipsToBounds = YES;
        if ([self isVisitor]) {
            self.hideNamelabel.text = @"你还没有登录";
            [self.hideButton setTitle:@"登录或注册" forState:UIControlStateNormal];
        }else{
            self.hideNamelabel.text = @"你还没有宝宝";
            [self.hideButton setTitle:@"完善资料" forState:UIControlStateNormal];
        }
//        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,self.hideView.frame.size.height + self.contextConView.frame.size.height + self.footerView.frame.size.height + 400)];
    }else{
        self.hideView.hidden = YES;
        self.scrollView.hidden = NO;
        self.babyImageView.clipsToBounds = YES;
        self.babyImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.babyImageView sd_setImageWithURL:_babyInfo.smallAvatarUrl placeholderImage:[UIImage imageNamed:@"topic_load_icon"]];
        self.babyImageView.layer.cornerRadius = self.babyImageView.frame.size.width/2;
        self.babyImageView.layer.masksToBounds = YES;
        self.babyImageView.clipsToBounds = YES;
            
        if (stageIndex == -1) {
            self.nextBtn.hidden = NO;
            self.previousBtn.hidden = YES;
            self.contextLabel.text = _babyInfo.precontent;
            self.stageLabel.text = [NSString stringWithFormat:@"距离上一关键期已过%d天",_babyInfo.preday];
            [self.evaImageView sd_setImageWithURL:_babyInfo.preimgUrl placeholderImage:[UIImage imageNamed:@"eva_placeholder_img"]];
        }else if (stageIndex == 1) {
            self.nextBtn.hidden = YES;
            self.previousBtn.hidden = NO;
            self.contextLabel.text = _babyInfo.aftercontent;
            self.stageLabel.text = [NSString stringWithFormat:@"距离下一关键期还有%d天",_babyInfo.afterday];
            [self.evaImageView sd_setImageWithURL:_babyInfo.afterimgUrl placeholderImage:[UIImage imageNamed:@"eva_placeholder_img"]];
        }else{
            if (self.babyInfo.stage == 1) {
                self.nextBtn.hidden = NO;
                self.previousBtn.hidden = YES;
            }else if (self.babyInfo.stage == 8){
                self.nextBtn.hidden = YES;
                self.previousBtn.hidden = NO;
            }else{
                self.nextBtn.hidden = NO;
                self.previousBtn.hidden = NO;
            }
            self.contextLabel.text = _babyInfo.content;
            self.stageLabel.text = [NSString stringWithFormat:@"第%d关键期",_babyInfo.stage];
            [self.evaImageView sd_setImageWithURL:_babyInfo.imgUrl placeholderImage:[UIImage imageNamed:@"eva_placeholder_img"]];
        }
        self.babyName.text = _babyInfo.babyName;
            
        CGRect frame = self.babyName.frame;
        CGFloat textWidth = [XECommonUtils widthWithText:self.babyName.text font:self.babyName.font lineBreakMode:self.babyName.lineBreakMode];
        if (textWidth > 80) {
            textWidth = 80;
        }
        frame.size.width = textWidth;
        self.babyName.frame = frame;
            
        frame = self.birthLabel.frame;
        frame.origin.x = self.babyName.frame.origin.x + self.babyName.frame.size.width + 5;
        self.birthLabel.frame = frame;
        self.birthLabel.text = _babyInfo.month;
        [self refreshLayout];
    }
}

//重新计算各view高度位置
- (void)refreshLayout{
    CGRect frame = self.contextLabel.frame;
    CGSize textSize = [XECommonUtils sizeWithText:self.contextLabel.text font:self.contextLabel.font width:self.contextLabel.frame.size.width];
    frame = self.contextLabel.frame;
    frame.origin.y = 10;
    if (_isReadMore) {
        frame.size.height = textSize.height;
        if (textSize.height > 75) {
            self.moreBtn.hidden = NO;
        }else {
            self.moreBtn.hidden = YES;
        }
    }else{
        if (textSize.height > 75) {
            frame.size.height = 75;
            self.moreBtn.hidden = NO;
        }else{
            frame.size.height = textSize.height;
            self.moreBtn.hidden = YES;
        }
    }
    self.contextLabel.frame = frame;
    
    frame = self.moreBtn.frame;
    frame.origin.y = self.contextLabel.frame.origin.y + self.contextLabel.frame.size.height + 5;
    self.moreBtn.frame = frame;
        
    frame = self.evaImageView.frame;
    frame.origin.y = self.moreBtn.frame.origin.y + self.moreBtn.frame.size.height + 5;
    self.evaImageView.frame = frame;
    
    frame = self.imageConView.frame;
    frame.origin.y = self.evaImageView.frame.origin.y + self.evaImageView.frame.size.height + 5;
    self.imageConView.frame = frame;
    
    if ((self.babyInfo.aStatus && stageIndex == 1) || (self.babyInfo.status && stageIndex == 0)|| (self.babyInfo.pStatus && stageIndex == -1)) {
        self.readyButton.enabled = NO;
        [self.readyButton setTitle:@"敬请期待" forState:UIControlStateNormal];
        self.noticeView.hidden = NO;
        frame = self.noticeView.frame;
        frame.origin.y = self.imageConView.frame.origin.y + self.imageConView.frame.size.height + 5;
        self.noticeView.frame = frame;
        
        frame = self.contextConView.frame;
        frame.size.height = self.noticeView.frame.origin.y + self.noticeView.frame.size.height;
        self.contextConView.frame = frame;
    }else{
        self.noticeView.hidden = YES;
        self.readyButton.enabled = YES;
        [self.readyButton setTitle:@"进入评测" forState:UIControlStateNormal];
        frame = self.contextConView.frame;
        frame.size.height = self.imageConView.frame.origin.y + self.imageConView.frame.size.height;
        self.contextConView.frame = frame;
    }

    frame = self.footerView.frame;
    frame.origin.y = self.contextConView.frame.origin.y + self.contextConView.frame.size.height + (SCREEN_HEIGHT>568?SCREEN_HEIGHT/480*80:SCREEN_HEIGHT/480*10);
    self.footerView.frame = frame;
    
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,self.headView.frame.size.height + self.contextConView.frame.size.height + self.footerView.frame.size.height + (SCREEN_HEIGHT>568?SCREEN_HEIGHT/480*110:SCREEN_HEIGHT/480*10))];
}

-(void)getCacheEvaDataSource {
    __weak EvaluationViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getEvaInfoWithUid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            //解析数据
            NSDictionary *dic = [jsonRet objectForKey:@"object"];
            XEBabyInfo *babyInfo = [[XEBabyInfo alloc] init];
            [babyInfo setBabyInfoByJsonDic:dic];
            weakSelf.babyInfo = babyInfo;
            [weakSelf refreshEvaWithStage:stageIndex];
        }
    }];
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
            
            //只在当前页面提示
            if ([self.navigationController.visibleViewController isKindOfClass:[XETabBarViewController class]]) {
                XETabBarViewController *tabBarViewController = (XETabBarViewController *)self.navigationController.visibleViewController;
                UIViewController *currentVc = tabBarViewController.selectedViewController;
                if ([currentVc isKindOfClass:[EvaluationViewController class]]) {
                    [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
                }
            }
            
            [weakSelf refreshEvaWithStage:stageIndex];
            [_themeControl endRefreshing:NO];
            return;
        }
        [_themeControl endRefreshing:YES];
        NSDictionary *dic = [jsonRet objectForKey:@"object"];
        XEBabyInfo *babyInfo = [[XEBabyInfo alloc] init];
        [babyInfo setBabyInfoByJsonDic:dic];
        weakSelf.babyInfo = babyInfo;
        if (babyInfo) {
            self.hideView.hidden = YES;
            self.scrollView.hidden = NO;
        }
        [weakSelf refreshEvaWithStage:stageIndex];
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
        stageIndex = 1;
        //[self performSelector:@selector(getEvaDataSource) withObject:self afterDelay:0.5];
        [self getEvaDataSource];
    }
}

- (IBAction)readMoreAction:(id)sender {
    _isReadMore = !_isReadMore;
    if (_isReadMore) {
        [_moreBtn setTitle:@"收起" forState:UIControlStateNormal];
    }else{
        [_moreBtn setTitle:@"展开" forState:UIControlStateNormal];
    }
    [self refreshLayout];
}

- (IBAction)changeStageAction:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == Tag_Stage_Previous) {
        stageIndex--;
    }else if(btn.tag == Tag_Stage_Next){
        stageIndex++;
    }
    [self refreshEvaWithStage:stageIndex];
}

- (IBAction)criticalAction:(id)sender {
    StageSelectViewController *ssVc = [[StageSelectViewController alloc] init];
    [self.navigationController pushViewController:ssVc animated:YES];
}

- (IBAction)readyAction:(id)sender {
    ReadyTestViewController *rtVc = [[ReadyTestViewController alloc] init];
    rtVc.stageIndex = _babyInfo.stage + stageIndex;
    rtVc.babyInfo = _babyInfo;
    [self.navigationController pushViewController:rtVc animated:YES];
}

- (IBAction)bottomAction:(id)sender {
    if ([self isVisitor]) {
        WelcomeViewController *welcomeVc = [[WelcomeViewController alloc] init];
        welcomeVc.showBackButton = YES;
        XENavigationController* navigationController = [[XENavigationController alloc] initWithRootViewController:welcomeVc];
        navigationController.navigationBarHidden = YES;
        [self.navigationController presentViewController:navigationController animated:YES completion:nil];
    }else{
        PerfectInfoViewController *pVc = [[PerfectInfoViewController alloc] init];
        pVc.userInfo = [XEEngine shareInstance].userInfo;
        [self.navigationController pushViewController:pVc animated:YES];
    }
}

- (void)handleUserInfoChanged:(NSNotification *)notification{
    [XEEngine shareInstance].bVisitor = NO;
    [self.titleNavBarRightBtn setHidden:NO];
    [self getEvaDataSource];
}

- (void)showAction{
    RecipesViewController *rVc = [[RecipesViewController alloc] init];
    if (!_babyInfo) {
        rVc.stage = 1;
    }
    if (_babyInfo.stage > 0) {
        rVc.stage = _babyInfo.stage;
    }
    rVc.infoType = TYPE_EVALUATION;
    rVc.bSpecific = YES;
    [self.navigationController pushViewController:rVc animated:YES];
}

- (void)nurserAction{
    ExpertListViewController *elVc = [[ExpertListViewController alloc] init];
    elVc.vcType = VcType_Nurser;
    [self.navigationController pushViewController:elVc animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
