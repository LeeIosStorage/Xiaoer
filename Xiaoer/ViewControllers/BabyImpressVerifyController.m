//
//  BabyImpressVerifyController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/23.
//
//

#import "BabyImpressVerifyController.h"
#import "AppDelegate.h"
#import "AddAddressViewController.h"
#import "AddressManagerController.h"
#import "XEAddressListInfo.h"
#import "BabyImpressPayWayController.h"
#import <QiniuSDK.h>
#import "BabyImpressMyPictureController.h"




@interface BabyImpressVerifyController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,postInfoDelegate,refreshAddtessInfoDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIView *noAddressView;
@property (strong, nonatomic) IBOutlet UIView *haveAddressView;
@property (strong, nonatomic) IBOutlet UIView *noPayWayView;
@property (strong, nonatomic) IBOutlet UIView *havePayView;
@property (strong, nonatomic) IBOutlet UIView *noteView;

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (nonatomic,assign)BOOL ifHavePayWay;


@property (nonatomic,strong)XEAddressListInfo *addressInfo;
@property (weak, nonatomic) IBOutlet UILabel *infoPhone;
@property (weak, nonatomic) IBOutlet UILabel *infoAddress;
@property (weak, nonatomic) IBOutlet UILabel *infoName;

@end

@implementation BabyImpressVerifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.tableview.backgroundColor = [UIColor clearColor];
    self.verifyBtn.layer.cornerRadius = 5;
    self.verifyBtn.layer.masksToBounds = YES;
    self.ifHavePayWay = NO;
    [self configureTableView];
    
    
    
    
    
//      七牛
    NSString *token = @"从服务端SDK获取";
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSData *data = [@"Hello, World!" dataUsingEncoding : NSUTF8StringEncoding];
    
    for (int i = 0; i < 10; i++) {
        [appDelegate.upManager putData:data key:@"hello" token:token
                              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                  NSLog(@"1 %@", info);
                                  NSLog(@"2 %@", resp);
                              } option:nil];
    }
  
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)verrfyBtnTouched:(id)sender {
    NSLog(@"确定");
    if (self.view.frame.origin.y == 0) {
    } else {
        [self animtionTabView];
    }
    BabyImpressMyPictureController *picture = [[BabyImpressMyPictureController alloc]init];
    [self.navigationController pushViewController:picture  animated:YES];
    
}

- (IBAction)noAddressBtnTouched:(id)sender {
    AddAddressViewController *add = [[AddAddressViewController alloc]init];
    add.delegate = self;
    [self.navigationController pushViewController:add animated:YES];
}
- (void)postInfoWith:(XEAddressListInfo *)info{
    NSLog(@"info === %@",info);
    self.addressInfo = info;
    self.tableview.tableHeaderView = [self returnAddressView];
}
- (IBAction)haveAddressBtnTouched:(id)sender {
    AddressManagerController *manager = [[AddressManagerController alloc]init];
    manager.delegate = self;
    [self.navigationController pushViewController:manager animated:YES];
}
- (void)refreshAddressInfoWith:(XEAddressListInfo *)info{
    NSLog(@"info === %@",info);
    self.addressInfo = info;
    self.tableview.tableHeaderView = [self returnAddressView];
}
- (IBAction)noPayBtnTouched:(id)sender {
    BabyImpressPayWayController *payWay = [[BabyImpressPayWayController alloc]init];
    [self.navigationController pushViewController:payWay animated:YES];
}

- (void)configureTableView{
    [self.tableview  registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableview.delegate  = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [self creatFooterView];
    self.tableview.tableHeaderView = [self returnAddressView];
    
    self.textView.delegate = self;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 8;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
}

- (UIView *)creatFooterView{
    for (UIView *view in self.tableview.tableFooterView.subviews) {
        [view removeFromSuperview];
    }
    
    
    UIView *footer = [[UIView alloc]init];
    UIView *payWay = [self returhPayWayView];
    
    self.noteView.frame = CGRectMake(0, payWay.frame.size.height, SCREEN_WIDTH, 140);
    self.footerView.frame = CGRectMake(0, payWay.frame.size.height + self.noteView.frame.size.height, SCREEN_WIDTH, 130);
    footer.frame = CGRectMake(0, 0, SCREEN_WIDTH, payWay.frame.size.height + self.noteView.frame.size.height + self.footerView.frame.size.height);
    [footer addSubview:payWay];
    [footer addSubview:self.noteView];
    [footer addSubview:self.footerView];
    return footer;
}
- (UIView *)returnAddressView{

    if (!self.addressInfo.id) {
        return  self.noAddressView;
    }else{
        self.infoAddress.text = self.addressInfo.address;
        self.infoName.text = self.addressInfo.name;
        self.infoPhone.text = self.addressInfo.phone;
        return self.haveAddressView;
    }
}

- (UIView *)returhPayWayView{
    
    if (self.ifHavePayWay == NO) {
        self.noPayWayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        return self.noPayWayView;
    }else{
        self.havePayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 135);

        return self.havePayView;
    }
    
}


#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 回车键 回收键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark 
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self animtionTabView];
}
- (void)animtionTabView{
    if (SCREEN_HEIGHT >= 568) {
        return;
    }
    if (self.view.frame.origin.y == 0) {
        NSLog(@"1");
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.tableview setContentOffset:CGPointMake(0, 0) animated:NO];
            self.view.frame = CGRectMake(0, - (SCREEN_WIDTH/3), SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
        
    } else {
        NSLog(@"2");
        [UIView animateWithDuration:0.3 animations:^{
            [self.tableview setContentOffset:CGPointMake(0, 0) animated:NO];
            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.view.frame.origin.y == 0) {
        NSLog(@"1");
        
    } else {
        NSLog(@"2");
        [self animtionTabView];
    }
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
