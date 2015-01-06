//
//  RetrievePwdViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/6.
//
//

#import "RetrievePwdViewController.h"

@interface RetrievePwdViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *retrieveImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *noticeLabel;
@property (strong, nonatomic) IBOutlet UIView *phoneNumView;
@property (strong, nonatomic) IBOutlet UIButton *verifyButton;
@property (strong, nonatomic) IBOutlet UIButton *commitButton;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *commitTextField;

- (IBAction)getCodeAction:(id)sender;
- (IBAction)sendAction:(id)sender;

@end

@implementation RetrievePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    //title
    [self setTitle:@"手机找回密码"];
}

- (IBAction)getCodeAction:(id)sender {
    
}

- (IBAction)sendAction:(id)sender {
    
}



@end
