//
//  BabyListViewController.m
//  Xiaoer
//
//  Created by KID on 15/3/9.
//
//

#import "BabyListViewController.h"
#import "XEEngine.h"
#import "XEUserInfo.h"
#import "BabyListViewCell.h"
#import "UIImageView+WebCache.h"
#import "BabyProfileViewController.h"

@interface BabyListViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *babyInfos;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *footerView;

- (IBAction)addBabyAction:(id)sender;
@end

@implementation BabyListViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserInfoChanged:) name:XE_USERINFO_CHANGED_NOTIFICATION object:nil];
    
    self.view.backgroundColor = UIColorRGB(240, 240, 240);
    self.tableView.tableFooterView = self.footerView;
    _babyInfos = [[NSMutableArray alloc] init];
    for (XEUserInfo *babyInfo in [XEEngine shareInstance].userInfo.babys) {
        [self.babyInfos addObject:babyInfo];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    //title
    [self setTitle:@"我的宝宝"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addBabyAction:(id)sender {
    BabyProfileViewController *vc = [[BabyProfileViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleUserInfoChanged:(NSNotification *)notification{
    _babyInfos = [[NSMutableArray alloc] init];
    for (XEUserInfo *babyInfo in [XEEngine shareInstance].userInfo.babys) {
        [self.babyInfos addObject:babyInfo];
    }
    [[XEEngine shareInstance]refreshUserInfo];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.babyInfos.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 15)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"BabyListViewCell";
    BabyListViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    XEUserInfo *babyInfo = [self.babyInfos objectAtIndex:indexPath.section];
    [cell.avatarImageView sd_setImageWithURL:babyInfo.babySmallAvatarUrl placeholderImage:[UIImage imageNamed:@"home_placeholder_avatar"]];
    cell.avatarImageView.layer.cornerRadius = 8;
    cell.avatarImageView.clipsToBounds = YES;
    cell.nickNameLabel.text = babyInfo.babyNick;
    cell.monthLabel.text = [XEUIUtils dateDiscription1FromNowBk:babyInfo.birthdayDate];
    
    cell.defaultBabyLabel.hidden = YES;
    if (babyInfo.acquiesce == 0) {
        cell.defaultBabyLabel.hidden = NO;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
    XEUserInfo *babyInfo = [self.babyInfos objectAtIndex:indexPath.section];
    XELog(@"babyInfo.babyId = %@",babyInfo.babyId);
    BabyProfileViewController *vc = [[BabyProfileViewController alloc] init];
    vc.babyInfo = babyInfo;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
