//
//  BabyImpressVerifyController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/23.
//
//

#import "BabyImpressVerifyController.h"

@interface BabyImpressVerifyController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIView *noAddressView;
@property (strong, nonatomic) IBOutlet UIView *haveAddressView;
@property (strong, nonatomic) IBOutlet UIView *noPayWayView;
@property (strong, nonatomic) IBOutlet UIView *havePayView;
@property (strong, nonatomic) IBOutlet UIView *noteView;

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic,assign)BOOL ifHaveAddress;
@property (nonatomic,assign)BOOL ifHavePayWay;


@end

@implementation BabyImpressVerifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.tableview.backgroundColor = [UIColor clearColor];
    
    self.ifHaveAddress = NO;
    self.ifHavePayWay = NO;
    [self configureTableView];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)configureTableView{
    [self.tableview  registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableview.delegate  = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = self.footerView;
    self.tableview.tableHeaderView = [self creatTabHeaderView];
    
    self.textView.delegate = self;
    self.textView.frame = CGRectMake(40, 40, SCREEN_WIDTH - 80, 80);
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 8;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
}
#pragma mark  headerView
- (UIView *)creatTabHeaderView{
    for (UIView *view in self.tableview.tableHeaderView.subviews) {
        [view removeFromSuperview];
    }
    
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = [UIColor whiteColor];
    
    UIView *address = [self returnAddressView];
    [header addSubview:address];
    
    UIView *payWay = [self returhPayWayView];
    payWay.frame = CGRectMake(0, address.frame.size.height, SCREEN_WIDTH, payWay.frame.size.height);
    [header addSubview:payWay];
    
    
    self.noteView.frame = CGRectMake(0, address.frame.size.height + payWay.frame.size.height, SCREEN_WIDTH, 140);
    [header addSubview:self.noteView];
    
    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, address.frame.size.height + payWay.frame.size.height + self.noteView.frame.size.height);
    return header;
}

- (UIView *)returnAddressView{
    if (self.ifHaveAddress == NO) {
        return  self.noAddressView;
    }else{
        return self.haveAddressView;
    }
}

- (UIView *)returhPayWayView{
    
    if (self.ifHavePayWay == NO) {
        return self.noPayWayView;
    }else{
        return self.haveAddressView;
    }
    
}


#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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
