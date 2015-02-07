//
//  SettingViewController.m
//  Xiaoer
//
//  Created by KID on 15/2/5.
//
//

#import "SettingViewController.h"
#import "SettingViewCell.h"
#import "XEAlertView.h"
#import "XEEngine.h"
#import "XECommonUtils.h"
#import "WelcomeViewController.h"
#import "AboutViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "XEProgressHUD.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *setTableView;

@property (assign, nonatomic) unsigned long long cacheSize;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:UIColorRGB(234, 234, 234)];
    // Do any additional setup after loading the view from its nib.
    [self getCacheSize];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    [self setTitle:@"设置"];
}

- (void)getCacheSize{
    //获取缓存文件大小
    self.cacheSize = UINT64_MAX;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        unsigned long long size = [XECommonUtils getDirectorySizeForPath:[[XEEngine shareInstance] xeInstanceDocPath]];
        size += [[SDImageCache sharedImageCache] getSize];
        size += [[XEEngine shareInstance] getUrlCacheSize];
        __weak SettingViewController* weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.cacheSize = size;
            [weakSelf.setTableView reloadData];
        });
    });
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingViewCell";
    SettingViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }

    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"清理缓存";
                if (self.cacheSize != UINT64_MAX) {
                    NSString* cacheSizeStr = @"";
                    if (self.cacheSize > 1024*1024*1024) {
                        cacheSizeStr = [NSString stringWithFormat:@"%.2f GB", self.cacheSize*1.0/(1024*1024*1024)];
                    } else {
                        cacheSizeStr = [NSString stringWithFormat:@"%.2f MB", self.cacheSize*1.0/(1024*1024)];
                    }
                    cell.rightLabel.text = cacheSizeStr;
                    cell.rightLabel.hidden = NO;
                }
                break;
            }else if (indexPath.row == 1){
                cell.titleLabel.text = @"检查更新";
                break;
            }
//            else if (indexPath.row == 2){
//                cell.titleLabel.text = @"给我评分";
//                cell.indicatorImage.hidden = YES;
//                break;
//            }
            else if (indexPath.row == 2){
                cell.titleLabel.text = @"关于我们";
                break;
            }
        }
        case 1:{
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"退出当前帐号";
                cell.indicatorImage.hidden = YES;
                break;
            }else if (indexPath.row == 1){
                if ([XEEngine shareInstance].serverPlatform == OnlinePlatform) {
                    cell.titleLabel.text = @"测试环境";
                }else{
                    cell.titleLabel.text = @"线上环境";
                }
                cell.indicatorImage.hidden = YES;
                break;
            }
        }
        default:
            break;
    }
    
    if (indexPath.row == 0) {
       // cell.topline.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                [self showClearCacheAction];
                break;
            }else if (indexPath.row == 1){
                [self checkVersion];
                break;
            }else if (indexPath.row == 2){
                AboutViewController *aVc = [[AboutViewController alloc] init];
                [self.navigationController pushViewController:aVc animated:YES];
                break;
            }
        }
        case 1:{
            if (indexPath.row == 0) {
                [[XEEngine shareInstance] logout];
                WelcomeViewController *weVc = [[WelcomeViewController alloc] init];
                [self.navigationController pushViewController:weVc animated:YES];
                break;
            }else if (indexPath.row == 1){
                [self onLogoutWithError:nil];
                break;
            }
        }
        default:
            break;
    }
    
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
}

- (void)onLogoutWithError:(NSError *)error {
    if ([XEEngine shareInstance].serverPlatform == TestPlatform) {
        [XEEngine shareInstance].serverPlatform = OnlinePlatform;
    } else {
        [XEEngine shareInstance].serverPlatform = TestPlatform;
    }
    AppDelegate * appDelgate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSLog(@"signOut for user logout");
    [appDelgate signOut];
}

- (void)checkVersion{
//    int tag = [[XEEngine shareInstance] getConnectTag];
//    [XEProgressHUD AlertLoading:@"正在获取版本..."];
    
//    [[XEEngine shareInstance] getAppInItunsInfoWithtag:tag error:nil];
//    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//        
//        if (!jsonRet || err){
//            
//            return ;
//            
//        }
//        NSString *localVserion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
//        
//        for (NSDictionary* dic in [jsonRet objectForKey:@"results"]) {
//            NSString* version = [dic objectForKey:@"version"];
//            NSString* releaseNotes = [dic objectForKey:@"releaseNotes"];
//            if ([XECommonUtils isVersion:version greaterThanVersion:localVserion]) {
//                
//                XEAlertView *alertView = [[XEAlertView alloc] initWithTitle:@"新版本已上线" message:[NSString stringWithFormat:@"%@", releaseNotes] cancelButtonTitle:@"取消" cancelBlock:nil okButtonTitle:@"立刻更新" okBlock:^{
////                    NSURL *url = [[ NSURL alloc ] initWithString: @"http://itunes.apple.com/app/idxxxxxxx"] ;
////                    [[UIApplication sharedApplication] openURL:url];
//                }];
//                [alertView show];
//                
//                return;
//            }
//            break;
//        }
//        [XEProgressHUD AlertSuccess:@"当前版本已经是最新版本"];
//        
//    } tag:tag];
     [XEProgressHUD AlertSuccess:@"当前版本已经是最新版本"];
}

- (void)showClearCacheAction
{
    __weak SettingViewController* weakSelf = self;
    XEAlertView *alertView = [[XEAlertView alloc] initWithTitle:@"确认清除" message:@"是否清除本地所有图片和内容缓存" cancelButtonTitle:@"取消" cancelBlock:^{
    } okButtonTitle:@"清除" okBlock:^{
        [weakSelf clearCacheAction];
    }];
    [alertView show];
}

- (void)clearCacheAction{
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];

    [[XEEngine shareInstance] clearAllCache];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSFileManager defaultManager] removeItemAtPath:[[XEEngine shareInstance] xeInstanceDocPath] error:nil];
        [[NSFileManager defaultManager] createDirectoryAtPath:[[XEEngine shareInstance] xeInstanceDocPath] withIntermediateDirectories:YES attributes:nil error:nil];
    });
    self.cacheSize = 0;
    [self.setTableView reloadData];
    [XEProgressHUD AlertSuccess:@"缓存已清空"];
}

@end