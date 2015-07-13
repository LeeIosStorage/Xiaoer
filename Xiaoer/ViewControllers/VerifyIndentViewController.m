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
#import "ShopCarCell.h"
#import "AddressManagerController.h"
#import "AddressInfoManager.h"
#import "XEAddressListInfo.h"
#import "XEShopCarInfo.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "MJExtension.h"
#import "XECouponsInfo.h"
#import "VerifyIndentCell.h"

@interface VerifyIndentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,NumShopDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)NSMutableArray *pickerArray;

//pickerview显示的string
@property (nonatomic,strong)NSString *pickerStr;

//保存pickerview最后显示的哪一行
@property (nonatomic,assign)NSInteger pickerFinalIndex;


@property (nonatomic,assign)BOOL haveAddress;

@property (nonatomic,strong)XEAddressListInfo *info;

/**
 *  保存解析到的优惠券数组
 */
@property (nonatomic,strong)NSMutableArray *couponsArray;

@property (nonatomic,strong)UIButton *senderBtn;

/**
 *  选择的优惠券数组
 */
@property  (nonatomic,strong)NSMutableArray *selectPickerAtr;


/**
 *  保存再次展示的pickerview 在selecrarr中那一个与之前的相同
 */
@property (nonatomic,assign)NSInteger sameIndex;

/**
 *  保存优惠券是否已经使用 0 代表未使用 1 代表已经使用
 */
@property (nonatomic,strong)NSMutableArray *usedArray;



@end

@implementation VerifyIndentViewController
- (NSMutableArray *)usedArray{
    if (!_usedArray) {
        self.usedArray = [NSMutableArray array];
    }
    return _usedArray;
}
- (NSMutableArray *)selectPickerAtr{
    if (!_selectPickerAtr) {
        self.selectPickerAtr = [NSMutableArray array];
    }
    return _selectPickerAtr;
}
- (NSMutableArray *)couponsArray{
    if (!_couponsArray) {
        self.couponsArray = [NSMutableArray array];
    }
    return _couponsArray;
}

- (NSMutableArray *)pickerArray{
    if (!_pickerArray) {
        self.pickerArray = [NSMutableArray array];
    }
    return _pickerArray;
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    //判断是否先设置地址
    self.firstSetAddressView.frame = CGRectMake(0, SCREEN_HEIGHT - 80, SCREEN_WIDTH, 80);
    [self.view addSubview:self.firstSetAddressView];
    
    self.info = [[AddressInfoManager manager]getTheDictionary];
    
    if (!self.info.phone) {
        
        self.firstSetAddressView.hidden = NO;
    }
    else{
        
        self.firstSetAddressView.hidden = YES;
    }
    
    [self creatTabViewHeaderView];



}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"确认订单";
    self.noteTextField.layer.borderColor = [UIColor blackColor].CGColor;
    self.noteTextField.layer.borderWidth = 1;
    self.noteTextField.delegate = self;
    self.noteTextField.layer.cornerRadius =10;
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    self.firstSetAddressView.frame = CGRectMake(0, SCREEN_HEIGHT - 80, SCREEN_WIDTH, 80);
    
    
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

    
    if (self.shopArray.count > 0) {
        //请求优惠券数据
        [self getCouponListData];
    }
    


}

#pragma mark  请求优惠券数据
- (void)getCouponListData{
    
    NSMutableString *goodsIdStr = [NSMutableString string];
    for (int i = 0; i < self.shopArray.count; i++) {
        XEShopCarInfo *info = (XEShopCarInfo *)self.shopArray[i];
        
        if (i == self.shopArray.count-1) {
            
            [goodsIdStr appendString:[NSString stringWithFormat:@"%@",info.goodsId]];
            
        }else{
            
            [goodsIdStr appendString:[NSString stringWithFormat:@"%@,",info.goodsId]];
        }
        
    }
    __weak VerifyIndentViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    
    [[XEEngine shareInstance]getCouponListInfomationWith:tag userid:[XEEngine shareInstance].uid pagenum:@"" goodsids:goodsIdStr];
    
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
        

        if ([jsonRet[@"object"][@"coupons"] isKindOfClass:[NSNull class]]) {
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            return;
        }
        
        NSArray *couponsArr = jsonRet[@"object"][@"coupons"];
        for (NSDictionary *dic  in couponsArr) {
            XECouponsInfo *info = [XECouponsInfo objectWithKeyValues:dic];
            [self.couponsArray addObject:info];
        }
        
        for (int i = 0; i < self.shopArray.count; i++) {
            [self.selectPickerAtr addObject:@""];
        }
        for (int i = 0 ; i < self.shopArray.count; i++) {
            [self.usedArray addObject:@"0"];
        }
        
        //请求完数据 要重新刷新一下 否则显示不正确
        [self.tabView reloadData];
    } tag:tag];
    
}

