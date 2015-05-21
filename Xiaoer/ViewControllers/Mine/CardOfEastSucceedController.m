//
//  CardOfEastSucceedController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/5/19.
//
//

#import "CardOfEastSucceedController.h"
#import "CardOfEastWebViewController.h"
@interface CardOfEastSucceedController ()

@end

@implementation CardOfEastSucceedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"卡券详情";
    NSLog(@"Succeedself.cardinfo---------- %@",self.cardinfo.price);
    
}
- (IBAction)howToUse:(id)sender {
    NSLog(@"如何使用");
}

- (IBAction)showCardWebView:(id)sender {
    
    
    CardOfEastWebViewController *webView = [[CardOfEastWebViewController alloc]initWithNibName:@"CardOfEastWebViewController" bundle:nil];
    webView.cardinfo = self.cardinfo;

    UILabel *lable1 = (UILabel *)[webView.view viewWithTag:1000];
    UILabel *lable2 = (UILabel *)[webView.view viewWithTag:1001];
    [self.navigationController pushViewController:webView animated:YES];
    webView.hideCardInfo = NO;
    webView.cardNumber.text = [NSString stringWithFormat:@"券号:%@",self.cardNum.text];
    webView.password.text = [NSString stringWithFormat:@"密码：%@",self.cardPassWord.text] ;
    
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
