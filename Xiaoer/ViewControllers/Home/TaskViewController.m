//
//  TaskViewController.m
//  Xiaoer
//
//  Created by KID on 15/2/12.
//
//

#import "TaskViewController.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XETrainInfo.h"
#import "XELinkerHandler.h"
#import "XEActionSheet.h"
#import "XEAlertView.h"
#import "AppDelegate.h"

#define Train_Cat_Pre_Tag    101
#define Train_Cat_Nex_Tag    102

@interface TaskViewController ()<UIScrollViewDelegate>{
    BOOL _isData;
    NSInteger catIndex;
}

@property (strong, nonatomic) NSMutableDictionary *trainDic;
@property (strong, nonatomic) IBOutlet UIButton *startBtn;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreTitleLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *containerScroll;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIImageView *trainImage;

@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    catIndex = 1;
    [self initScrollPage];
    [self getCacheTrainInfo];
    [self getTrainInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    [self setTitle:@"妈妈任务"];
    [self.titleNavBar setHidden:YES];
}

-(void)getCacheTrainInfo {
    __weak TaskViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getTrainIngosWithUid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            //解析数据
            weakSelf.trainDic = [NSMutableDictionary dictionary];
            
            NSArray *themeDicArray = [jsonRet arrayObjectForKey:@"object"];
            for (NSDictionary *dic in themeDicArray) {
                if (![dic isKindOfClass:[NSDictionary class]]) {
                    continue;
                }
                XETrainInfo *trainInfo = [[XETrainInfo alloc] init];
                [trainInfo setTrainInfoByJsonDic:dic];
                [weakSelf.trainDic setObject:trainInfo forKey:trainInfo.cat];
            }
            
            if (weakSelf.trainDic.count) {
                _isData = YES;
                [weakSelf refreshUIWithData:_isData AndIndex:0];
            }
        }
    }];
}

- (void)getTrainInfo{
    __weak TaskViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getTrainIngosWithUid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            if ([errorMsg isEqualToString:@"暂无评测结果信息"]) {
                [weakSelf refreshUIWithData:_isData AndIndex:0];
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        
        [weakSelf.trainDic removeAllObjects];
        //解析数据
        weakSelf.trainDic = [NSMutableDictionary dictionary];
        
        NSArray *themeDicArray = [jsonRet arrayObjectForKey:@"object"];
        for (NSDictionary *dic in themeDicArray) {
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            XETrainInfo *trainInfo = [[XETrainInfo alloc] init];
            [trainInfo setTrainInfoByJsonDic:dic];
            [weakSelf.trainDic setObject:trainInfo forKey:trainInfo.cat];
        }
        
        if (weakSelf.trainDic.count) {
            _isData = YES;
            [weakSelf refreshUIWithData:_isData AndIndex:0];
        }
    }tag:tag];
}

- (void)refreshUIWithData:(BOOL)bData AndIndex:(NSInteger)index{
    if (bData) {
        XETrainInfo *trainInfo = [[XETrainInfo alloc] init];
        if (self.trainDic) {
            trainInfo = [self.trainDic objectForKey:[NSString stringWithFormat:@"%d",(int)catIndex]];
            if (trainInfo) {
                _scoreLabel.text = [trainInfo.resultsInfo[index] objectForKey:@"score"];
                [_startBtn setTitle:@"现在开始" forState:UIControlStateNormal];
                _scoreTitleLabel.text = @"最近一次评测得分";
                _startBtn.enabled = YES;
            }else {
                [_startBtn setTitle:@"开始测评" forState:UIControlStateNormal];
                _scoreTitleLabel.text = @"暂无评测成绩";
                _scoreLabel.text = @"";
            }
        }
    }else {
        [_startBtn setTitle:@"开始测评" forState:UIControlStateNormal];
//        _scoreLabel.text = @"";
        _scoreTitleLabel.text = @"暂无评测成绩";
    }
}