#pragma mark 布局tableview属性

- (void)configureTabview{
    
    
    [self.tabView registerNib:[UINib nibWithNibName:@"VerifyIndentCell" bundle:nil] forCellReuseIdentifier:@"cell"];
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
    XEShopCarInfo *info = self.shopArray[index];
    info.num = numText;
    [self changeAllPrice];

}
- (void)showPickerViewWithBtn:(UIButton *)button{
    if (!self.senderBtn) {
        self.senderBtn = button;
    }else{
        self.senderBtn = button;
    }
    XEShopCarInfo *info = self.shopArray[button.tag];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0 ; i < self.couponsArray.count; i++) {
        XECouponsInfo *CouponInfo = self.couponsArray[i];
        if ([CouponInfo.objId isEqualToString:info.serieId]) {
            [array addObject:CouponInfo.cardNo];
        }
        if ([CouponInfo.objId isEqualToString:info.goodsId]) {
            [array addObject:CouponInfo.cardNo];
        }
    }
    if ([button.titleLabel.text isEqualToString:@"请选择促销活动优惠券"]) {
        
    }else{
        
    }
    self.pickerArray = array;
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:0 inComponent:0 animated:0];
    [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
    [self animATionPickerBackView];
    
}

- (void)useCouponWith:(UIButton *)button chooseBtnText:(NSString *)choosetBtnText{
    NSLog(@"%ld %@",button.tag ,choosetBtnText);
    if (self.usedArray.count > 0) {
        self.usedArray[button.tag] = @"1";
        NSLog(@"%ld",self.usedArray.count);
        [self changeAllPrice];
    }



}
- (void)changeAllPrice{
    
    self.totalPrice.text = [self calculateTotalPrice];
    self.favorableLab.text = [self calculateFavorablePrice];
    self.freightLab.text = [self calculateCarriage];
    self.bottomNeedPay.text = [NSString stringWithFormat:@"%.2f",[[self calculateTotalPrice] floatValue] + [self.freightLab.text floatValue]];
    [self.tabView reloadData];
    
}
#pragma mark 计算运费
- (NSString *)calculateCarriage{
    CGFloat totalCarriage = 0;
    for (int i = 0 ; i < self.shopArray.count; i++) {
        XEShopCarInfo *info = self.shopArray[i];
        CGFloat floa =  [info.num floatValue] * [info.carriage floatValue];

        totalCarriage += floa ;
    }
    return [NSString stringWithFormat:@"%.2f",totalCarriage/100];

}
#pragma 计算商品优惠前总金额
- (NSString *)calculateTotalPrice{
    CGFloat totalPri = 0;
    for (int i = 0; i < self.shopArray.count; i++) {
        XEShopCarInfo *info = self.shopArray[i];
        CGFloat floa =  [info.num floatValue] * [info.price floatValue];
        totalPri += floa;
    }
    

    
    return [NSString stringWithFormat:@"%.2f",totalPri/100];
}

