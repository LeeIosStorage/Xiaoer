//
//  VerifyIndentViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/21.
//
//

#import "VerifyIndentViewController.h"
#import "AddAddressViewController.h"
#import "PayAndDistributionViewController.h"
#import "GoToPayViewController.h"
//#import "VerifyIndentCell.h"
#import "ShopCarCell.h"
#import "AddressManagerController.h"
@interface VerifyIndentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,changeNumShopDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

//保存每个商品有多少个的数组
@property (nonatomic,strong)NSMutableArray *NumberArray;

//之前的价钱的数组
@property (nonatomic,strong)NSMutableArray *formerPricArray;

//之后的价钱的数组
@property (nonatomic,strong)NSMutableArray *afterPricArray;

@property (nonatomic,strong)NSMutableArray *pickerArray;

//pickerview显示的string
@property (nonatomic,strong)NSString *pickerStr;

//保存pickerview最后显示的哪一行
@property (nonatomic,assign)NSInteger pickerFinalIndex;


@property (nonatomic,assign)BOOL haveAddress;

@end

@implementation VerifyIndentViewController


- (NSMutableArray *)NumberArray{
    if (!_NumberArray) {
        self.NumberArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    }
    return _NumberArray;
}

-(NSMutableArray *)formerPricArray{
    if (!_formerPricArray) {
        self.formerPricArray = [NSMutableArray arrayWithObjects:@"20",@"30",@"40",@"50.8",@"60", nil];
    }
    return _formerPricArray;
}

- (NSMutableArray *)afterPricArray{
    if (!_afterPricArray) {
        self.afterPricArray = [NSMutableArray arrayWithObjects:@"10",@"20",@"30",@"40",@"50", nil];
    }
    return _afterPricArray;
}