- (IBAction)startTrainAction:(id)sender {
    XETrainInfo *trainInfo = [[XETrainInfo alloc] init];
    trainInfo = [self.trainDic objectForKey:[NSString stringWithFormat:@"%d",(int)catIndex]];
    if (trainInfo) {
        id vc = [XELinkerHandler handleDealWithHref:[NSString stringWithFormat:@"%@/train/cat/%@/%@/%@",[XEEngine shareInstance].baseUrl,trainInfo.stage,trainInfo.cat,_scoreLabel.text] From:self.navigationController];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.mainTabViewController.tabBar selectIndex:1];
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeAction:(id)sender {
    UIButton *btn = sender;
    NSInteger pageNum = _pageControl.currentPage;
    if (btn.tag == Train_Cat_Pre_Tag) {
        if (pageNum > 0) {
            pageNum--;
        }
    }else if(btn.tag == Train_Cat_Nex_Tag){
        pageNum++;
    }
    CGSize viewSize = _containerScroll.frame.size;
    CGFloat pageWidth  = _containerScroll.frame.size.width;
    CGFloat pageHeigth = _containerScroll.frame.size.height;
    if (pageNum == 0) {
        [_containerScroll scrollRectToVisible:CGRectMake(pageWidth * 6, 0, pageWidth, pageHeigth) animated:NO];
        _pageControl.currentPage = 5;
        catIndex = 6;
    }else if(pageNum == 6){
        [_containerScroll scrollRectToVisible:CGRectMake(pageWidth, 0, pageWidth, pageHeigth) animated:NO];
        _pageControl.currentPage = 0;
        catIndex = 1;
    }else{
        _pageControl.currentPage = pageNum;
        catIndex = _pageControl.currentPage + 1;
        CGRect rect = CGRectMake(catIndex*viewSize.width, 0, viewSize.width, viewSize.height);
        [_containerScroll scrollRectToVisible:rect animated:YES];
    }

    [self setImagesWithIndex:_pageControl.currentPage];
    [self refreshUIWithData:YES AndIndex:catIndex];
}

- (void)initScrollPage{
    [self setContentInsetForScrollView:_containerScroll inset:UIEdgeInsetsMake(0, 0, 0, 0)];
    CGRect frame = [UIScreen mainScreen].bounds;
    _containerScroll.frame = frame;
    [self addSubviewToScrollView:_containerScroll withIndex:5];
    for (int i = 0; i < 6; i++) {
        [self addSubviewToScrollView:_containerScroll withIndex:i];
    }
    [self addSubviewToScrollView:_containerScroll withIndex:0];
    //多算两屏,默认第二屏
    _containerScroll.ContentSize = CGSizeMake(8*frame.size.width,frame.size.height);
    [_containerScroll scrollRectToVisible:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height) animated:NO];
    //设置pageControl属性
    _pageControl.numberOfPages = 6;
}

- (void)setBackGroundColorWithIndex:(NSInteger)index atView:(UIView *)view{
    switch (index) {
        case 0:
            view.backgroundColor = [XEUIUtils colorWithHex:0xf0ac5b alpha:1.0];
            break;
        case 1:
            view.backgroundColor = [XEUIUtils colorWithHex:0x8568ab alpha:1.0];
            break;
        case 2:
            view.backgroundColor = [XEUIUtils colorWithHex:0xfbca5a alpha:1.0];
            break;
        case 3:
            view.backgroundColor = [XEUIUtils colorWithHex:0x6cc5e8 alpha:1.0];
            break;
        case 4:
            view.backgroundColor = [XEUIUtils colorWithHex:0xeb7270 alpha:1.0];
            break;
        case 5:
            view.backgroundColor = [XEUIUtils colorWithHex:0x78bf54 alpha:1.0];
            break;
        default:
            break;
    }
}

- (void)setImagesWithIndex:(NSInteger)index{
    switch (index) {
        case 0:
            [_startBtn setBackgroundImage:[UIImage imageNamed:@"task_start_btn1_bg"] forState:UIControlStateNormal];
            [_trainImage setImage:[UIImage imageNamed:@"task_sport_icon"]];
            break;
        case 1:
            [_startBtn setBackgroundImage:[UIImage imageNamed:@"task_start_btn2_bg"] forState:UIControlStateNormal];
            [_trainImage setImage:[UIImage imageNamed:@"task_social_icon"]];
            break;
        case 2:
            [_startBtn setBackgroundImage:[UIImage imageNamed:@"task_start_btn3_bg"] forState:UIControlStateNormal];
            [_trainImage setImage:[UIImage imageNamed:@"task_adapt_icon"]];
            break;
        case 3:
            [_startBtn setBackgroundImage:[UIImage imageNamed:@"task_start_btn4_bg"] forState:UIControlStateNormal];
            [_trainImage setImage:[UIImage imageNamed:@"task_fine_icon"]];
            break;
        case 4:
            [_startBtn setBackgroundImage:[UIImage imageNamed:@"task_start_btn5_bg"] forState:UIControlStateNormal];
            [_trainImage setImage:[UIImage imageNamed:@"task_speak_icon"]];
            break;
        case 5:
            [_startBtn setBackgroundImage:[UIImage imageNamed:@"task_start_btn6_bg"] forState:UIControlStateNormal];
            [_trainImage setImage:[UIImage imageNamed:@"task_attention_icon"]];
            break;
        default:
            break;
    }
}