#pragma 计算优惠的金额
- (NSString *)calculateFavorablePrice{
    
    CGFloat Favora = 0;
    
    for (int i = 0; i < self.shopArray.count; i++) {
        XEShopCarInfo *info = self.shopArray[i];
        CGFloat diff = [info.num floatValue] * ([info.origPrice floatValue] - [info.price floatValue]);
        Favora += diff;
    }
    for (int i = 0;i< self.usedArray.count; i++) {
        if ([self.usedArray[i] isEqualToString:@"0"]) {
            //未使用
        }else{
            //使用了
            for (int j = 0; j< self.couponsArray.count; j++) {
                XECouponsInfo *couponInfo = self.couponsArray[j];
                if ([self.selectPickerAtr[i] isEqualToString:couponInfo.cardNo]) {
                    NSLog(@"找到卡券号相等的了");
                    Favora -= [couponInfo.price floatValue];
                }
            }
        }
    }
    

    return [NSString stringWithFormat:@"%.2f",Favora/100];;
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

#pragma mark 收获地址按钮点击A (有默认地址情况)
- (IBAction)addAddressBtn:(id)sender {

    NSLog(@"收获地址按钮点击A");
    AddressManagerController *manager = [[AddressManagerController alloc]init];
    manager.ifCanDelete = YES;
    [self.navigationController pushViewController:manager animated:YES];
    
}

#pragma mark 收获地址按钮点击B( 没有 默认收获地址)
- (IBAction)addAddressBtnB:(id)sender {
    NSLog(@"收获地址按钮点击B");
    AddAddressViewController *addAddress = [[AddAddressViewController alloc]init];
    addAddress.info = [[AddressInfoManager manager] getTheDictionary];
    [self.navigationController pushViewController:addAddress animated:YES];
}


#pragma mark pickerView 下面的按钮点击了
- (IBAction)pickVerifyBtnTouched:(id)sender {
    NSLog(@"确定");
    
    self.selectPickerAtr[self.senderBtn.tag] = self.pickerStr;
    NSLog(@"self.selectPickerAtr[button.tag] == %@  & %ld",self.selectPickerAtr[self.senderBtn.tag],self.senderBtn.tag);
    [self.tabView reloadData];
    [self animATionPickerBackView];
}

#pragma mark 底部添加地址按钮
- (IBAction)bottonAddRessBtnTouched:(id)sender {
    
    NSLog(@"底部添加地址按钮");
    AddAddressViewController *addAddress = [[AddAddressViewController alloc]init];
    [self.navigationController pushViewController:addAddress animated:YES];
}
- (BOOL)ifHaveSectionFooterWith:(NSInteger )section{

    for (int i = 0; i < self.couponsArray.count; i++) {
        XEShopCarInfo *CarInfo = (XEShopCarInfo *)self.shopArray[section];
        XECouponsInfo * couponInfo = self.couponsArray[i];
        
        if (i == self.couponsArray.count - 1) {
            if ([CarInfo.goodsId isEqualToString:couponInfo.objId] || [couponInfo.objId isEqualToString:CarInfo.serieId]) {
                return YES;
            }else{
                return NO;
            }
        }
        
        if ([CarInfo.goodsId isEqualToString:couponInfo.objId] || [couponInfo.objId isEqualToString:CarInfo.serieId]) {
            return YES;
        }

}
    
    return NO;
    
}

#pragma mark tableview 的代理方法
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    
//
//    
//    
//    UIView *view = [[UIView alloc]init];
//    view.frame  =CGRectMake(0, 0, SCREEN_WIDTH, 50);
//    view.backgroundColor = [UIColor whiteColor];
//    view.userInteractionEnabled = YES;
//    
//    UIButton *couponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    couponBtn.tag = section;
//    couponBtn.frame = CGRectMake(15, 10, SCREEN_WIDTH - 15 - 60 - 35, 30);
//    [couponBtn setTitle:@"请选择促销活动优惠券" forState:UIControlStateNormal];
//    [couponBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [couponBtn setBackgroundColor:[UIColor redColor]];
//    [couponBtn addTarget:self action:@selector(couponChooseBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
//    couponBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    couponBtn.layer.cornerRadius = 8;
//    couponBtn.layer.masksToBounds = YES;
//    couponBtn.userInteractionEnabled = YES;
//    
//    UIButton *verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    verifyBtn.frame = CGRectMake(SCREEN_WIDTH -60 - 20, 10, 60 , 30);
//    [verifyBtn setTitle:@"使用" forState:UIControlStateNormal];
//    [verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [verifyBtn setBackgroundColor:[UIColor colorWithRed:180/255.0 green:211/255.0 blue:107/255.0 alpha:1]];
//    [verifyBtn addTarget:self action:@selector(couponVerifyBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
//    verifyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    verifyBtn.layer.cornerRadius = 5;
//    verifyBtn.layer.masksToBounds = YES;
//    verifyBtn.userInteractionEnabled = YES;
//    
//    [view addSubview:verifyBtn];
//    [view addSubview:couponBtn];
//    if ([self ifHaveSectionFooterWith:section] == YES) {
//        return view;
//    }
//    return nil;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if ([self ifHaveSectionFooterWith:section] == YES) {
//        return 50;
//    }else{
//        return 0;
//    }
//    return 0;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.shopArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self ifHaveSectionFooterWith:indexPath.section] == YES) {
        return 160;
    }else{
        return 120;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    VerifyIndentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    cell.delegate = self;
    cell.tag = indexPath.section;
    if (self.selectPickerAtr.count > 0) {
    
        if ([self.selectPickerAtr[indexPath.section] isEqualToString:@""]) {
            cell.chooseCouponBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            cell.chooseCouponBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
            cell.chooseCouponBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            [cell.chooseCouponBtn setTitle:@"请选择促销活动优惠券" forState:UIControlStateNormal];
        }else{

            cell.chooseCouponBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            cell.chooseCouponBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
            cell.chooseCouponBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            [cell.chooseCouponBtn setTitle:self.selectPickerAtr[indexPath.section] forState:UIControlStateNormal];
        }
    }else{
        cell.chooseCouponBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        cell.chooseCouponBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        cell.chooseCouponBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [cell.chooseCouponBtn setTitle:@"请选择促销活动优惠券" forState:UIControlStateNormal];
    }
    


    


    [cell configureCellWith:indexPath andStateStr:@"" info:self.shopArray[indexPath.section] ifHavePicker:[self ifHaveSectionFooterWith:indexPath.section]];

//    cell.selectionStyle = 0;
//    ShopCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    cell.tag = indexPath.section;
//    [cell configureCellWith:indexPath andStateStr:@"0" info:self.shopArray[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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

    
    if (self.selectPickerAtr.count > 0) {
        for (int i = 0 ; i < self.selectPickerAtr.count; i++) {
            if ([self.pickerArray[row] isEqualToString:self.selectPickerAtr[i]] && ![self.senderBtn.titleLabel.text isEqualToString:self.pickerArray[row]]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"该优惠券刚已经被您使用于其他商品了，确定改用在这个商品么？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                self.sameIndex = i;
                [alert show];
                return;
            }else{

            }
        }
    }
    
    self.pickerStr = self.pickerArray[row];


}

