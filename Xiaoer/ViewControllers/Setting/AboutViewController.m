//
//  AboutViewController.m
//  Xiaoer
//
//  Created by KID on 15/2/5.
//
//

#import "AboutViewController.h"
#import "XELinkerHandler.h"
#import "XEEngine.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    [self setTitle:@"关于"];
}

- (IBAction)protocolAction:(id)sender {
    NSString *url = [[NSString stringWithFormat:@"%@/%@",[XEEngine shareInstance].baseUrl,@"agreement"] description];
    id vc = [XELinkerHandler handleDealWithHref:url From:self.navigationController];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end