//
//  shopOtherViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/16.
//
//

#import "shopOtherViewController.h"

@interface shopOtherViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *OTHER;

@end

@implementation shopOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.OTHER.image = [UIImage imageNamed:@"正在建设中6p"];
    // Do any additional setup after loading the view from its nib.
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
