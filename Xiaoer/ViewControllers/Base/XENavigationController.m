//
//  XENavigationController.m
//  Xiaoer
//
//  Created by KID on 14/12/31.
//
//

#import "XENavigationController.h"

@interface XENavigationController ()

@end

@implementation XENavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- 禁止横竖屏切换
-(BOOL)shouldSupportRotate{
//    if ([[self.viewControllers lastObject] isKindOfClass:NSClassFromString(@"LSMWPhotoBrowser")]
//        || [[self.viewControllers lastObject] isKindOfClass:NSClassFromString(@"LSCommonWebVc")]
//        ){
//        return YES;
//    }
    return NO;
}
//5.0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([self shouldSupportRotate]){
        return YES;
    }
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//6.0
- (BOOL)shouldAutorotate{
    return [self shouldSupportRotate];
}
- (NSUInteger)supportedInterfaceOrientations{
    if ([self shouldSupportRotate])
        return UIInterfaceOrientationMaskAll;
    else
        return UIInterfaceOrientationMaskPortrait;
}

- (UIViewController *)XEpopViewControllerAnimated:(id)animated {
    return [super popViewControllerAnimated:[animated boolValue]];
}

@end
