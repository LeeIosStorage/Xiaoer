//
//  ActivityDetailsViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/16.
//
//

#import "ActivityDetailsViewController.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "ApplyActivityViewController.h"
#import "MapChooseViewController.h"
#import "XEScrollPage.h"
#import "XEThemeInfo.h"
#import "XEShareActionSheet.h"
#import "XEAlertView.h"
#import "PerfectInfoViewController.h"

@interface ActivityDetailsViewController () <UITableViewDataSource,UITableViewDelegate,XEScrollPageDelegate,XEShareActionSheetDelegate>
{
    XEShareActionSheet *_shareAction;
    
    XEScrollPage *_scrollPageView;
    BOOL _servicerInfoSucceed;
}
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *activityContainerView;
@property (strong, nonatomic) IBOutlet UILabel *addressAndTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *activityIntroLabel;

@property (strong, nonatomic) IBOutlet UIView *applyActivityView;
@property (strong, nonatomic) IBOutlet UIButton *applyActivityButton;

@property (strong, nonatomic) IBOutlet UIView *rushTicketView;
@property (strong, nonatomic) IBOutlet UILabel *rushStateTipLabel;
@property (strong, nonatomic) IBOutlet UILabel *rushDateTipLabel;
@property (strong, nonatomic) IBOutlet UIButton *rushButton;
@property (assign, nonatomic) int dateDistance;
@property (strong, nonatomic) NSTimer *dateTimer;
@property (assign, nonatomic) BOOL isHavServerData;

- (IBAction)applyActivityAction:(id)sender;
- (IBAction)phoneAction:(id)sender;
- (IBAction)addressAction:(id)sender;
- (IBAction)rushAction:(id)sender;
@end

@implementation ActivityDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getCacheActivityInfo];//cache
    [self refreshActivityInfo];
    [self refreshActivityHeadShow];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{

    [self setTitle:@"活动详情"];
    [self setRightButtonWithImageName:@"more_icon" selector:@selector(collectAction:)];
//    [self.titleNavBarRightBtn setImage:[UIImage imageNamed:@"nav_collect_icon"] forState:UIControlStateHighlighted];
    
//    [self setRight2ButtonWithImageName:@"share_icon" selector:@selector(shareAction:)];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)getCacheActivityInfo{
    __weak ActivityDetailsViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getApplyActivityDetailWithActivityId:_activityInfo.aId uid:[XEEngine shareInstance].uid type:_activityInfo.aType tag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (self.navigationController == nil || self.navigationController.topViewController != self || weakSelf == nil) {
            return ;
        }
        if (jsonRet == nil) {
            //...
        }else{
            _servicerInfoSucceed = YES;
            NSDictionary *dic = [jsonRet dictionaryObjectForKey:@"object"];
            [weakSelf.activityInfo setActivityInfoByJsonDic:dic];
            
            [weakSelf refreshAdsScrollView];
            [weakSelf refreshActivityHeadShow];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)refreshActivityInfo{
    
    __weak ActivityDetailsViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getApplyActivityDetailWithActivityId:_activityInfo.aId uid:[XEEngine shareInstance].uid type:_activityInfo.aType tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        if (self.navigationController == nil || self.navigationController.topViewController != self || weakSelf == nil) {
            return ;
        }
//        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        _servicerInfoSucceed = YES;
        weakSelf.isHavServerData = YES;
//        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
        
        NSDictionary *dic = [jsonRet objectForKey:@"object"];
        [weakSelf.activityInfo setActivityInfoByJsonDic:dic];
        
        [weakSelf refreshAdsScrollView];
        [weakSelf refreshActivityHeadShow];
        [weakSelf.tableView reloadData];
        
    }tag:tag];
}

#pragma mark - Judge
-(BOOL)isCollect{
    if (_activityInfo.faved != 0) {
        return YES;
    }
    return NO;
}

-(void) startTimer
{
    if (!_dateTimer) {
        _dateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTimeLabel) userInfo:nil repeats:YES];
    }
}
-(void) stopTimer{
    [_dateTimer invalidate];
    _dateTimer = nil;
}

