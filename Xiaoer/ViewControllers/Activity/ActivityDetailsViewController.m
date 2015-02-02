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

@interface ActivityDetailsViewController () <UITableViewDataSource,UITableViewDelegate,XEScrollPageDelegate>
{
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
- (IBAction)applyActivityAction:(id)sender;
- (IBAction)phoneAction:(id)sender;
- (IBAction)addressAction:(id)sender;
@end

@implementation ActivityDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self refreshActivityInfo];
    [self refreshActivityHeadShow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{

    [self setTitle:@"活动详情"];
    [self setRightButtonWithImageName:@"nav_collect_un_icon" selector:@selector(collectAction:)];
    [self.titleNavBarRightBtn setImage:[UIImage imageNamed:@"nav_collect_icon"] forState:UIControlStateHighlighted];
    
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

- (void)refreshActivityInfo{
    
    __weak ActivityDetailsViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getApplyActivityDetailWithActivityId:_activityInfo.aId uid:[XEEngine shareInstance].uid tag:tag];
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
        _servicerInfoSucceed = YES;
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

#pragma mark - custom
///刷新广告位
- (void)refreshAdsScrollView {
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
    
    if (![self isCollect]) {
        [self.titleNavBarRightBtn setImage:[UIImage imageNamed:@"nav_collect_un_icon"] forState:UIControlStateNormal];
    }else{
        [self.titleNavBarRightBtn setImage:[UIImage imageNamed:@"nav_collect_icon"] forState:UIControlStateNormal];
    }
    
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
    frame.size.height = topicTextSize.height;
    self.activityIntroLabel.frame = frame;
    
    frame = self.headView.frame;
    frame.size.height = self.activityIntroLabel.frame.origin.y + self.activityIntroLabel.frame.size.height + 10;
    self.headView.frame = frame;
    
    self.tableView.tableHeaderView = self.headView;
}

-(void)collectAction:(id)sender{
    if ([[XEEngine shareInstance] needUserLogin:nil]) {
        return;
    }
    __weak ActivityDetailsViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    if ([self isCollect]) {
        [[XEEngine shareInstance] unCollectActivityWithActivityId:_activityInfo.aId uid:[XEEngine shareInstance].uid tag:tag];
    }else{
        [[XEEngine shareInstance] collectActivityWithActivityId:_activityInfo.aId uid:[XEEngine shareInstance].uid tag:tag];
    }
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
        if ([self isCollect]) {
            _activityInfo.faved = 0;
        }else{
            _activityInfo.faved = 1;
        }
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
        [weakSelf refreshActivityHeadShow];
        [weakSelf.tableView reloadData];
        
    }tag:tag];
}

-(void)shareAction:(id)sender{
    if ([[XEEngine shareInstance] needUserLogin:nil]) {
        return;
    }
    __weak ActivityDetailsViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] shareActivityWithActivityId:_activityInfo.aId uid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg];
            return;
        }
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
        [weakSelf.tableView reloadData];
        
    }tag:tag];
}

- (IBAction)applyActivityAction:(id)sender {
    if ([[XEEngine shareInstance] needUserLogin:nil]) {
        return;
    }
    ApplyActivityViewController *applyVc = [[ApplyActivityViewController alloc] init];
    applyVc.activityInfo = _activityInfo;
    [self.navigationController pushViewController:applyVc animated:YES];
}

- (IBAction)phoneAction:(id)sender {
    [XECommonUtils usePhoneNumAction:_activityInfo.phone];
}

- (IBAction)addressAction:(id)sender {
    MapChooseViewController *showmap = [[MapChooseViewController alloc] init];
    [showmap showCurrentLocation:YES];
    [showmap setCurrentLocation:_activityInfo.latitude longitute:_activityInfo.longitude];
    
    [self.navigationController pushViewController:showmap animated:YES];
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

@end
