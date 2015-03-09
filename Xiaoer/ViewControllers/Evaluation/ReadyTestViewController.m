//
//  ReadyTestViewController.m
//  xiaoer
//
//  Created by KID on 15/2/28.
//
//

#import "ReadyTestViewController.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"

@interface ReadyTestViewController ()

@end

@implementation ReadyTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getEvaToolSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews {
    
    [self setTitle:@"准备评测"];
}

- (void)getEvaToolSource{
    __weak ReadyTestViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
//    [[XEEngine shareInstance] getEvaToolWithStage:self.stageIndex tag:tag];
    [[XEEngine shareInstance] getEvaToolWithStage:1 tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        NSLog(@"=================%@",jsonRet);
    }tag:tag];
}

@end
