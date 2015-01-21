//
//  ExpertIntroViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import "ExpertIntroViewController.h"
#import "XETopicViewCell.h"
#import "UIImageView+WebCache.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XETopicInfo.h"

@interface ExpertIntroViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *doctorTopics;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *hotLabel;
@property (strong, nonatomic) IBOutlet UILabel *doctorNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *doctorCollegeLabel;
@property (strong, nonatomic) IBOutlet UILabel *doctorIntroLabel;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) IBOutlet UIButton *topicButton;
@property (strong, nonatomic) IBOutlet UIButton *fansButton;

@property (nonatomic, strong) IBOutlet UIView *sectionView;
@property (strong, nonatomic) IBOutlet UILabel *topicLabel;

- (IBAction)consultAction:(id)sender;
- (IBAction)topicAction:(id)sender;
- (IBAction)fansAction:(id)sender;
@end

@implementation ExpertIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self refreshDoctorInfoShow];
    [self refreshExpertInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    [self setTitle:@"专家介绍"];
    [self setRightButtonWithImageName:@"nav_collect_un_icon" selector:@selector(collectAction:)];
    
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

- (void)refreshExpertInfo{
    
    __weak ExpertIntroViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getExpertDetailWithUid:@"1" tag:tag];
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
        
        NSDictionary *expertDic = [[jsonRet objectForKey:@"object"] objectForKey:@"expert"];
        [_doctorInfo setDoctorInfoByJsonDic:expertDic];
        
        
        weakSelf.doctorTopics = [[NSMutableArray alloc] init];
        NSArray *object = [[jsonRet objectForKey:@"object"] objectForKey:@"topics"];
        for (NSDictionary *dic in object) {
            XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
            [topicInfo setTopicInfoByJsonDic:dic];
            [weakSelf.doctorTopics addObject:topicInfo];
        }
        [weakSelf refreshDoctorInfoShow];
        [weakSelf.tableView reloadData];
        
    }tag:tag];
}

#pragma mark - custom
-(void)refreshDoctorInfoShow{
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_doctorInfo.avatar] placeholderImage:[UIImage imageNamed:@"user_avatar_default"]];
    self.doctorNameLabel.text = [NSString stringWithFormat:@"%@ %d岁",_doctorInfo.doctorName,_doctorInfo.age];
    self.doctorCollegeLabel.text = _doctorInfo.hospital;
    self.doctorIntroLabel.text = _doctorInfo.des;
    
    [self.topicButton setTitle:[NSString stringWithFormat:@"话题 %d",_doctorInfo.topicnum] forState:0];
    [self.fansButton setTitle:[NSString stringWithFormat:@"粉丝 %d",_doctorInfo.favnum] forState:0];
    self.hotLabel.text = [NSString stringWithFormat:@"%d",_doctorInfo.favnum];
    
    CGRect frame = _doctorIntroLabel.frame;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:_doctorIntroLabel.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize topicTextSize = [_doctorIntroLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-12-86, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    frame.size.height = topicTextSize.height;
    _doctorIntroLabel.frame = frame;
    
    frame = self.headView.frame;
    frame.size.height = self.doctorIntroLabel.frame.origin.y + self.doctorIntroLabel.frame.size.height + 41;
    self.headView.frame = frame;
    
    self.tableView.tableHeaderView = self.headView;
}

-(void)collectAction:(id)sender{
    
    __weak ExpertIntroViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] collectExpertWithExpertId:_doctorInfo.doctorId uid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
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
    __weak ExpertIntroViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] shareExpertWithExpertId:_doctorInfo.doctorId uid:[XEEngine shareInstance].uid tag:tag];
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

- (IBAction)consultAction:(id)sender {
    
}

- (IBAction)topicAction:(id)sender {
    
}

- (IBAction)fansAction:(id)sender {
    
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.sectionView.frame.size.height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _doctorTopics.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XETopicInfo *topicInfo = _doctorTopics[indexPath.row];
    return [XETopicViewCell heightForTopicInfo:topicInfo];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"XETopicViewCell";
    XETopicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    XETopicInfo *topicInfo = _doctorTopics[indexPath.row];
    cell.topicInfo = topicInfo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
}

@end
