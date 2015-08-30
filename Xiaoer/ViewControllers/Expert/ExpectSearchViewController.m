//
//  ExpectSearchViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/8/29.
//
//

#import "ExpectSearchViewController.h"
@interface ExpectSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UIView *chooseTypeView;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;



@property (weak, nonatomic) IBOutlet UIButton *rollBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchContentLab;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

/**
 *  入园
 */
- (IBAction)getInTouched:(id)sender;
/**
 *  营养
 */
- (IBAction)nurationTouched:(id)sender;
/**
 *  养育
 */
- (IBAction)raiseTouched:(id)sender;
/**
 *  心理
 */
- (IBAction)heartTouched:(id)sender;


- (IBAction)typeBtnTouched:(id)sender;
- (IBAction)cancleBtnTouched:(id)sender;

@end

@implementation ExpectSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    [self configureTableView];
    [self configureTypeView];
    

    
}


- (void)configureTypeView{
    self.chooseTypeView.frame = CGRectMake(10, 100, 60, 125);
    [self.view addSubview:self.chooseTypeView];
    self.chooseTypeView.hidden = YES;
    self.searchContentLab.delegate = self;
    self.searchContentLab.keyboardType = UIReturnKeySearch;
}

- (void)configureTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.headerView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];

}

#pragma mark  tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.headerView.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}


- (void)changeTypeBtnTitleWith:(UIButton *)button{
    self.chooseTypeView.hidden =! self.chooseTypeView.hidden;
    [self.typeBtn setTitle:button.titleLabel.text forState:UIControlStateNormal];
    
}
- (IBAction)getInTouched:(id)sender {
    NSLog(@"入园");
    UIButton *button = (UIButton *)sender;
    [self changeTypeBtnTitleWith:button];

}

- (IBAction)nurationTouched:(id)sender {
    NSLog(@"营养");
    UIButton *button = (UIButton *)sender;
    [self changeTypeBtnTitleWith:button];
    

}

- (IBAction)raiseTouched:(id)sender {
    NSLog(@"养育");
    UIButton *button = (UIButton *)sender;
    [self changeTypeBtnTitleWith:button];

}

- (IBAction)heartTouched:(id)sender {
    NSLog(@"心理");
    UIButton *button = (UIButton *)sender;
    [self changeTypeBtnTitleWith:button];

}

- (IBAction)typeBtnTouched:(id)sender {
    
    self.chooseTypeView.hidden = NO;
}

- (IBAction)cancleBtnTouched:(id)sender {
    [self.searchContentLab resignFirstResponder];
}


#pragma mark texeFiled delagate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField;
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
#warning 在此处执行搜索功能
    NSLog(@"搜索  %@",textField.text);
    return YES;
}
@end
