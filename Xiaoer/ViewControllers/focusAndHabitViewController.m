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

@interface focusAndHabitViewController ()
/**
 *  好习惯
 */
@property (nonatomic,strong)RecipesViewController *Recipes1;
/**
 *  专注力
 */
@property (nonatomic,strong)RecipesViewController *Recipes2;

@end

@implementation focusAndHabitViewController


/**
 好习惯
 */

- (RecipesViewController *)Recipes1{
    if (!_Recipes1) {
        self.Recipes1 = [[RecipesViewController alloc]init];
        _Recipes1.infoType = TYPE_HABIT;
    }
    return _Recipes1;
}


/**
 专注力
 */

- (RecipesViewController *)Recipes2{
    if (!_Recipes2) {
        self.Recipes2 = [[RecipesViewController alloc]init];
        _Recipes2.infoType = TYPE_ATTENTION;
    }
    return _Recipes2;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewController:self.Recipes2];
    [self addChildViewController:self.Recipes1];
    [self.view addSubview:self.Recipes2.view];
    [self.view addSubview:self.Recipes1.view];
    
    [self.view insertSubview:self.Recipes2.view belowSubview:self.titleNavBar];
    [self.view insertSubview:self.Recipes1.view belowSubview:self.titleNavBar];

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    view.backgroundColor = [UIColor redColor];
    self.Recipes2.navigationItem.titleView = view;
    self.Recipes1.navigationController.navigationItem.titleView = view;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"card_status_bg"]];
    [self setTitleNavImageView:imageView];

    
}

-(void)initNormalTitleNavBarSubviews{
    [self setSegmentedControlWithSelector:@selector(touchSegment:) items:@[@"好习惯指导",@"专注力指导"]];
}

- (void)touchSegment:(UISegmentedControl *)sender{
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self.view insertSubview:self.Recipes2.view belowSubview:self.titleNavBar];
            [self.view insertSubview:self.Recipes1.view belowSubview:self.titleNavBar];
            break;
        case 1:
            [self.view insertSubview:self.Recipes1.view belowSubview:self.titleNavBar];
            [self.view insertSubview:self.Recipes2.view belowSubview:self.titleNavBar];
            break;
        default:
            break;
    }
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
