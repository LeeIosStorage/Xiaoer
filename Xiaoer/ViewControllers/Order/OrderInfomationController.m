//
//  OrderInfomationController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/2.
//
//

#import "OrderInfomationController.h"
#import "OrderInfomationCell.h"
#import "OrderCardHistoryController.h"
#import "XEDetailEticketsInfo.h"
#import "XEProgressHUD.h"
#import "NSString+Value.h"
#import "XEEngine.h"
@interface OrderInfomationController ()<UITableViewDataSource,UITableViewDelegate,orderInfocellTextFieldEndEditing,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
//底部的人确定按钮
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (nonatomic,strong)NSMutableArray *leftArray;
@property (nonatomic,strong)NSMutableArray *infomationArray;
@property (nonatomic,strong)NSMutableArray *rightArray;

//年月日时间
@property (nonatomic,strong)NSString *dataStr;
//小时分钟时间
@property (nonatomic,strong)NSString *timeStr;


@property (nonatomic,assign)BOOL touchDataPicker;

//保存卡券号数组
@property (nonatomic,strong)NSMutableArray *cardNumberArr;
//保存卡券号pickerview最后点击了那一行
@property (nonatomic,assign)NSInteger cardNumFinalIndex;

@end

@implementation OrderInfomationController
/**
 *
 */
- (NSMutableArray *)cardNumberArr{
    if (!_cardNumberArr) {
        self.cardNumberArr = [NSMutableArray array];
    }
    return _cardNumberArr;
}
-(NSMutableArray *)leftArray {
    if (!_leftArray) {
        self.leftArray = [NSMutableArray arrayWithObjects:@"收件人",@"手机号码",@"详细地址",@"预约券号",@"预约时间",@"服务项目", nil];
    }
    return _leftArray;
}


