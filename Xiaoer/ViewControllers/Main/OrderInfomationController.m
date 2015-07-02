//
//  OrderInfomationController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/2.
//
//

#import "OrderInfomationController.h"
#import "OrderInfomationCell.h"
@interface OrderInfomationController ()<UITableViewDataSource,UITableViewDelegate,orderInfocellTextFieldEndEditing>
//底部的人确定按钮
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (nonatomic,strong)NSMutableArray *leftArray;
@property (nonatomic,strong)NSMutableArray *infomationArray;
@end

@implementation OrderInfomationController
-(NSMutableArray *)leftArray {
    if (!_leftArray) {
        self.leftArray = [NSMutableArray arrayWithObjects:@"收件人",@"手机号码",@"详细地址",@"预约时间",@"服务项目", nil];
    }
    return _leftArray;
}
- (NSMutableArray *)infomationArray{
    if (!_infomationArray) {
        self.infomationArray = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1",@"1", nil];
    }
    return _infomationArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约信息";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self configureTableView];
    [self configureVerifyBtnLayer];
    [self configureDataBackView];

    // Do any additional setup after loading the view from its nib.
}
#pragma mark 布局DataBackView

- (void)configureDataBackView{
    self.dataBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
    [self.view addSubview:self.dataBackView];
}
#pragma mark  布局底部确定按钮的layer
- (void)configureVerifyBtnLayer{
    self.verifyBtn.layer.borderWidth = 1;
    self.verifyBtn.backgroundColor = [UIColor whiteColor];
    self.verifyBtn.layer.borderColor = SKIN_COLOR.CGColor;
    self.verifyBtn.layer.cornerRadius = 5;
}
#pragma mark  布局tableview属性
- (void)configureTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderInfomationCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}


#pragma mark  取消按钮点击
- (IBAction)cancleBtnTouched:(id)sender {
    [self animationChooseDataView];
}
#pragma mark  dataBack 确定按钮点击
- (IBAction)dataBackVerifyBtnTouched:(id)sender {
    [self animationChooseDataView];
}


#pragma mark 底部确认按钮点击
- (IBAction)verifyBtnTouched:(id)sender {
    NSLog(@"底部确定");
}


#pragma mark datapickerView 动画
- (void)animationChooseDataView{
    if (self.dataBackView.frame.origin.y == (SCREEN_HEIGHT - 250)) {
        [UIView animateWithDuration:0.5 animations:^{
            self.dataBackView.frame = CGRectMake(0, SCREEN_HEIGHT + 250, SCREEN_WIDTH, 250);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.dataBackView.frame = CGRectMake(0, SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250);
        }];
    }
}

#pragma mark  tableView  delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.leftArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 8;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderInfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    [cell configurcellwithIndexPath:indexPath leftStr:[self.leftArray objectAtIndex:indexPath.section]];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        [self animationChooseDataView];
    }
}
#pragma mark cell delegate
- (void)passOrderInfocellLeftLableText:(NSString *)leftStr textFieldtext:(NSString *)textFieldText{
    
    if ([leftStr isEqualToString:@"收件人"]) {
        
        self.infomationArray[0] = leftStr;
        
    } else  if ([leftStr isEqualToString:@"手机号码"]){
        
        self.infomationArray[1] = leftStr;
        
    }else if ([leftStr isEqualToString:@"详细地址"]){
        
        self.infomationArray[2] = leftStr;
        
    }else if ([leftStr isEqualToString:@"预约时间"]){
        
        self.infomationArray[3] = leftStr;
        
    }else if ([leftStr isEqualToString:@"服务项目"]){
        
        self.infomationArray[4] = leftStr;
        
    }
    
    NSLog(@"leftStr %@ textFieldText  %@  ",leftStr,textFieldText);
}
#pragma mark  scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.dataBackView.frame.origin.y == (SCREEN_HEIGHT - 250)) {
        [self animationChooseDataView];
    } else {
        
    }
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
