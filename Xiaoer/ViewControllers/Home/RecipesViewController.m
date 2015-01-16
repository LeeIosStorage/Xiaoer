//
//  RecipesViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import "RecipesViewController.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"

@interface RecipesViewController ()

@property (strong, nonatomic) IBOutlet UIView *categoryView;
@property (strong, nonatomic) IBOutlet UIScrollView *categoryScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *contentView;


@end

@implementation RecipesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     [self setTitle:@"食谱"];
   // [self getCategoryInfo];
    [self getListInfo];
}

- (void)getCategoryInfo{
    [XEProgressHUD AlertLoading];
    __weak RecipesViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getBannerWithTag:tag];
    [[XEEngine shareInstance] getInfoWithBabyId:nil tag:tag];
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

        [XEProgressHUD AlertSuccess:@"获取成功."];
    }tag:tag];
}

- (void)getListInfo{
    [XEProgressHUD AlertLoading];
    __weak RecipesViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getListInfoWithNum:@"0" stage:@"1" cat:@"1" tag:tag];
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
        
        [XEProgressHUD AlertSuccess:@"获取成功."];
    }tag:tag];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    [self setRightButtonWithTitle:@"我收藏" selector:@selector(settingAction)];
}

- (void)settingAction{
    
    NSLog(@"=================我的收藏");
}


@end
