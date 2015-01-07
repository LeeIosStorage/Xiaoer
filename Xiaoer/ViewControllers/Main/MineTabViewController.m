//
//  MineTabViewController.m
//  Xiaoer
//
//  Created by KID on 14/12/30.
//
//

#import "MineTabViewController.h"

@interface MineTabViewController ()

@end

@implementation MineTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"我的"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    
    [self setTitle:@"我的"];
    
    [self setRightButtonWithTitle:@"设置" selector:@selector(settingAction)];
}

- (void)settingAction
{
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"还没好还没好！！！"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"知道了", nil];
    [Alert show];
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
