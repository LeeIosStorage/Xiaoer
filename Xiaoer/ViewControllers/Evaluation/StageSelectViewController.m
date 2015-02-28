//
//  StageSelectViewController.m
//  Xiaoer
//
//  Created by KID on 15/2/28.
//
//

#import "StageSelectViewController.h"
#import "StageSelectViewCell.h"
#import "XEUserInfo.h"
#import "XEEngine.h"
#import "UIImageView+WebCache.h"

@interface StageSelectViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) XEUserInfo *userInfo;
@property (nonatomic, strong) NSMutableArray *keyStageInfos;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *sectionView;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *keyStageLabel;

@end

@implementation StageSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _keyStageInfos = [[NSMutableArray alloc] init];
    _userInfo = [XEEngine shareInstance].userInfo;
    
    [self refreshUIShow];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    
    [self setTitle:@"选择关键期"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - custom
-(void)refreshUIShow{
    
    XEUserInfo *babyUserInfo = [self getBabyUserInfo:0];
    [self.avatarImageView sd_setImageWithURL:babyUserInfo.babySmallAvatarUrl placeholderImage:[UIImage imageNamed:@"home_placeholder_avatar"]];
    self.avatarImageView.layer.CornerRadius = 8;
    self.avatarImageView.clipsToBounds = YES;
    self.nickNameLabel.text = [NSString stringWithFormat:@"%@  %@",babyUserInfo.babyNick,[XEUIUtils dateDiscription1FromNowBk:babyUserInfo.birthdayDate]];
}

-(XEUserInfo *)getBabyUserInfo:(NSInteger)index{
    if (_userInfo.babys.count > index) {
        XEUserInfo *babyUserInfo = [_userInfo.babys objectAtIndex:index];
        return babyUserInfo;
    }
    return nil;
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.sectionView.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StageSelectViewCell";
    StageSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
//        [cell.consultButton addTarget:self action:@selector(handleClickAt:event:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
}

-(void)handleClickAt:(id)sender event:(id)event{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil){
        XELog(@"indexPath: row:%d", (int)indexPath.row);
    }
    
}

@end