-(void)refreshTimeLabel{
    
    _dateDistance --;
    XELog(@"DateTimer refreshTimeLabel%d",_dateDistance);
    int status = _activityInfo.status;
    if (status == 1) {
        _activityInfo.startsecond = _dateDistance;
    }else if (status == 2){
        _activityInfo.endsecond = _dateDistance;
    }
    if (_dateDistance > 0) {
        NSString *timeStr = [XEUIUtils secondChangToDateString:[NSString stringWithFormat:@"%d",_dateDistance]];
        NSArray *timeArray = [timeStr componentsSeparatedByString:@":"];
        if (timeArray.count > 2) {
            _rushDateTipLabel.text = [NSString stringWithFormat:@"%@小时%@分钟%@秒",[[timeArray objectAtIndex:0] description],[[timeArray objectAtIndex:1] description],[[timeArray objectAtIndex:2] description]];
        }
    }else{
        [self refreshTicketActivityFooterShow];
    }
}
#pragma mark - custom
- (void)refreshAdsScrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:XE_MAIN_STOP_ADS_VIEW_NOTIFICATION object:[NSNumber numberWithBool:YES]];
    for (UIView *view in _avatarImageView.subviews) {
        [view removeFromSuperview];
    }
    
    NSMutableArray *adsThemeArray = [NSMutableArray array];
    for (NSString *url in _activityInfo.picIds) {
        XEThemeInfo *info = [[XEThemeInfo alloc] init];
        info.themeImageUrl = url;
        [adsThemeArray addObject:info];
    }
    
    _scrollPageView = [[XEScrollPage alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_avatarImageView.frame), CGRectGetHeight(_avatarImageView.frame))];
    _scrollPageView.duration = 4;
    _scrollPageView.adsType = AdsType_Theme;
    _scrollPageView.dataArray = adsThemeArray;
    _scrollPageView.delegate = self;
    [self.avatarImageView addSubview:_scrollPageView];
    
    [self.tableView reloadData];
}

