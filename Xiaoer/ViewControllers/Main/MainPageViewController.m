//
//  MainPageViewController.m
//  Xiaoer
//
//  Created by KID on 14/12/30.
//
//

#import "MainPageViewController.h"
#import "XETabBarViewController.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XEThemeInfo.h"

@interface MainPageViewController ()

@property (nonatomic, strong) NSMutableArray *adsThemeArray;

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"首页"];
    
    __weak MainPageViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getBannerWithTag:tag];
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
        NSLog(@"jsonRet===============%@",jsonRet);
        weakSelf.adsThemeArray = [NSMutableArray array];
        NSArray *themeDicArray = [jsonRet arrayObjectForKey:@"object"];
        for (NSDictionary *dic  in themeDicArray) {
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            XEThemeInfo *theme = [[XEThemeInfo alloc] init];
            [theme setThemeInfoByDic:dic];
            [weakSelf.adsThemeArray addObject:theme];
        }
        
        [XEProgressHUD AlertSuccess:@"登录成功."];
    }tag:tag];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    
    [self setLeftButtonWithSelector:@selector(settingAction:)];
//    [self setRightButtonWithTitle:@"按钮" selector:@selector(settingAction:)];
}

- (UINavigationController *)navigationController{
    if ([super navigationController]) {
        return [super navigationController];
    }
    return self.tabController.navigationController;
}



#pragma mark - IBAction
//-(void)backAction:(id)sender{
//    
//}
-(void)settingAction:(id)sender{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