#pragma mark alertView delagate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {


        
    }else if (buttonIndex == 1){
    for (int  j = 0; j < self.selectPickerAtr.count; j++) {
        for (int i = 0 ; i < self.pickerArray.count; i++) {

                if ([self.pickerArray[i] isEqualToString:self.selectPickerAtr[j]]) {
                    self.usedArray[self.senderBtn.tag] = @"0";
                    self.usedArray[j] = @"0";
                    self.selectPickerAtr[j] = @"";
                    self.selectPickerAtr[self.senderBtn.tag] = self.pickerArray[i];
                    [self changeAllPrice];
                    [self.tabView reloadData];
                }
            }
        }
    }
    [self animATionPickerBackView];
    
    NSLog(@"buttonIndex === %ld",buttonIndex);
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

#pragma mark 手动取消键盘
- (void)manualDisappearKtyBoard{
    //如果备注框时第一响应者，就释放第一响应，同时键盘就会自动消失，执行消失键盘的通知动画
    if (self.noteTextField.isFirstResponder) {
        [self.noteTextField resignFirstResponder];
    }
}

#pragma mark 键盘将要消失的监听
- (void)keyBoardEndChangeFrame:(NSNotification *)note{
    
    //取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
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
    
#warning tableview 的footer 的末尾不要只选一个优惠券，暂时隐藏 暂时让高度为0
    UIView *copyCoupon = [self returnResultCoupon];
    copyCoupon.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    
#warning 此版本支付和配送方式不要 暂时让高度为0
    UIView *copyPayAndGive = [self returnResultPayAndGiveView];
    copyPayAndGive.frame = CGRectMake(0, copyCoupon.frame.size.height, SCREEN_WIDTH, 0);
    
#warning 此版本发票功能暂时舍弃 暂时让高度为0

    UIView *copyDebitView = [self returnResultDebitView];
    copyDebitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
//    copyDebitView.frame = CGRectMake(0, copyPayAndGive.frame.size.height + copyCoupon.frame.size.height, SCREEN_WIDTH, copyDebitView.frame.size.height);
    
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
    
    //无参数
    if (self.firstSetAddressView.hidden == NO) {
        self.addAddressViewB.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
        return self.addAddressViewB;
    }else{
        //有参数
        self.addAddressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
        self.InfoName.text = self.info.name;
        self.infoPhone.text = self.info.phone;
        self.infoAddress.text = [NSString stringWithFormat:@"%@ %@ %@ %@",self.info.provinceName,self.info.cityName,self.info.districtName,self.info.address];
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
    
    self.noteView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140);
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
    
//    if (scrollView == self.tabView)
//    {
//        CGFloat sectionHeaderHeight = 50;
//        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        }
//    }
    
}

#pragma mark 发票按钮
- (IBAction)debitBtn:(id)sender {
    NSLog(@"发票");
}



//#pragma mark 使用优惠券按钮
//- (IBAction)useCouponBtnTouched:(id)sender {
//    NSLog(@"使用优惠券按钮点击");
//}
//
//
//#pragma mark 选择优惠券按钮
//- (IBAction)chooseCouponBtnTouched:(id)sender {
//    
//    NSLog(@"选择优惠券按钮点击");
//    
//    if (!self.pickerStr) {
//        [self  pickerView:self.pickerView didSelectRow:0 inComponent:0];
//    }else{
//        
//        [self  pickerView:self.pickerView didSelectRow:self.pickerFinalIndex inComponent:0];
//    }
//    [self animATionPickerBackView];
//}

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