-(void)refreshActivityHeadShow{
    
//    if (![self isCollect]) {
//        [self.titleNavBarRightBtn setImage:[UIImage imageNamed:@"nav_collect_un_icon"] forState:UIControlStateNormal];
//    }else{
//        [self.titleNavBarRightBtn setImage:[UIImage imageNamed:@"nav_collect_icon"] forState:UIControlStateNormal];
//    }
    
//    //test
//    NSCalendar * calender = [NSCalendar currentCalendar];
//    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit |
//    NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
//    NSDateComponents *compsNow = [calender components:unitFlags fromDate:[NSDate date]];
//    compsNow.year += 10;
//    NSDate *begintime = [calender dateFromComponents:compsNow];
//    
//    compsNow.hour += 1;
//    NSDate *endtime = [calender dateFromComponents:compsNow];
//    
//    _activityInfo.begintime = begintime;
//    _activityInfo.endtime = endtime;
    
    if (_activityInfo.aType == 1) {
        _isTicketActivity = YES;
    }
    
    if (_isTicketActivity) {
        if (self.applyActivityView.superview) {
            [self.applyActivityView removeFromSuperview];
        }
        CGRect frame = self.rushTicketView.frame;
        frame.origin.y = self.view.bounds.size.height - frame.size.height;
        self.rushTicketView.frame = frame;
        [self.view addSubview:self.rushTicketView];
        
        frame = self.tableView.frame;
        frame.size.height = self.rushTicketView.frame.origin.y;
        self.tableView.frame = frame;
        [self refreshTicketActivityFooterShow];
    }else{
        if (self.rushTicketView.superview) {
            [self.rushTicketView removeFromSuperview];
        }
        CGRect frame = self.applyActivityView.frame;
        frame.origin.y = self.view.bounds.size.height - frame.size.height;
        self.applyActivityView.frame = frame;
        [self.view addSubview:self.applyActivityView];
        
        frame = self.tableView.frame;
        frame.size.height = self.applyActivityView.frame.origin.y;
        self.tableView.frame = frame;
    }
    
    _applyActivityButton.enabled = NO;
    NSString *applyButtonTitle = @"在线报名";
    int status = _activityInfo.status;//0未发布 1报名未开始 2可报名 3已报名 4已报满  5已截止 6已结束
    if (status == 0) {
        applyButtonTitle = @"未发布";
    }else if (status == 1) {
        applyButtonTitle = @"报名还未开始";
    }else if (status == 2){
        applyButtonTitle = @"在线报名";
        _applyActivityButton.enabled = YES;
    }else if (status == 3){
        applyButtonTitle = @"已报名";
    }else if (status == 4){
        applyButtonTitle = @"已报满";
    }else if (status == 5){
        applyButtonTitle = @"已截止";
    }else if (status == 6){
        applyButtonTitle = @"已结束";
    }
    [self.applyActivityButton setTitle:applyButtonTitle forState:0];
    
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    if (_servicerInfoSucceed && _activityInfo.picIds.count > 0) {
        [self.avatarImageView sd_setImageWithURL:nil];
        [self.avatarImageView setImage:nil];
    }else{
        [self.avatarImageView sd_setImageWithURL:_activityInfo.picUrl placeholderImage:[UIImage imageNamed:@"activity_load_icon"]];
    }
    
    self.titleLabel.text = _activityInfo.title;
    self.addressAndTimeLabel.text = [NSString stringWithFormat:@"%@\n%@到%@",_activityInfo.address,[XEUIUtils dateDiscriptionFromDate:_activityInfo.begintime],[XEUIUtils dateDiscriptionFromDate:_activityInfo.endtime]];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@ %@\n%d人已报名 至少%d人 最多%d人",_activityInfo.contact,_activityInfo.phone,_activityInfo.regnum,_activityInfo.minnum,_activityInfo.totalnum];
    self.activityIntroLabel.text = _activityInfo.des;
    
    CGRect frame = self.activityIntroLabel.frame;
    CGSize topicTextSize = [XECommonUtils sizeWithText:_activityInfo.des font:self.activityIntroLabel.font width:SCREEN_WIDTH-13*2];
    frame.size.width = topicTextSize.width;
    frame.size.height = topicTextSize.height;
    self.activityIntroLabel.frame = frame;
    
    frame = self.headView.frame;
    frame.size.height = self.activityIntroLabel.frame.origin.y + self.activityIntroLabel.frame.size.height + 10;
    self.headView.frame = frame;
    
    self.tableView.tableHeaderView = self.headView;
}