- (NSMutableArray *)pickerArray{
    if (!_pickerArray) {
        self.pickerArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    }
    return _pickerArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"确认订单";
    self.noteTextField.delegate = self;
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    self.firstSetAddressView.frame = CGRectMake(0, SCREEN_HEIGHT - 80, SCREEN_WIDTH, 80);
//    [self.view addSubview:self.firstSetAddressView];
    
    
    [self configureTabview];
    [self configureVerifyView];
    [self configureCouponView];
    [self creatTabViewHeaderView];
    [self creatTabFooterView];
    [self configurePickerBackView];
    /**
     *  键盘将要出现的监听
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    /**
     *  键盘将要消失的监听
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardEndChangeFrame:) name:UIKeyboardWillHideNotification object:nil];
    [self changeAllPrice];
    
    self.haveAddress = NO;

}
#pragma mark 布局tableview属性

- (void)configureTabview{
    
    
    [self.tabView registerNib:[UINib nibWithNibName:@"ShopCarCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    self.tabView.backgroundColor = [UIColor clearColor];
    
}

#pragma mark 布局底部的确认购买界面

- (void)configureVerifyView{
    self.bottomPayView.frame = CGRectMake(0, SCREEN_HEIGHT - 60, SCREEN_WIDTH, 60);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREEN_WIDTH - 80, 10, 60, 40);
    button.backgroundColor = SKIN_COLOR;
    [button setTintColor:[UIColor whiteColor]];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.layer.cornerRadius = 10;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(veryBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomPayView addSubview:button];
    
    [self.view addSubview:self.bottomPayView];
}

#pragma mark 布局优惠券一栏
- (void)configureCouponView{
    self.chooseCouponBtn.layer.cornerRadius = 10;
    self.useCouponBtn.layer.cornerRadius = 5;
}

#pragma mark 布局选择优惠券界面
- (void)configurePickerBackView{
    
    self.pickeBackView.frame = CGRectMake(0, SCREEN_HEIGHT + 200, SCREEN_WIDTH, 200);
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.view addSubview:self.pickeBackView];
}

#pragma mark cell 代理
- (void)returnIndexOfShop:(NSInteger)index andNumberText:(NSString *)numText{
    //替换对应下标的商品数目数组
    self.NumberArray[index] = numText;
    
    [self changeAllPrice];

    
}

- (void)changeAllPrice{
    self.totalPrice.text = [self calculateTotalPrice];
    self.favorableLab.text = [self calculateFavorablePrice];
    self.needPayLab.text = [self calculateNeedToPayPrice];
    self.bottomNeedPay.text = [self calculateNeedToPayPrice];
    [self.tabView reloadData];
}
#pragma 计算商品优惠前总金额
- (NSString *)calculateTotalPrice{
    CGFloat totalPri = 0;
    for (int i = 0; i < self.NumberArray.count; i++) {
        CGFloat floa =  [[self.NumberArray objectAtIndex:i] floatValue] * [[self.formerPricArray objectAtIndex:i] floatValue];
        totalPri += floa;
    }
    
    return [NSString stringWithFormat:@"%.2f",totalPri];
}

#pragma 计算优惠的金额
- (NSString *)calculateFavorablePrice{
    
    CGFloat Favora = 0;
    
    for (int i = 0; i < self.NumberArray.count; i++) {
        
        CGFloat diff = [[self.NumberArray objectAtIndex:i] floatValue] * ([[self.formerPricArray objectAtIndex:i] floatValue] - [[self.afterPricArray objectAtIndex:i]floatValue]);
        Favora += diff;
    }
    
    return [NSString stringWithFormat:@"%.2f",Favora];;
}

- (NSString *)calculateNeedToPayPrice{
    CGFloat total = [[self calculateTotalPrice] floatValue];
    CGFloat Favorable = [[self calculateFavorablePrice] floatValue];
    
    return [NSString stringWithFormat:@"%.2f",total - Favorable];
}
#pragma mark 确定按钮点击

- (void)veryBtnTouched{
    
    [self manualDisappearKtyBoard];
    NSLog(@"确定按钮点击");
    GoToPayViewController *toPay = [[GoToPayViewController alloc]init];
    [self.navigationController pushViewController:toPay animated:YES];
}

#pragma mark 收获地址按钮点击A
- (IBAction)addAddressBtn:(id)sender {

    NSLog(@"收获地址按钮点击A");
//    AddressManagerController *manager = [[AddressManagerController alloc]init];
//    [self.navigationController pushViewController:manager animated:YES];
    AddAddressViewController *addAddress = [[AddAddressViewController alloc]init];
    [self.navigationController pushViewController:addAddress animated:YES];
}

#pragma mark 收获地址按钮点击B
- (IBAction)addAddressBtnB:(id)sender {
    
    AddAddressViewController *addAddress = [[AddAddressViewController alloc]init];
    [self.navigationController pushViewController:addAddress animated:YES];
    NSLog(@"收获地址按钮点击B");
}

#pragma mark 支付和配送方式A
- (IBAction)payAndGiveBtn:(id)sender {
    NSLog(@"支付和配送方式A");

    PayAndDistributionViewController *pay = [[PayAndDistributionViewController alloc]init];
    [self.navigationController pushViewController:pay animated:YES];
}

#pragma mark 支付和配送方式B
- (IBAction)payAndGiveBtnB:(id)sender {
    NSLog(@"支付和配送方式B");

    PayAndDistributionViewController *pay = [[PayAndDistributionViewController alloc]init];
    [self.navigationController pushViewController:pay animated:YES];

}


#pragma mark 发票按钮
- (IBAction)debitBtn:(id)sender {
    NSLog(@"发票");
}


#pragma mark 使用优惠券按钮
- (IBAction)useCouponBtnTouched:(id)sender {
    NSLog(@"使用优惠券按钮点击");
}


#pragma mark 选择优惠券按钮
- (IBAction)chooseCouponBtnTouched:(id)sender {
    
    NSLog(@"选择优惠券按钮点击");
    
    if (!self.pickerStr) {
        [self  pickerView:self.pickerView didSelectRow:0 inComponent:0];
    }else{
        
        [self  pickerView:self.pickerView didSelectRow:self.pickerFinalIndex inComponent:0];
    }
    [self animATionPickerBackView];
}



#pragma mark pickerView 下面的按钮点击了
- (IBAction)pickVerifyBtnTouched:(id)sender {
    self.chooseCouponBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.chooseCouponBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.chooseCouponBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.chooseCouponBtn setTitle:self.pickerStr forState:UIControlStateNormal];
    [self animATionPickerBackView];
}

#pragma mark 底部添加地址按钮
- (IBAction)bottonAddRessBtnTouched:(id)sender {
    
    NSLog(@"底部添加地址按钮");
    AddAddressViewController *addAddress = [[AddAddressViewController alloc]init];
    [self.navigationController pushViewController:addAddress animated:YES];
}

#pragma mark tableview 的代理方法

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.NumberArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.row == 0) {
    //        return 155;
    //    }else if (indexPath.row == 1 ){
    //        return 150;
    //    }else if (indexPath.row == 2){
    //        return 50;
    //    }else if (indexPath.row == 3){
    //        return 115;
    //    }
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     VerifyIndentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
     if (indexPath.row == 0) {
     
     self.addAddressView.frame = CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, 140);
     
     [cell configureCellWith:self.addAddressView andIndesPath:indexPath];
     
     }else if (indexPath.row == 1 ){
     
     self.payAndGiveView.frame = CGRectMake(0, 15, [UIScreen mainScreen].bounds.size.width, 135);
     
     [cell configureCellWith:self.payAndGiveView andIndesPath:indexPath];
     
     }else if (indexPath.row == 2){
     
     self.debitView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
     
     [cell configureCellWith:self.debitView andIndesPath:indexPath];
     
     }else if (indexPath.row == 3){
     
     self.noteView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
     [cell configureCellWith:self.noteView andIndesPath:indexPath];
     
     }else{
     
     cell.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
     [cell configureCellWith:nil andIndesPath:indexPath];
     
     }
     */
    //    cell.backgroundColor = [UIColor clearColor];
    ShopCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    cell.delegate = self;
    cell.numShopLab.text = [self.NumberArray objectAtIndex:indexPath.row];
    NSString *formText = [NSString stringWithFormat:@"¥%.2f",[[self.formerPricArray objectAtIndex:indexPath.row] floatValue] * [cell.numShopLab.text floatValue]];
    cell.formerPrice.text = formText;
    NSString *afterText = [NSString stringWithFormat:@"¥%.2f",[[self.afterPricArray objectAtIndex:indexPath.row] floatValue]*[cell.numShopLab.text floatValue]];
    cell.afterPrice.text = afterText;
    [cell configureCellWith:indexPath];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    if (indexPath.row == 0) {
    //        AddressManagerController *manager = [[AddressManagerController alloc]init];
    //        [self.navigationController pushViewController:manager animated:YES];
    //    }else if (indexPath.row == 1){
    //        PayAndDistributionViewController *pay = [[PayAndDistributionViewController alloc]init];
    //       [self.navigationController pushViewController:pay animated:YES];
    //    }
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark pickerView delegate 
//确定Picker的轮子的个数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

//确定picker的每个轮子的item数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerArray.count;
}

//显示每个轮子的内容
-  (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerArray[row];
}

//监听轮子的移动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.pickerFinalIndex = row;
    NSLog(@"%@",self.pickerArray[row]);
    self.pickerStr = self.pickerArray[row];
//    if (component == 0) {
//        NSString *seletedProvince = self.provinceArray[row];
//        self.cityArray = self.dict[seletedProvince];
//        //更新第二个轮子的数据
//        [pickerView reloadComponent:1];
//        NSInteger selectedCityIndex = [pickerView selectedRowInComponent:1];
//        NSString *seletedCity =self.cityArray[selectedCityIndex];
//        NSString *msg = [NSString stringWithFormat:@"province=%@,city=%@", seletedProvince,seletedCity];
//        NSLog(@"%@",msg);
//    }
//    else {
//        NSInteger selectedProvinceIndex = [pickerView selectedRowInComponent:0];
//        NSString *seletedProvince = self.provinceArray[selectedProvinceIndex];
//        NSString *seletedCity = self.cityArray[row];
//        NSString *msg = [NSString stringWithFormat:@"province=%@,city=%@", seletedProvince,seletedCity];
//        NSLog(@"%@",msg);
//    }
}
#pragma mark pickerView 的动画
- (void)animATionPickerBackView{
    if (self.pickeBackView.frame.origin.y == SCREEN_HEIGHT - 200) {
        [UIView animateWithDuration:0.5 animations:^{
            self.pickeBackView.frame = CGRectMake(0, SCREEN_HEIGHT + 200, SCREEN_WIDTH, 200);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.pickeBackView.frame = CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200);
        }];
    }
    [self.pickerView reloadComponent:0];

}
#pragma mark 键盘将要消失的监听
- (void)keyBoardEndChangeFrame:(NSNotification *)note{
    
    //取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

#pragma mark 手动取消键盘
- (void)manualDisappearKtyBoard{
    //如果备注框时第一响应者，就释放第一响应，同时键盘就会自动消失，执行消失键盘的通知动画
    if (self.noteTextField.isFirstResponder) {
        [self.noteTextField resignFirstResponder];
        
    }
    
    
}

#pragma mark 键盘将要出现的监听
- (void)keyBoardWillChangeFrame:(NSNotification *)note{
    //取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //取出键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    //计算控制器的view需要偏移评议的距离
    
    
    CGFloat transForm =  keyboardFrame.size.height;
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, -transForm , SCREEN_WIDTH, SCREEN_HEIGHT);
        
    }];
    
}



