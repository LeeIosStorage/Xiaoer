//
//  MainPageViewController.m
//  Xiaoer
//
//  Created by KID on 14/12/30.
//
//

#import "MainPageViewController.h"

@interface MainPageViewController ()

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"首页"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    
    [self setLeftButtonWithSelector:@selector(settingAction:)];
    
    [self setRightButtonWithTitle:@"按钮" selector:@selector(settingAction:)];
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