- (void)addSubviewToScrollView:(UIScrollView *)scrollView withIndex:(NSInteger)index{
    CGRect frame = scrollView.frame;
    
    CGRect vFrame = frame;
    vFrame.origin.x = (index+1)*vFrame.size.width;
    
    UIView *view = [[UIView alloc] init];
    
    view.frame = vFrame;
    view.contentMode = UIViewContentModeScaleAspectFill;

    [scrollView addSubview:view];
    
    [self setBackGroundColorWithIndex:index atView:view];
}

#pragma mark -- ads scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (![scrollView isEqual:_containerScroll]) {
        return;
    }
    
    CGFloat pageWidth  = _containerScroll.frame.size.width;
    CGFloat pageHeigth = _containerScroll.frame.size.height;
    int currentPage = floor((_containerScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (currentPage == 0) {
        [_containerScroll scrollRectToVisible:CGRectMake(pageWidth * 6, 0, pageWidth, pageHeigth) animated:NO];
        _pageControl.currentPage = 5;
        //return;
    }else if(currentPage == 7){
        [_containerScroll scrollRectToVisible:CGRectMake(pageWidth, 0, pageWidth, pageHeigth) animated:NO];
        _pageControl.currentPage = 0;
        //return;
    }else{
        _pageControl.currentPage = currentPage - 1;
    }
    
    catIndex = _pageControl.currentPage + 1;
    
    [self setImagesWithIndex:_pageControl.currentPage];
    [self refreshUIWithData:YES AndIndex:catIndex];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = _containerScroll.frame.size.width;
    int currentPage = floor((_containerScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (currentPage == 0) {
        _pageControl.currentPage = 5;
    }else if(currentPage == 7){
        _pageControl.currentPage = 0;
    }
    _pageControl.currentPage = currentPage - 1;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

}

- (IBAction)changeResultAction:(id)sender {
    XETrainInfo *trainInfo = [[XETrainInfo alloc] init];
    trainInfo = [self.trainDic objectForKey:[NSString stringWithFormat:@"%d",(int)catIndex]];
    if (trainInfo) {
        NSString *otherbutTit1 = [NSString stringWithFormat:@"%@      %@",[trainInfo.resultsInfo[0] objectForKey:@"scoretitle"],[trainInfo.resultsInfo[0] objectForKey:@"time"]];
        NSString *otherbutTit2 = [NSString stringWithFormat:@"%@      %@",[trainInfo.resultsInfo[1] objectForKey:@"scoretitle"],[trainInfo.resultsInfo[1] objectForKey:@"time"]];
        NSString *otherbutTit3 = [NSString stringWithFormat:@"%@      %@",[trainInfo.resultsInfo[2] objectForKey:@"scoretitle"],[trainInfo.resultsInfo[2] objectForKey:@"time"]];
        NSString *otherbutTit4 = [NSString stringWithFormat:@"%@      %@",[trainInfo.resultsInfo[3] objectForKey:@"scoretitle"],[trainInfo.resultsInfo[3] objectForKey:@"time"]];
        NSString *otherbutTit5 = [NSString stringWithFormat:@"%@      %@",[trainInfo.resultsInfo[4] objectForKey:@"scoretitle"],[trainInfo.resultsInfo[4] objectForKey:@"time"]];
        
        __weak TaskViewController *weakSelf = self;
        XEActionSheet *sheet = [[XEActionSheet alloc] initWithTitle:@"评测记录" actionBlock:^(NSInteger buttonIndex) {
            if (trainInfo.resultsInfo.count == buttonIndex) {
                return;
            }
            
            [weakSelf doActionSheetClickedButtonAtIndex:buttonIndex];
        } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:otherbutTit1,otherbutTit2,otherbutTit3,otherbutTit4,otherbutTit5, nil];
        AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [sheet showInView:appDelegate.window];
    }else{
        XEAlertView *alert = [[XEAlertView alloc] initWithTitle:nil message:@"暂无评测成绩,点击开始测评进入评测" cancelButtonTitle:@"确定"];
        [alert show];
    }
}

- (void)doActionSheetClickedButtonAtIndex:(NSInteger)index{
    [self refreshUIWithData:YES AndIndex:index];
}

@end
