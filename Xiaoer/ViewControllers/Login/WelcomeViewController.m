//
//  WelcomeViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/13.
//
//

#import "WelcomeViewController.h"
#import "LoginViewController.h"

#import "AppDelegate.h"
#import "MainPageViewController.h"
#import "EvaluationViewController.h"
#import "ExpertChatViewController.h"
#import "MineTabViewController.h"
#import "XENavigationController.h"

@interface WelcomeViewController ()

- (IBAction)loginAction:(id)sender;
- (IBAction)registerAction:(id)sender;
- (IBAction)visitorAction:(id)sender;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.titleNavBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    LoginViewController *mpVc = [[LoginViewController alloc] init];
    mpVc.vcType = VcType_Login;
    [self.navigationController pushViewController:mpVc animated:YES];
}

- (IBAction)registerAction:(id)sender {
    LoginViewController *mpVc = [[LoginViewController alloc] init];
    mpVc.vcType = VcType_Register;
    [self.navigationController pushViewController:mpVc animated:YES];
}

- (IBAction)visitorAction:(id)sender {
    XETabBarViewController* tabViewController = [[XETabBarViewController alloc] init];
    tabViewController.viewControllers = [NSArray arrayWithObjects:
                                         [[MainPageViewController alloc] init],
                                         [[EvaluationViewController alloc] init],
                                         [[ExpertChatViewController alloc] init],
                                         [[MineTabViewController alloc] init],
                                         nil];
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.mainTabViewController = tabViewController;
    
    XENavigationController* tabNavVc = [[XENavigationController alloc] initWithRootViewController:tabViewController];
    tabNavVc.navigationBarHidden = YES;
    appDelegate.window.rootViewController = tabNavVc;
    
    MainPageViewController *mpVc = [[MainPageViewController alloc] init];
    [self.navigationController pushViewController:mpVc animated:YES];
    
}

@end