- (NSMutableArray *)infomationArray{
    if (!_infomationArray) {
        self.infomationArray = [NSMutableArray arrayWithCapacity:6];
    }
    return _infomationArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约信息";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.touchDataPicker = NO;
    
    for (XEDetailEticketsInfo *info in [self.goodInfo goodReturnEticketsArray]) {
        [self.cardNumberArr addObject:info.cardNo];
    }
    
    self.infomationArray[0] = self.detail.linkName;
    self.infomationArray[1] = self.detail.linkPhone;
    self.infomationArray[2] = self.detail.linkAddress;
    self.infomationArray[3] = self.cardNumberArr[0];
    self.infomationArray[4] = @"";
    self.infomationArray[5] = self.goodInfo.sercontent;
    
    [self configureTableView];
    [self configureVerifyBtnLayer];
    [self configureDataBackView];
    [self configureCardPickerBackView];
    [self setRightButtonWithTitle:@"历史记录" selector:@selector(PushToHistory)];
    
    NSLog(@"self.goodInfo.price == %@",self.goodInfo.price);
    
    

    

    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark  历史纪录
- (void)PushToHistory{
    OrderCardHistoryController *history = [[OrderCardHistoryController alloc]init];
    history.goodInfo = self.goodInfo;
    [self.navigationController pushViewController:history animated:YES];
}


#pragma mark 布局卡券选择器的backView
- (void)configureCardPickerBackView{
    self.cardPickerBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
    self.cardPickerView.delegate = self;
    self.cardPickerView.dataSource = self;
    [self.view addSubview:self.cardPickerBackView];
    
}
#pragma mark 布局DataBackView
- (void)configureDataBackView{
    self.dataBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
    self.dataPickerView.datePickerMode = UIDatePickerModeDate;//模式
    //设置为中文显示
    NSLocale *local = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    self.dataPickerView.locale = local;
    [self.dataPickerView addTarget:self action:@selector(dataChanged:) forControlEvents:UIControlEventValueChanged];
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


#pragma mark  日期取消按钮点击
- (IBAction)cancleBtnTouched:(id)sender {
    [self animationChooseDataView];
}
#pragma mark  dataBack 确定按钮点击
- (IBAction)dataBackVerifyBtnTouched:(id)sender {


    if (self.dataPickerView.datePickerMode == UIDatePickerModeDate) {
        NSDate *select  = [self.dataPickerView date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateAndTime = [dateFormatter stringFromDate:select];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"时间提示" message: dateAndTime delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];

    }else if (self.dataPickerView.datePickerMode ==UIDatePickerModeTime){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        if (self.touchDataPicker == YES) {
            NSDate *select  = [self.dataPickerView date];
            NSString * dateString = [dateFormatter stringFromDate:select];
            self.timeStr = dateString;
        }else{
            //现在时间
            NSDate *now = [NSDate date];
            NSString * dateString = [dateFormatter stringFromDate:now];
            self.timeStr = dateString;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"时间提示" message:self.timeStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}
#pragma mark 卡片取消按钮点击
- (IBAction)cardCancleBtnTouched:(id)sender {
    [self animationCardBackView];
}
#pragma mark 卡片确定按钮点击
- (IBAction)cardVerifyBtnTouched:(id)sender {
        self.infomationArray[3]= self.cardNumberArr[self.cardNumFinalIndex];
        [self.tableView reloadData];

    [self animationCardBackView];

}

#pragma mark 底部确认按钮点击
- (IBAction)verifyBtnTouched:(id)sender {
    NSLog(@"底部确定");
    NSString *name = self.infomationArray[0];
    if (name.length == 0) {
        [XEProgressHUD AlertError:@"请输入收件人" At:self.view];
        return;
    }
    

    /**
     *  检测用户手机号
     *
     */
    NSString *phone = self.infomationArray[1];
        if (![phone isPhone]) {
            [XEProgressHUD lightAlert:@"请输入正确的手机号"];
            return;
        }
    NSString *address = self.infomationArray[2];
    if (address.length == 0) {
        [XEProgressHUD AlertError:@"请输入地址" At:self.view];
        return;
    }
    
    NSString *time = self.infomationArray[4];
    if (time.length == 0) {
        [XEProgressHUD AlertError:@"请选择预约时间" At:self.view];
        return;
    }
    NSString *eticketid = nil;
    for (XEDetailEticketsInfo *etick in [self.goodInfo goodReturnEticketsArray]) {
        NSString *selectEtict = self.infomationArray[3];
        if ([selectEtict isEqualToString:etick.cardNo]) {
            eticketid = etick.id;
        }
    }
    
    __weak OrderInfomationController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance]getApplyOrderInfomationWith:tag userid:[XEEngine shareInstance].uid eticketid:eticketid linkname:self.infomationArray[0] linkphone:self.infomationArray[1] linkaddress:self.infomationArray[2] appointtime:self.infomationArray[4] sercontent:self.infomationArray[5]];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return ;
        }
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            return;
        }
        if ([jsonRet[@"object"] isKindOfClass:[NSNull class]]) {
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            return;
        }
        if ([[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertSuccess:@"预约成功" At:weakSelf.view];
            return;
        }
        

    } tag:tag];
    
    
    
}

#pragma mark 手动点击了datapicker
- (void)dataChanged:(id)sender{
    self.touchDataPicker = YES;
}

