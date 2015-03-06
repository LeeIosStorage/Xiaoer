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
#import "XEProgressHUD.h"

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
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = view;
    
    [self refreshUIShow];
    [self.tableView reloadData];
    
    if (_vcType == VcType_ALL) {
        [self getCacheAllHistoryInfo];
        [self refreshAllHistoryInfo];
    }else if (_vcType == VcType_ONE_KEY){
        [self getCacheOneHistoryInfo];
        [self refreshOneHistoryInfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    
    [self setTitle:@"全部历史评测"];
    if (_vcType == VcType_ONE_KEY) {
        [self setTitle:[NSString stringWithFormat:@"%@历史评测",_keyString]];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 全部历史评测
- (void)getCacheAllHistoryInfo{
    
    XEUserInfo *babyUserInfo = [self getBabyUserInfo:0];
    __weak StageSelectViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getAllEvaHistoryWithBabyId:babyUserInfo.babyId uid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            weakSelf.keyStageInfos = [[NSMutableArray alloc] init];
            NSArray *objectArray = [jsonRet objectForKey:@"object"];
            for (NSDictionary *dic in objectArray) {
                [weakSelf.keyStageInfos addObject:dic];
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

-(void)refreshAllHistoryInfo{
    
    XEUserInfo *babyUserInfo = [self getBabyUserInfo:0];
    __weak StageSelectViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getAllEvaHistoryWithBabyId:babyUserInfo.babyId uid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        weakSelf.keyStageInfos = [[NSMutableArray alloc] init];
        NSArray *objectArray = [jsonRet objectForKey:@"object"];
        for (NSDictionary *dic in objectArray) {
            [weakSelf.keyStageInfos addObject:dic];
        }
        [weakSelf.tableView reloadData];
        
    }tag:tag];
    
}
#pragma mark - 某一关键期
- (void)getCacheOneHistoryInfo{
    
    XEUserInfo *babyUserInfo = [self getBabyUserInfo:0];
    __weak StageSelectViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getStageEvaHistoryWithBabyId:babyUserInfo.babyId uid:[XEEngine shareInstance].uid stage:_stage tag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            weakSelf.keyStageInfos = [[NSMutableArray alloc] init];
            NSArray *objectArray = [jsonRet objectForKey:@"object"];
            for (NSDictionary *dic in objectArray) {
                [weakSelf.keyStageInfos addObject:dic];
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

-(void)refreshOneHistoryInfo{
    
    XEUserInfo *babyUserInfo = [self getBabyUserInfo:0];
    __weak StageSelectViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getStageEvaHistoryWithBabyId:babyUserInfo.babyId uid:[XEEngine shareInstance].uid stage:_stage tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        weakSelf.keyStageInfos = [[NSMutableArray alloc] init];
        NSArray *objectArray = [jsonRet objectForKey:@"object"];
        for (NSDictionary *dic in objectArray) {
            [weakSelf.keyStageInfos addObject:dic];
        }
        [weakSelf.tableView reloadData];
        
    }tag:tag];
}

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
    
    if (_vcType == VcType_ALL) {
        return self.sectionView;
    }else if (_vcType == VcType_ONE_KEY){
        return nil;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_vcType == VcType_ALL) {
        return self.sectionView.frame.size.height;
    }else if (_vcType == VcType_ONE_KEY){
        return 0;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _keyStageInfos.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StageSelectViewCell";
    StageSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
//        [cell.consultButton addTarget:self action:@selector(handleClickAt:event:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    cell.historyLabel.hidden = YES;
    NSDictionary *dicInfo = _keyStageInfos[indexPath.row];
    if (_vcType == VcType_ALL) {
        cell.keyStageLabel.text = [NSString stringWithFormat:@"第%@关键期",[[dicInfo objectForKey:@"stage"] description]];
        cell.babyDateLabel.text = [NSString stringWithFormat:@"宝宝出生后%@周",[[dicInfo objectForKey:@"weeknum"] description]];
        cell.historyLabel.text = [NSString stringWithFormat:@"历史评测%@次",[[dicInfo objectForKey:@"num"] description]];
        cell.historyLabel.hidden = NO;
        cell.historyLabel.font = [UIFont systemFontOfSize:13];
        cell.historyLabel.textColor = UIColorRGB(136, 136, 136);
        if ([[dicInfo objectForKey:@"num"] intValue] > 0) {
            cell.historyLabel.font = [UIFont boldSystemFontOfSize:13];
            cell.historyLabel.textColor = SKIN_COLOR;
        }
    }else if (_vcType == VcType_ONE_KEY){
        cell.keyStageLabel.text = [NSString stringWithFormat:@"宝宝%@个月%@天",[[dicInfo objectForKey:@"baby_month"] description],[[dicInfo objectForKey:@"baby_day"] description]];
        NSDateFormatter *dateFormatter = [XEUIUtils dateFormatterOFUS];
        if ([dicInfo objectForKey:@"time"] && [[dicInfo objectForKey:@"time"] isKindOfClass:[NSString class]]) {
            NSDate *time = [dateFormatter dateFromString:[dicInfo objectForKey:@"time"]];
            cell.babyDateLabel.text = [XEUIUtils dateDiscriptionFromNowBk:time];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    NSDictionary *dicInfo = _keyStageInfos[indexPath.row];
    
    if (_vcType == VcType_ALL) {
        if ([[dicInfo objectForKey:@"num"] intValue] == 0) {
            return;
        }
        StageSelectViewController *vc = [[StageSelectViewController alloc] init];
        vc.vcType = VcType_ONE_KEY;
        vc.keyString = [NSString stringWithFormat:@"第%@关键期",[[dicInfo objectForKey:@"stage"] description]];
        vc.stage = [[dicInfo objectForKey:@"stage"] description];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (_vcType == VcType_ONE_KEY){
        
    }
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
