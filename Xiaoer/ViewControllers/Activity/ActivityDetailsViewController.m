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

@interface ActivityDetailsViewController () <UITableViewDataSource,UITableViewDelegate>

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
    
    [self setRight2ButtonWithImageName:@"share_icon" selector:@selector(shareAction:)];
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
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
        
        NSDictionary *dic = [jsonRet objectForKey:@"object"];
        [weakSelf.activityInfo setActivityInfoByJsonDic:dic];
        
        [weakSelf refreshActivityHeadShow];
        [weakSelf.tableView reloadData];
        
    }tag:tag];
}

#pragma mark - custom
-(void)refreshActivityHeadShow{
    
    if (_activityInfo.faved == 0) {
        [self.titleNavBarRightBtn setImage:[UIImage imageNamed:@"nav_collect_un_icon"] forState:UIControlStateNormal];
    }else{
        [self.titleNavBarRightBtn setImage:[UIImage imageNamed:@"nav_collect_icon"] forState:UIControlStateNormal];
    }
    
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.avatarImageView sd_setImageWithURL:_activityInfo.picUrl placeholderImage:[UIImage imageNamed:@"activity_pic_default"]];
    
    self.titleLabel.text = _activityInfo.title;
    self.addressAndTimeLabel.text = [NSString stringWithFormat:@"%@\n%@到%@",_activityInfo.address,[XEUIUtils dateDiscriptionFromDate:_activityInfo.begintime],[XEUIUtils dateDiscriptionFromDate:_activityInfo.endtime]];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@ %@\n%d人已报名 至少%d人 最多%d人",_activityInfo.contact,_activityInfo.phone,_activityInfo.regnum,_activityInfo.minnum,_activityInfo.totalnum];
    self.activityIntroLabel.text = _activityInfo.des;
    
    CGRect frame = self.activityIntroLabel.frame;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:self.activityIntroLabel.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize topicTextSize = [self.activityIntroLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-12-86, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    frame.size.height = topicTextSize.height;
    self.activityIntroLabel.frame = frame;
    
    self.tableView.tableHeaderView = self.headView;
}

-(void)collectAction:(id)sender{
    
    __weak ActivityDetailsViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] collectActivityWithActivityId:_activityInfo.aId uid:[XEEngine shareInstance].uid tag:tag];
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
        [self.titleNavBarRightBtn setImage:[UIImage imageNamed:@"nav_collect_icon"] forState:UIControlStateNormal];
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
        [weakSelf.tableView reloadData];
        
    }tag:tag];
}

-(void)shareAction:(id)sender{
    
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
