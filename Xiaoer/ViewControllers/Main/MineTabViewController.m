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
#import "LoginViewController.h"

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
@property (strong, nonatomic) IBOutlet UIImageView *ownerbkImageView;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *birthday;


- (IBAction)ownerHeadAction:(id)sender;
- (IBAction)setOwnerImageAction:(id)sender;
- (IBAction)editInfoAction:(id)sender;

@end

@implementation MineTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self refreshUserInfoShow];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserInfoChanged:) name:XE_USERINFO_CHANGED_NOTIFICATION object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    
    [self setTitle:@"我的"];
    
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
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"还没好还没好！！！"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"知道了", nil];
    [Alert show];
}

- (void)handleUserInfoChanged:(NSNotification *)notification{
    [self.tableView reloadData];
}

- (void)refreshUserInfoShow
{
    _userInfo = [XEEngine shareInstance].userInfo;
    
    [self.ownerbkImageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatar] placeholderImage:[UIImage imageNamed:@"placeholder_avatar_bg"]];
    [self.ownerHeadImageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatar] placeholderImage:[UIImage imageNamed:@"placeholder_avatar_icon"]];
    
//    [self.ownerHeadImageView sd_setImageWithURL:_userInfo.mediumAvatarUrl placeholderImage:[UIImage imageNamed:@"placeholder_avatar_icon"]];
//    if (_userInfo.backgroudImageUrl) {
//        [self.ownerbkImageView sd_setImageWithURL:_userInfo.largeAvatarUrl placeholderImage:[UIImage imageNamed:@"placeholder_avatar_bg"]];
//    }else{
//        [self.ownerbkImageView setImage:[UIImage imageNamed:@"placeholder_avatar_bg"]];
//    }
    
    self.ownerHeadImageView.layer.CornerRadius = 8;
    self.nickName.text = _userInfo.nickName;
    self.birthday.text = _userInfo.birthdayString;
    self.address.text  = _userInfo.address;
    self.tableView.tableHeaderView = self.headView;
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
    }else if (section == kMyCard){
        return 2;
    }else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SINGLE_CELL_HEIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SINGLE_HEADER_HEADER;
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
            cell.titleLabel.text = @"用户退出";
            break;
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
                NSLog(@"============我的消息");
                break;
            }else if (indexPath.row == 1){
                NSLog(@"============我的活动");
                break;
            }else if (indexPath.row == 2){
                NSLog(@"============我的收藏");
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
            //暂时放下
            [[XEEngine shareInstance] logout];
            LoginViewController *loginVc = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginVc animated:YES];
            break;
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

@end