-(void)refreshTicketActivityFooterShow{
    
    _rushDateTipLabel.hidden = NO;
    _rushStateTipLabel.hidden = NO;
    _rushButton.hidden = NO;
    
    _rushButton.enabled = NO;
    NSString *applyButtonTitle = @"抢票";
    _rushDateTipLabel.text = [NSString stringWithFormat:@"%d人",_activityInfo.regnum];
    _rushStateTipLabel.text = @"已报名";
    int status = _activityInfo.status;//0未发布 1报名未开始 2可抢 3已抢 4抢满  5抢票截止
    if (status == 1) {
        applyButtonTitle = @"抢票";
        _rushButton.enabled = NO;
        _rushStateTipLabel.text = @"报名倒计时";
    }else if (status == 2){
        applyButtonTitle = @"抢票";
        _rushButton.enabled = YES;
        _rushStateTipLabel.text = @"结束倒计时";
    }else if (status == 3){
        applyButtonTitle = @"已抢";
        _rushStateTipLabel.text = @"抢票码";
        _rushDateTipLabel.text = _activityInfo.regcode;
    }else if (status == 4){
        applyButtonTitle = @"已满";
    }else if (status == 5){
        applyButtonTitle = @"截止";
    }else if (status == 6){
        applyButtonTitle = @"截止";
    }
    [self.rushButton setTitle:applyButtonTitle forState:0];
    
    if (status == 1 || status == 2) {
        int beginDistance = _activityInfo.startsecond;
        int endDistance = _activityInfo.endsecond;
        if (beginDistance <= 0 && endDistance <= 0) {
            _rushDateTipLabel.text = [NSString stringWithFormat:@"%d人",_activityInfo.regnum];
            _rushStateTipLabel.text = @"已报名";
            _rushButton.enabled = NO;
            [self.rushButton setTitle:@"截止" forState:0];
        }else{
            if (!_isHavServerData) {
                //没获取到网络数据不显示倒计时view
                _rushDateTipLabel.hidden = YES;
                _rushStateTipLabel.hidden = YES;
                _rushButton.hidden = YES;
                return;
            }
            if (endDistance > 0) {
                _dateDistance = endDistance;
                _rushStateTipLabel.text = @"结束倒计时";
                _rushButton.enabled = YES;
            }
            if (beginDistance > 0) {
                _dateDistance = beginDistance;
                _rushStateTipLabel.text = @"报名倒计时";
                _rushButton.enabled = NO;
            }
            NSString *timeStr = [XEUIUtils secondChangToDateString:[NSString stringWithFormat:@"%d",_dateDistance]];
            NSArray *timeArray = [timeStr componentsSeparatedByString:@":"];
            if (timeArray.count > 2) {
                
                _rushDateTipLabel.text = [NSString stringWithFormat:@"%@小时%@分钟%@秒",[[timeArray objectAtIndex:0] description],[[timeArray objectAtIndex:1] description],[[timeArray objectAtIndex:2] description]];
                [self startTimer];
            }
        }
    }
    
}

-(void)collectAction:(id)sender{
//    if ([[XEEngine shareInstance] needUserLogin:nil]) {
//        return;
//    }
    _shareAction = [[XEShareActionSheet alloc] init];
    _shareAction.owner = self;
    _shareAction.selectShareType = XEShareType_Activity;
    _shareAction.activityInfo = _activityInfo;
    [_shareAction showShareAction];
//    __weak ActivityDetailsViewController *weakSelf = self;
//    int tag = [[XEEngine shareInstance] getConnectTag];
//    if ([self isCollect]) {
//        [[XEEngine shareInstance] unCollectActivityWithActivityId:_activityInfo.aId uid:[XEEngine shareInstance].uid tag:tag];
//    }else{
//        [[XEEngine shareInstance] collectActivityWithActivityId:_activityInfo.aId uid:[XEEngine shareInstance].uid tag:tag];
//    }
//    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
////        [XEProgressHUD AlertLoadDone];
//        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
//        if (!jsonRet || errorMsg) {
//            if (!errorMsg.length) {
//                errorMsg = @"请求失败";
//            }
//            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
//            return;
//        }
//        if ([self isCollect]) {
//            _activityInfo.faved = 0;
//        }else{
//            _activityInfo.faved = 1;
//        }
//        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"] At:weakSelf.view];
//        [weakSelf refreshActivityHeadShow];
//        [weakSelf.tableView reloadData];
//        
//    }tag:tag];
}

-(void)shareAction:(id)sender{
    if ([[XEEngine shareInstance] needUserLogin:nil]) {
        return;
    }
    __weak ActivityDetailsViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] shareActivityWithActivityId:_activityInfo.aId uid:[XEEngine shareInstance].uid type:_activityInfo.aType tag:tag];
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
        [weakSelf.tableView reloadData];
        
    }tag:tag];
}

- (IBAction)applyActivityAction:(id)sender {
    if ([[XEEngine shareInstance] needUserLogin:nil]) {
        return;
    }
    if ([XEEngine shareInstance].userInfo.profileStatus == 0) {
        [self applyActivity];
    }else{
        NSString *message = @"您需要完善资料才能报名活动";
        if (_isTicketActivity) {
            message = @"您需要完善资料才能抢票";
        }
        XEAlertView *alertView = [[XEAlertView alloc] initWithTitle:nil message:message cancelButtonTitle:@"取消" cancelBlock:^{
        } okButtonTitle:@"确定" okBlock:^{
            PerfectInfoViewController *piVc = [[PerfectInfoViewController alloc] init];
            piVc.userInfo = [XEEngine shareInstance].userInfo;
            piVc.isFromActivity = YES;
            piVc.activityInfo = _activityInfo;
            piVc.finishedCallBack = ^(BOOL isFinish){
                if (isFinish) {
                    [self refreshActivityHeadShow];
                }
            };
            [self.navigationController pushViewController:piVc animated:YES];
        }];
        [alertView show];
    }
}

