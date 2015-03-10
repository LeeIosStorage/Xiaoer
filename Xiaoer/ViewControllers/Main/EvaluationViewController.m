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

#define Tag_Stage_Previous   101
#define Tag_Stage_Next       102

@interface EvaluationViewController ()<XEScrollPageDelegate,UIScrollViewDelegate>{
    ODRefreshControl *_themeControl;
    XEScrollPage *scrollPageView;
    BOOL _isScrollViewDrag;
    BOOL _isReadMore;
    int stageIndex;
}

@property (strong, nonatomic) IBOutlet UIImageView *babyImageView;
@property (strong, nonatomic) IBOutlet UILabel *babyName;
@property (strong, nonatomic) IBOutlet UILabel *birthLabel;
@property (strong, nonatomic) IBOutlet UIButton *readybutton;
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
    stageIndex = 1;
    [self getEvaDataSource];

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
//    if ([self isVisitor]) {
//        
//    }else{
//        
//    }
    [self setRightButtonWithImageName:@"eva_recipes_icon" selector:@selector(showAction)];
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

- (void)refreshEvaWithStage:(int)stage
{
    if ([self isVisitor]) {
        [self.babyImageView setImage:[UIImage imageNamed:@"tmp_avatar_icon"]];
        self.babyImageView.layer.CornerRadius = 8;
    }else{
        self.babyImageView.clipsToBounds = YES;
        self.babyImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.babyImageView sd_setImageWithURL:_babyInfo.smallAvatarUrl placeholderImage:[UIImage imageNamed:@"topic_load_icon"]];
        self.babyImageView.layer.cornerRadius = self.babyImageView.frame.size.width/2;
        self.babyImageView.layer.masksToBounds = YES;
        self.babyImageView.clipsToBounds = YES;
        
        if (stageIndex == 0) {
            self.previousBtn.hidden = YES;
            self.stageLabel.text = [NSString stringWithFormat:@"距离上一关键期已过%d天",_babyInfo.preday];
            [self.evaImageView sd_setImageWithURL:_babyInfo.preimgUrl placeholderImage:[UIImage imageNamed:@"recipes_load_icon"]];
        }else if (stageIndex == 2) {
            self.nextBtn.hidden = YES;
            self.stageLabel.text = [NSString stringWithFormat:@"距离下一关键期还有%d天",_babyInfo.afterday];
            [self.evaImageView sd_setImageWithURL:_babyInfo.afterimgUrl placeholderImage:[UIImage imageNamed:@"recipes_load_icon"]];
        }else{
            self.nextBtn.hidden = NO;
            self.previousBtn.hidden = NO;
            self.stageLabel.text = [NSString stringWithFormat:@"第%d关键期",_babyInfo.stage];
            [self.evaImageView sd_setImageWithURL:_babyInfo.imgUrl placeholderImage:[UIImage imageNamed:@"recipes_load_icon"]];
        }
        self.babyName.text = _babyInfo.babyName;
        
        CGRect frame = self.babyName.frame;
        frame.size.width = [XECommonUtils widthWithText:self.babyName.text font:self.babyName.font lineBreakMode:self.babyName.lineBreakMode];
        self.babyName.frame = frame;
        
        frame = self.birthLabel.frame;
        frame.origin.x = self.babyName.frame.origin.x + self.babyName.frame.size.width + 5;
        self.birthLabel.frame = frame;
        self.birthLabel.text = _babyInfo.month;
        
        self.contextLabel.text = _babyInfo.content;
        [self refreshLayout];
    }
}

- (void)refreshLayout{
    CGRect frame = self.contextLabel.frame;
    CGSize textSize = [XECommonUtils sizeWithText:self.contextLabel.text font:self.contextLabel.font width:self.contextLabel.frame.size.width];
    NSLog(@"==============%f",textSize.height);
    frame = self.contextLabel.frame;
    frame.origin.y = 10;
    if (_isReadMore) {
        frame.size.height = textSize.height;
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
    frame.size.height = self.evaImageView.frame.origin.y + self.evaImageView.frame.size.height + 5;
    self.imageConView.frame = frame;

    frame = self.contextConView.frame;
    frame.size.height = self.imageConView.frame.origin.y + self.imageConView.frame.size.height + 5;
    self.contextConView.frame = frame;
    
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,self.headView.frame.size.height + self.contextConView.frame.size.height - 200)];
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
        NSDictionary *dic = [jsonRet objectForKey:@"object"];
        XEBabyInfo *babyInfo = [[XEBabyInfo alloc] init];
        [babyInfo setBabyInfoByJsonDic:dic];
        weakSelf.babyInfo = babyInfo;
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
        [self performSelector:@selector(getEvaDataSource) withObject:self afterDelay:0.5];
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
    rtVc.stageIndex = _babyInfo.stage + (stageIndex-1);
    rtVc.babyInfo = _babyInfo;
    [self.navigationController pushViewController:rtVc animated:YES];
}

- (void)handleUserInfoChanged:(NSNotification *)notification{
    [self refreshEvaWithStage:1];
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
