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

enum TABLEVIEW_SECTION_INDEX {
    kMyProfile = 0,
    kMyCard,
    kSectionNumber,
};

@interface MineTabViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) XEUserInfo *userInfo;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIImageView *bkImageView;
@property (nonatomic, strong) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIImageView *headEdgeview;
@property (nonatomic, strong) IBOutlet UIImageView *ownerHeadImageView;

- (IBAction)ownerHeadAction:(id)sender;
- (IBAction)setOwnerImageAction:(id)sender;
- (IBAction)editInfoAction:(id)sender;

@end

@implementation MineTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserInfoChanged:) name:XE_USERINFO_CHANGED_NOTIFICATION object:nil];
    
    [self refreshUserInfoShow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    
    [self setTitle:@"我的"];
    
    [self setRightButtonWithTitle:@"设置" selector:@selector(settingAction)];
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
    
//    [self.ownerHeadImageView sd_setImageWithURL:_userInfo.largeAvatarUrl placeholderImage:[UIImage imageNamed:@"defaultavatar_110x110@2x"]];
//    
//    if (_userInfo.backgroudImageUrl) {
//        [self.bkImageView sd_setImageWithURL:_userInfo.backgroudImageUrl placeholderImage:[UIImage imageNamed:@"1.3.0_selfphoto_headBg@2x.png"]];
//    }else{
//        [self.bkImageView setImage:[UIImage imageNamed:@"1.3.0_selfphoto_headBg@2x.png"]];
//    }
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