- (IBAction)phoneAction:(id)sender {
    [XECommonUtils usePhoneNumAction:_activityInfo.phone];
}

- (IBAction)addressAction:(id)sender {
    MapChooseViewController *showmap = [[MapChooseViewController alloc] init];
    [showmap showCurrentLocation:YES];
    [showmap setCurrentLocation:_activityInfo.latitude longitute:_activityInfo.longitude];
    showmap.showPlaceTitle = _activityInfo.address;
    [self.navigationController pushViewController:showmap animated:YES];
}

- (IBAction)rushAction:(id)sender {
    [self applyActivityAction:nil];
}

-(void)applyActivity{
    
    _applyActivityButton.enabled = NO;
    [_applyActivityButton setTitle:@"报名中..." forState:0];
    _rushButton.enabled = NO;
    [_rushButton setTitle:@"抢票中" forState:0];
    
    __weak ActivityDetailsViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] applyActivityWithActivityId:_activityInfo.aId uid:[XEEngine shareInstance].uid type:_activityInfo.aType tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [self refreshActivityHeadShow];
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"] At:weakSelf.view];
        weakSelf.activityInfo.status = 3;
        weakSelf.activityInfo.regnum ++;
        [weakSelf refreshActivityHeadShow];
        
        if (weakSelf.isTicketActivity) {
            [self stopTimer];
            [weakSelf refreshActivityInfo];
        }else{
            ApplyActivityViewController *applyVc = [[ApplyActivityViewController alloc] init];
            applyVc.infoId = [jsonRet stringObjectForKey:@"object"];
            [weakSelf.navigationController pushViewController:applyVc animated:YES];
        }
        
    }tag:tag];
}

#pragma mark - XEScrollPageDelegate
- (void)didTouchPageView:(NSInteger)index{
    if (index < 0) {
        return;
    }
//    
//    XEThemeInfo *theme = [_adsThemeArray objectAtIndex:index];
//    if (!theme) {
//        return;
//    }
//    
//    id vc = [XELinkerHandler handleDealWithHref:theme.themeActionUrl From:self.navigationController];
//    if (vc) {
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
//    static NSString *CellIdentifier = @"ActivityViewCell";
//    ActivityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
//        cell = [cells objectAtIndex:0];
//        cell.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    
//    XEActivityInfo *activityInfo = _activityList[indexPath.row];
//    cell.activityInfo = activityInfo;
//    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:XE_MAIN_SHOW_ADS_VIEW_NOTIFICATION object:[NSNumber numberWithBool:YES]];
    [self refreshTicketActivityFooterShow];
    if (_activityInfo.startsecond > 0 || _activityInfo.endsecond > 0) {
        [self refreshActivityInfo];
    }
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:XE_MAIN_STOP_ADS_VIEW_NOTIFICATION object:[NSNumber numberWithBool:YES]];
    [self stopTimer];
//    _isHavServerData = NO;
    [super viewDidDisappear:animated];
}

- (void)applicationWillResignActive:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:XE_MAIN_STOP_ADS_VIEW_NOTIFICATION object:[NSNumber numberWithBool:YES]];
}

- (void)appWillEnterForeground:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:XE_MAIN_SHOW_ADS_VIEW_NOTIFICATION object:[NSNumber numberWithBool:YES]];
    if (_activityInfo.startsecond > 0 || _activityInfo.endsecond > 0) {
        [self refreshActivityInfo];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _scrollPageView.delegate = nil;
    _scrollPageView = nil;
    [self stopTimer];
    XELog(@"ActivityDetailsViewController dealloc !!!");
}

@end
