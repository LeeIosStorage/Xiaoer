//
//  XEPublicViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/20.
//
//

#import "XEPublicViewController.h"

@interface XEPublicViewController ()

@end

@implementation XEPublicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews
{
    //title
    [self setTitle:@"发话题"];
    if (_publicType == Public_Type_Expert) {
        [self setTitle:@"问专家"];
    }
    [self setRightButtonWithTitle:@"发送" selector:@selector(sendAction:)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - custom
-(void)refreshViewUI{
    
}

-(void)sendAction:(id)sender{
    
}

@end
