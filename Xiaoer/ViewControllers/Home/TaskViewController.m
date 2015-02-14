//
//  TaskViewController.m
//  Xiaoer
//
//  Created by KID on 15/2/12.
//
//

#import "TaskViewController.h"

@interface TaskViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    [self setTitle:@"妈妈任务"];
    if(SCREEN_HEIGHT == 480){
        [self.bgImageView setImage:[UIImage imageNamed:@"common_task4_bg"]];
        CGRect frame = self.bgImageView.frame;
        frame.origin.y -= 30;
        self.bgImageView.frame = frame;
    }
}

@end