#pragma mark 回收键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark 创建TableView 的foterView

- (void)creatTabFooterView{
    
    for (UIView *obj in self.tabView.tableFooterView.subviews) {
        [obj removeFromSuperview];
    }
    UIView *tabFooterView = [[UIView alloc]init];
    tabFooterView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    UIView *copyCoupon = [self returnResultCoupon];
    
    
    UIView *copyPayAndGive = [self returnResultPayAndGiveView];
    copyPayAndGive.frame = CGRectMake(0, copyCoupon.frame.size.height, SCREEN_WIDTH, copyPayAndGive.frame.size.height);
    
    UIView *copyDebitView = [self returnResultDebitView];
    copyDebitView.frame = CGRectMake(0, copyPayAndGive.frame.size.height + copyCoupon.frame.size.height, SCREEN_WIDTH, copyDebitView.frame.size.height);
    
    UIView *copyNoteView = [self returnResultNoteView];
    copyNoteView.frame = CGRectMake(0, copyPayAndGive.frame.size.height + copyDebitView.frame.size.height + copyCoupon.frame.size.height, SCREEN_WIDTH, copyNoteView.frame.size.height);
    
    self.footer.frame = CGRectMake(0, copyDebitView.frame.size.height + copyNoteView.frame.size.height + copyPayAndGive.frame.size.height + copyCoupon.frame.size.height, SCREEN_WIDTH, self.footer.frame.size.height);
    
    tabFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, copyDebitView.frame.size.height + copyNoteView.frame.size.height + copyPayAndGive.frame.size.height + self.footer.frame.size.height + copyCoupon.frame.size.height);
    
    [tabFooterView addSubview:copyCoupon];
    [tabFooterView addSubview:copyPayAndGive];
    [tabFooterView addSubview:copyDebitView];
    [tabFooterView addSubview:copyNoteView];
    [tabFooterView addSubview:self.footer];
    self.tabView.tableFooterView = tabFooterView;
    
}


