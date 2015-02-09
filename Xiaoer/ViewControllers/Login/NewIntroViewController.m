//
//  NewIntroViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/6.
//
//

#import "NewIntroViewController.h"
#import "NewIntroView.h"
#import "XESettingConfig.h"

@interface NewIntroViewController ()

@property (nonatomic, retain) NewIntroView *introView;

@end

@implementation NewIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createPages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)isHasNormalTitle
{
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)createPages
{
    UIImage *page1 = [UIImage imageNamed:@"welcome1"];
    UIImage *page2 = [UIImage imageNamed:@"welcome2"];
    UIImage *page3 = [UIImage imageNamed:@"welcome3"];
    UIImage *page4 = [UIImage imageNamed:@"welcome4"];
//    UIImage *page5 = [UIImage imageNamed:@"welcome5"];
    
    _introView = [[NewIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1, page2, page3, page4]];
    __weak NewIntroViewController *weakSelf = self;
    [_introView setLoginIntroCallBack:^(){
        [weakSelf loginAction];
    }];
    [self.view addSubview:_introView];
    [XESettingConfig saveEnterVersion];
}

-(void)loginAction{
    if (_delegate && [_delegate respondsToSelector:@selector(introduceVcFinish:)] ) {
        [_delegate introduceVcFinish:self];
    }
}
@end