#pragma mark datapickerView 动画
- (void)animationChooseDataView{
    self.dataPickerView.datePickerMode = UIDatePickerModeDate;
    NSTimeInterval secondsPerDay = 24 * 60 * 60 * 3;
    NSDate *threeDayAfter = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
    [self.dataPickerView setMinimumDate:threeDayAfter];
    
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

#pragma mark cardBackView 动画
- (void)animationCardBackView{
    if (self.cardNumFinalIndex) {
        [self pickerView:self.cardPickerView didSelectRow:self.cardNumFinalIndex inComponent:0];
    }else{
        [self pickerView:self.cardPickerView didSelectRow:0 inComponent:0];
    }
    if (self.cardPickerBackView.frame.origin.y == (SCREEN_HEIGHT - 250)) {
        [UIView animateWithDuration:0.5 animations:^{
            self.cardPickerBackView.frame = CGRectMake(0, SCREEN_HEIGHT + 250, SCREEN_WIDTH, 250);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.cardPickerBackView.frame = CGRectMake(0, SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250);
        }];
    }
}

#pragma mark alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"取消");
        self.dataStr = @"";
        self.timeStr = @"";
    }else if (buttonIndex == 1){
        if (self.dataPickerView.datePickerMode == UIDatePickerModeDate) {
            NSDate *select  = [self.dataPickerView date];

            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *date = [dateFormatter stringFromDate:select];
            self.dataStr = date;
            self.dataPickerView.datePickerMode =UIDatePickerModeTime;

        }else if (self.dataPickerView.datePickerMode == UIDatePickerModeTime){

            self.infomationArray[4]= [NSString stringWithFormat:@"%@ %@",self.dataStr,self.timeStr];
            NSLog(@"self.infomationArray[4] == %@",self.infomationArray[4]);
            [self.tableView reloadData];
            [self animationChooseDataView];
        }
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
    cell.tag = indexPath.section;
    [cell configurcellwithIndexPath:indexPath leftStr:[self.leftArray objectAtIndex:indexPath.section] rightStr:[self.infomationArray objectAtIndex:indexPath.section]];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        [self.view endEditing:YES];

        if (self.cardPickerBackView.frame.origin.y == (SCREEN_HEIGHT - 250)) {
            [self animationCardBackView];
        }
        [self animationChooseDataView];
    }
    if (indexPath.section == 3) {
        [self.view endEditing:YES];
        if (self.dataBackView.frame.origin.y == (SCREEN_HEIGHT - 250)) {
            [self animationChooseDataView];
        }
        [self animationCardBackView];
    }
}

#pragma mark cell delegate
- (void)passOrderInfocellLeftLableText:(NSString *)leftStr textFieldtext:(NSString *)textFieldText textFieldTag:(NSInteger)tag{
    
    if ([leftStr isEqualToString:@"收件人"]) {
        
        self.infomationArray[0] = textFieldText;
        
    } else  if ([leftStr isEqualToString:@"手机号码"]){
        
        self.infomationArray[1] = textFieldText;
        
    }else if ([leftStr isEqualToString:@"详细地址"]){
        
        self.infomationArray[2] = textFieldText;
        
    }
    else if ([leftStr isEqualToString:@"预约券号"]){
        self.infomationArray[3] = textFieldText;
    }
    
    else if ([leftStr isEqualToString:@"预约时间"]){
        self.infomationArray[4] = textFieldText;
        
    }else if ([leftStr isEqualToString:@"服务项目"]){
        self.infomationArray[5] = textFieldText;
        
    }
    
    NSLog(@"leftStr %@ textFieldText  %@  ",leftStr,textFieldText);
}


- (void)checkOrderInfomationPickerViewState{
    if (self.dataBackView.frame.origin.y == (SCREEN_HEIGHT - 250)) {
        [self animationChooseDataView];
    }
    if (self.cardPickerBackView.frame.origin.y == (SCREEN_HEIGHT - 250)) {
        [self animationCardBackView];
    }
}

#pragma mark  scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.dataBackView.frame.origin.y == (SCREEN_HEIGHT - 250)) {
        [self animationChooseDataView];
    } else {
        
    }
}
#pragma mark 实现协议UIPickerViewDataSource方法
//确定Picker的轮子的个数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
    
}


//确定picker的每个轮子的item数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.cardNumberArr.count;
}


#pragma mark 实现协议UIPickerViewDelegate方法

//显示每个轮子的内容

-  (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.cardNumberArr[row];
}
//监听轮子的移动

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.cardNumFinalIndex = row;
    NSLog(@"self.cardNumFinalIndex === %ld",self.cardNumFinalIndex);

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
