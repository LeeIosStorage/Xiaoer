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

@interface ActivityDetailsViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation ActivityDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{

    [self setTitle:@"活动详情"];
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
    
//    __weak ActivityDetailsViewController *weakSelf = self;
//    int tag = [[XEEngine shareInstance] getConnectTag];
//    [[XEEngine shareInstance] getApplyActivityListWithPage:1 uid:[XEEngine shareInstance].uid tag:tag];
//    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//        [XEProgressHUD AlertLoadDone];
//        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
//        if (!jsonRet || errorMsg) {
//            if (!errorMsg.length) {
//                errorMsg = @"请求失败";
//            }
//            [XEProgressHUD AlertError:errorMsg];
//            return;
//        }
//        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
//        [weakSelf.tableView reloadData];
//        
//    }tag:tag];
}

#pragma mark - custom
-(void)refreshDoctorInfoShow{
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:@"http://f.hiphotos.baidu.com/image/pic/item/0823dd54564e9258a4909fe99f82d158ccbf4e14.jpg"] placeholderImage:[UIImage imageNamed:@""]];
    
    self.tableView.tableHeaderView = self.headView;
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
