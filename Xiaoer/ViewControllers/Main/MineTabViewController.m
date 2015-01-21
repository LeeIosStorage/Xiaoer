//
//  MineTabViewController.m
//  Xiaoer
//
//  Created by KID on 14/12/30.
//
//

#import "MineTabViewController.h"
#import "MineTabCell.h"
#import "XEEngine.h"
#import "UIImageView+WebCache.h"
#import "PerfectInfoViewController.h"
#import "XETabBarViewController.h"
#import "WelcomeViewController.h"
#import "AppDelegate.h"
#import "SettingViewController.h"
#import "CollectionViewController.h"
#import "MineMsgViewController.h"

enum TABLEVIEW_SECTION_INDEX {
    kMyProfile = 0,
    kMyCard,
    kSetting,
    kSectionNumber,
};

@interface MineTabViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) XEUserInfo *userInfo;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *bkImageView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIImageView *headEdgeview;
@property (strong, nonatomic) IBOutlet UIImageView *ownerHeadImageView;
@property (strong, nonatomic) IBOutlet UIImageView *locationImageView;
@property (strong, nonatomic) IBOutlet UIImageView *ownerbkImageView;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *birthday;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;

@property (strong, nonatomic) IBOutlet UIView *visitorHeadView;
@property (strong, nonatomic) IBOutlet UIImageView *visitorImageView;

- (IBAction)ownerHeadAction:(id)sender;
- (IBAction)setOwnerImageAction:(id)sender;
- (IBAction)editInfoAction:(id)sender;
- (IBAction)loginAction:(id)sender;

@end

@implementation MineTabViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //_userInfo = [XEEngine shareInstance].userInfo;
    [self refreshUserInfoShow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self refreshUserInfoShow];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserInfoChanged:) name:XE_USERINFO_CHANGED_NOTIFICATION object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
//    [self setRightButtonWithTitle:@"设置" selector:@selector(settingAction)];
    [self setRightButtonWithImageName:@"setting_mine_icon" selector:@selector(settingAction)];
}

- (UINavigationController *)navigationController{
    if ([super navigationController]) {
        return [super navigationController];
    }
    return self.tabController.navigationController;
}

- (void)settingAction
{
    SettingViewController *sVc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:sVc animated:YES];
}

- (void)handleUserInfoChanged:(NSNotification *)notification{
    [self.tableView reloadData];
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
        [self setTitle:@"未登录"];
        [self.visitorImageView setImage:[UIImage imageNamed:@"tmp_avatar_icon"]];
        self.visitorImageView.layer.CornerRadius = 8;
        self.tableView.tableHeaderView = self.visitorHeadView;
    }else{
        XEUserInfo *userInfo = [self getBabyUserInfo:0];
        if (_userInfo.nickName.length > 0) {
            [self setTitle:_userInfo.nickName];
        }else{
            [self setTitle:@"我的"];
        }
        self.loginBtn.hidden = YES;
        [self.ownerbkImageView sd_setImageWithURL:_userInfo.originalAvatarUrl placeholderImage:[UIImage imageNamed:@"placeholder_avatar_bg"]];
        [self.ownerHeadImageView sd_setImageWithURL:_userInfo.smallAvatarUrl placeholderImage:[UIImage imageNamed:@"placeholder_avatar_icon"]];
        self.ownerHeadImageView.layer.CornerRadius = 8;
        self.nickName.text = _userInfo.nickName;
        self.birthday.text = [XEUIUtils dateDiscription1FromNowBk: userInfo.birthdayDate];
        self.address.text  = _userInfo.address;
        self.tableView.tableHeaderView = self.headView;
    }
    
    ///底部加点间隙
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 19)];
    footer.userInteractionEnabled = NO;
    footer.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footer;
//    [self.ownerHeadImageView sd_setImageWithURL:_userInfo.mediumAvatarUrl placeholderImage:[UIImage imageNamed:@"placeholder_avatar_icon"]];
//    if (_userInfo.backgroudImageUrl) {
//        [self.ownerbkImageView sd_setImageWithURL:_userInfo.largeAvatarUrl placeholderImage:[UIImage imageNamed:@"placeholder_avatar_bg"]];
//    }else{
//        [self.ownerbkImageView setImage:[UIImage imageNamed:@"placeholder_avatar_bg"]];
//    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return kSectionNumber;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == kMyProfile) {
        return 4;
    }else if (section == kMyCard || section == kSetting){
        return 2;
    }else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return SINGLE_HEADER_HEADER;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SINGLE_HEADER_HEADER)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MineTabCell";
    MineTabCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    
    switch (indexPath.section) {
        case kMyProfile:{
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"我的消息";
                break;
            }else if (indexPath.row == 1){
                cell.titleLabel.text = @"我的活动";
                break;
            }else if (indexPath.row == 2){
                cell.titleLabel.text = @"我的收藏";
                break;
            }else if (indexPath.row == 3){
                cell.titleLabel.text = @"我的话题";
                break;
            }
        }
        case kMyCard:{
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"我的卡包";
                break;
            }else if (indexPath.row == 1){
                cell.titleLabel.text = @"历史测评";
                break;
            }
        }
        case kSetting:{
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"用户退出";
                break;
            }else if (indexPath.row == 1){
                cell.titleLabel.text = @"切换网络";
                break;
            }
        }
        default:
            break;
    }
    if (indexPath.row == 0) {
        cell.topline.hidden = NO;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section is %ld",(long)indexPath.row);
    switch (indexPath.section) {
        case kMyProfile:{
            if (indexPath.row == 0) {
                MineMsgViewController *mVc = [[MineMsgViewController alloc] init];
                [self.navigationController pushViewController:mVc animated:YES];
                break;
            }else if (indexPath.row == 1){
                NSLog(@"============我的活动");
                break;
            }else if (indexPath.row == 2){
                CollectionViewController *cVc = [[CollectionViewController alloc] init];
                [self.navigationController pushViewController:cVc animated:YES];
                break;
            }else if (indexPath.row == 3){
                NSLog(@"============我的话题");
                break;
            }
        }
        case kMyCard:{
            if (indexPath.row == 0) {
                NSLog(@"============我的卡包");
                break;
            }else if (indexPath.row == 1){
                NSLog(@"============历史测评");
                break;
            }
        }
        case kSetting:{
            if (indexPath.row == 0) {
                [[XEEngine shareInstance] logout];
                WelcomeViewController *weVc = [[WelcomeViewController alloc] init];
                [self.navigationController pushViewController:weVc animated:YES];
                break;
            }else if (indexPath.row == 1){
                
                break;
            }
            //暂时放下
        }
        default:
            break;
    }
 
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)ownerHeadAction:(id)sender {
    NSLog(@"===========%s",__func__);
}

- (IBAction)setOwnerImageAction:(id)sender {
    NSLog(@"===========%s",__func__);
}

- (IBAction)editInfoAction:(id)sender {
    PerfectInfoViewController *piVc = [[PerfectInfoViewController alloc] init];
    piVc.userInfo = _userInfo;
    [self.navigationController pushViewController:piVc animated:YES];
}

- (IBAction)loginAction:(id)sender {
    WelcomeViewController *welcomeVc = [[WelcomeViewController alloc] init];
    [self.navigationController pushViewController:welcomeVc animated:YES];
}

@end