#pragma mark 创建TableView 的headerview

- (void)creatTabViewHeaderView{
    for (UIView *obj in self.tabView.tableHeaderView.subviews) {
        [obj removeFromSuperview];
    }
    
    
    UIView *tabHeaderView = [[UIView alloc]init];
    tabHeaderView.backgroundColor = [UIColor whiteColor];
    tabHeaderView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    UIView *copyAddressView = [self returnResultAddAddressView];
    
    tabHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, copyAddressView.frame.size.height);
    [tabHeaderView addSubview:copyAddressView];
    self.tabView.tableHeaderView = tabHeaderView;
    
}

#pragma mark 返回收获地址视图
- (UIView *)returnResultAddAddressView{
    
    if (self.haveAddress == NO) {
        self.addAddressViewB.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
        return self.addAddressViewB;
    }else{
        self.addAddressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
        return self.addAddressView;
    }
    
}

#pragma mark 返回支付和配送方式
- (UIView *)returnResultPayAndGiveView{
    
    self.payAndGiveView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 135);
    return self.payAndGiveView;
}

#pragma mark 返回发票
- (UIView *)returnResultDebitView{
    
    self.debitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    return self.debitView;
    
}

#pragma mark 返回备注留言
- (UIView *)returnResultNoteView{
    
    self.noteView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    return self.noteView;
}

#pragma mark 返回优惠券
- (UIView *)returnResultCoupon{
    self.coupon.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    return self.coupon;
}

#pragma mark 如果在选择优惠券的pickview 没有选择的时候，滑动了tableview 就让他隐藏
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.pickeBackView.frame.origin.y == SCREEN_HEIGHT - 200) {
        [UIView animateWithDuration:0.5 animations:^{
            self.pickeBackView.frame = CGRectMake(0, SCREEN_HEIGHT + 200, SCREEN_WIDTH, 200);
        }];
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
