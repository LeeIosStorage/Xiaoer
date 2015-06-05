//
//  focusAndHabitViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/5.
//
//
//#import "MineTopicListViewController.h"

#import "focusAndHabitViewController.h"
#import "RecipesViewController.h"
#import "LoginViewController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "XEProgressHUD.h"
#import "XEEngine.h"
#import "RetrievePwdViewController.h"
#import "SetPwdViewController.h"
#import "XEUserInfo.h"
#import "AppDelegate.h"
#import "NSString+Value.h"
#import "XELinkerHandler.h"
#import "XECommonWebVc.h"
#import "XEActionSheet.h"
#import "WXApi.h"
@interface focusAndHabitViewController ()
@property (nonatomic,strong)RecipesViewController *Recipes1;
@property (nonatomic,strong)RecipesViewController *Recipes2;
@property (nonatomic,strong)RecipesViewController *currentVC;
@property (nonatomic,strong)UISegmentedControl *segment;
@property (nonatomic,assign)NSInteger selectedSegmentIndex;

@end

@implementation focusAndHabitViewController
- (UISegmentedControl *)segment{
    if (!_segment) {
        self.segment = [[UISegmentedControl alloc]initWithItems:@[@"好习惯指导",@"专注力指导"]];
        _segment.frame = CGRectMake(20, 100, 200, 40);
        [_segment addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}
- (void)viewDidLoad {
    [super viewDidLoad];


    self.Recipes1 = [[RecipesViewController alloc]init];
    self.Recipes1.infoType = TYPE_HABIT;
    
    self.Recipes2 = [[RecipesViewController alloc]init];
    self.Recipes2.infoType = TYPE_ATTENTION;
    
    [self addChildViewController:self.Recipes2];
    self.Recipes1.title = @"";
    self.Recipes2.title = @"";
    [self addChildViewController:self.Recipes1];
    [self.view addSubview:self.Recipes2.view];
    [self.view addSubview:self.Recipes1.view];
    
//    [self.Recipes1 setSegmentedControlWithSelector:@selector(touchSegment:) items:@[@"好习惯指导",@"专注力指导"]];
//    [self setSegmentedControlWithSelector:@selector(segmentedControlAction) items:@[@"活动报名",@"历史活动"]];
//    [self.Recipes1 setSegmentedControlWithSelector:@selector(segmentedControlAction) items:@[@"活动报名",@"历史活动"]];
    [self.Recipes1.view addSubview:self.segment];
    [self.Recipes1.view addSubview:self.segment];
//    self.Recipes1.segmentedControl = self.segment;
    
}
-(void)segmentedControlAction:(UISegmentedControl *)segment{
    NSLog(@"%ld",(long)self.Recipes1.segmentedControl.selectedSegmentIndex);
    switch (segment.selectedSegmentIndex) {
        case 0:{
            [self addChildViewController:self.Recipes1];

            [self transitionFromViewController:self.Recipes2 toViewController:self.Recipes1 duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
                
                if (finished) {
                    
                    [self.Recipes1 didMoveToParentViewController:self];
                    [self.Recipes2 willMoveToParentViewController:nil];
                    [self.Recipes2 removeFromParentViewController];

                    
                }else{
                    
                    
                }
            }];
        }
            [self.Recipes1.view addSubview:self.segment];
            [self.Recipes1.view addSubview:self.segment];
  
            break;
        case 1:
        {
            [self addChildViewController:self.Recipes2];

            [self transitionFromViewController:self.Recipes1 toViewController:self.Recipes2 duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
                
                if (finished) {
                    
                    [self.Recipes2 didMoveToParentViewController:self];
                    [self.Recipes1 willMoveToParentViewController:nil];
                    [self.Recipes1 removeFromParentViewController];

                    
                }else{
                    
                    
                }
            }];
        }
            [self.Recipes1.view addSubview:self.segment];
            [self.Recipes1.view addSubview:self.segment];
            
            break;
        default:
            break;
    }


}

//  切换各个标签内容
- (void)replaceController:(RecipesViewController *)oldController newController:(RecipesViewController *)newController
{
    /**
     *			着重介绍一下它
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController	  当前显示在父视图控制器中的子视图控制器
     *  toViewController		将要显示的姿势图控制器
     *  duration				动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options				 动画效果(渐变,从下往上等等,具体查看API)
     *  animations			  转换过程中得动画
     *  completion			  转换完成
     */
    
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
            
        }else{
            
            
        }
    }];
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

@end
