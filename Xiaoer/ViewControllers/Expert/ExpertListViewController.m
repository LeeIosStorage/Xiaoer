//
//  ExpertListViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import "ExpertListViewController.h"
#import "ExpertListViewCell.h"
#import "UIImageView+WebCache.h"
#import "ExpertIntroViewController.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XEDoctorInfo.h"
#import "XEPublicViewController.h"

@interface ExpertListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *expertList;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (assign, nonatomic) SInt64  nextCursor;

@end

@implementation ExpertListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = UIColorRGB(240, 240, 240);
    [self refreshExpertList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    [self setTitle:@"晓儿专家"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)refreshExpertList{
    
    [XEProgressHUD AlertLoading:@"数据加载中..."];
    __weak ExpertListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getExpertListWithPage:1 tag:tag];
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
        
        weakSelf.expertList = [[NSMutableArray alloc] init];
        NSArray *object = [[jsonRet objectForKey:@"object"] objectForKey:@"experts"];
        for (NSDictionary *dic in object) {
            XEDoctorInfo *doctorInfo = [[XEDoctorInfo alloc] init];
            [doctorInfo setDoctorInfoByJsonDic:dic];
            [weakSelf.expertList addObject:doctorInfo];
        }
        [weakSelf.tableView reloadData];
        
    }tag:tag];
    
    
}

#pragma mark - custom


#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _expertList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.row == 1) {
//        return 110;
//    }
    XEDoctorInfo *doctorInfo = _expertList[indexPath.row];
    return [ExpertListViewCell heightForDoctorInfo:doctorInfo];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ExpertListViewCell";
    ExpertListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        [cell.consultButton addTarget:self action:@selector(handleClickAt:event:) forControlEvents:UIControlEventTouchUpInside];
    }
    XEDoctorInfo *doctorInfo = _expertList[indexPath.row];
    cell.doctorInfo = doctorInfo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
    XEDoctorInfo *doctorInfo = _expertList[indexPath.row];
    ExpertIntroViewController *vc = [[ExpertIntroViewController alloc] init];
    vc.doctorInfo = doctorInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)handleClickAt:(id)sender event:(id)event{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil){
        NSLog(@"indexPath: row:%ld", indexPath.row);
//        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        XEDoctorInfo *doctorInfo = _expertList[indexPath.row];
        XEPublicViewController *vc = [[XEPublicViewController alloc] init];
        vc.publicType = Public_Type_Expert;
        vc.doctorInfo = doctorInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
