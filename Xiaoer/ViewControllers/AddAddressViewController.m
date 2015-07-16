//
//  AddAddressViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/21.
//
//

#import "AddAddressViewController.h"
#import "AddAddressCell.h"
#import "ChooseLocationViewController.h"
#import "XEProgressHUD.h"
#import "NSString+Value.h"
#import "XEEngine.h"
#import "AddressInfoManager.h"
#define saveColor [UIColor colorWithRed:43/255.0 green:186/255.0 blue:230/255.0 alpha:1]
@interface AddAddressViewController ()<UITableViewDataSource,UITableViewDelegate,cellTextFieldEndEditing,ChooseLocationDelegate>
@property (nonatomic,strong)NSMutableArray *leftArray;
@property (nonatomic,strong)NSMutableDictionary *areaDic;
@property (nonatomic,strong)NSArray *province;
//是否删除
@property (nonatomic,strong)NSString *ifDelete;
@property (nonatomic,strong)NSString *localStr;

@property (nonatomic,assign)BOOL ifRightPhone;
@end

@implementation AddAddressViewController
- (NSMutableArray *)leftArray{
    if (!_leftArray) {
        self.leftArray = [NSMutableArray arrayWithObjects:@"收件人姓名",@"所在地区",@"详细地址",@"手机号码",@"固定号码(选填)", nil];
    }
    return _leftArray;
}
- (NSMutableDictionary *)areaDic{
    if (!_areaDic) {
        self.areaDic = [NSMutableDictionary dictionary];
    }
    return _areaDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增地址";
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    self.ifRightPhone = YES;
    self.ifDelete = @"0";
    
    [self configureTabView];
    [self configurePickerView];
    [self configureCommonAddressBtn];
    
    //注册最后一层  县区的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(comeDistric:) name:@"distric" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(comeCity:) name:@"city" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(comeProvince:) name:@"province" object:nil];
    if (!self.info) {
        self.info = [[XEAddressListInfo alloc]init];
    }
    [self setRightButtonWithTitle:@"删除" selector:@selector(deleteAddressInfo)];
}

#pragma mark  删除地址按钮
- (void)deleteAddressInfo{
    NSLog(@"删除地址");
    self.ifDelete = @"1";
    [self saveBtnTouched:self.saveBtn];
}
- (void)comeDistric:(NSNotification *)sender{
    NSLog(@"最后选择的区 == %@",sender.object);
    self.info.districtName = sender.object[@"name"];
    self.info.districtId = sender.object[@"id"];
    self.localStr = [NSString stringWithFormat:@"%@ %@ %@",self.info.districtName,self.info.cityName,self.info.districtName];
    [self.addAddressTab reloadData];
}
- (void)comeCity:(NSNotification *)sender{
    NSLog(@"最后选择的市 == %@",sender.object);
    if ([sender.object[@"name"] isEqualToString:@"市辖区"] || [sender.object[@"name"] isEqualToString:@"县"]) {
        self.info.cityName = @"";
    }else{
        self.info.cityName = sender.object[@"name"];
    }
    self.info.cityId = sender.object[@"id"];
}
- (void)comeProvince:(NSNotification *)sender{
    NSLog(@"最后选择的省会 == %@",sender.object);
    self.info.provinceName = sender.object[@"name"];
    self.info.provinceId = sender.object[@"id"];
}

#pragma mark 布局设为常用地址按钮
- (void)configureCommonAddressBtn{
    self.setCommonAddress.layer.borderColor = [UIColor colorWithRed:43/255.0 green:186/255.0 blue:230/255.0 alpha:1].CGColor;
    self.setCommonAddress.layer.cornerRadius = 10;
    self.setCommonAddress.layer.borderWidth = 1;
    self.setCommonAddress.backgroundColor = [UIColor whiteColor];
    [self.setCommonAddress addTarget:self action:@selector(saveCommonAddress) forControlEvents:UIControlEventTouchUpInside];
}

- (void)saveCommonAddress{
    if ([self.setCommonAddress.backgroundColor isEqual:[UIColor whiteColor]]) {
        self.setCommonAddress.backgroundColor = saveColor;
         }else{
             self.setCommonAddress.backgroundColor = [UIColor whiteColor];
         }
}

#pragma mark 布局tableview
- (void)configureTabView{
    self.addAddressTab.delegate = self;
    self.addAddressTab.dataSource = self;
    [self.addAddressTab registerNib:[UINib nibWithNibName:@"AddAddressCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.addAddressTab.tableFooterView = self.footerView;
    self.addAddressTab.backgroundColor = [UIColor clearColor];
}

#pragma mark 布局pickView
- (void)configurePickerView{
    self.chooseDataView.frame = CGRectMake(0, SCREEN_HEIGHT + 352 , SCREEN_WIDTH, 352);
    [self.view addSubview:self.chooseDataView];
    self.dataPicker.delegate = self;
    self.dataPicker.dataSource = self;
    self.dataPicker.backgroundColor = [UIColor whiteColor];
    self.dataPicker.showsSelectionIndicator = YES;
    [self.dataPicker selectRow: 0 inComponent: 0 animated: YES];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    self.areaDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *components = [self.areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[self.areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    //省会
    self.province = [[NSArray alloc] initWithArray: provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [self.province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[self.areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
    NSString *selectedCity = [city objectAtIndex: 0];
    district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
    
    selectedProvince = [self.province objectAtIndex: 0];

}


#pragma mark cell的textfield 的代理方法
- (void)passLeftLableText:(NSString *)string textFieldtext:(NSString *)str{
    if ([string isEqualToString:@"收件人姓名"]) {
        [self checkNameWith:str];
    } else if([string isEqualToString:@"详细地址"]) {
        [self checkAddressWith:str];
    }else if ([string isEqualToString:@"手机号码"]){
        [self checkPhoneWith:str];
    }else if ([string isEqualToString:@"固定号码(选填)"]){
        if ([str isEqualToString:@""]) {
            self.info.tel = str;
        }else{
            self.info.tel = str;
        }
    }
}
#pragma mark  判断输入合法
- (void)checkAddressWith:(NSString *)str{
    if ([str isEqualToString:@""]) {
        [XEProgressHUD lightAlert:@"请输入地址"];
        return;
    }else{
        self.info.address = str;
    }
}
- (void)checkNameWith:(NSString *)str{
    if ([str isEqualToString:@""]) {
        
        [XEProgressHUD lightAlert:@"请输入姓名"];
        return;
    }else{
        
        self.info.name = str;
    }
    
}
- (void)checkPhoneWith:(NSString *)str{
    NSLog(@"str ============  %@",str);
    if (![str isPhone]) {
        self.ifRightPhone = NO;
        [XEProgressHUD lightAlert:@"请输入正确的手机号"];
        return;
    }else{
        self.ifRightPhone = YES;
        self.info.phone = str;
    }
}
- (void)checkAddAddressViewPickviewState{
    if (self.chooseDataView.frame.origin.y == (SCREEN_HEIGHT - 300)) {
        [self animationChooseDataView];
    }
}

#pragma mark 保存
- (IBAction)saveBtnTouched:(id)sender {
    [self.view endEditing:YES];
    [self scrollViewDidScroll:self.addAddressTab];
    NSLog(@"%@",self.info.phone);
    
    //设置是否是默认地址
    if ([self.setCommonAddress.backgroundColor isEqual: saveColor]) {
        self.info.def = @"1";
        NSLog(@"是默认");
    } else {
        self.info.def = @"0";
        NSLog(@"no 是默认");

    }
    
    //判断是否适合点击保存

    if (!self.info.provinceId) {
        [XEProgressHUD lightAlert:@"请输入正确的省会名称"];

        return;
    }
    if (!self.info.cityId) {
        [XEProgressHUD lightAlert:@"请输入正确的城市名称"];

        return;
    }
    if (!self.info.districtId) {
        [XEProgressHUD lightAlert:@"请输入正确的区名称"];

        return;
    }
    if (!self.info.name) {
        [XEProgressHUD lightAlert:@"请输入姓名"];

        return;
    }
    
    if (self.ifRightPhone == NO) {
      [XEProgressHUD lightAlert:@"请输入正确的手机号"];
        return;
    }
    
    
    if (!self.info.address) {
        [XEProgressHUD lightAlert:@"请输详细地址"];
        return;
    }
    
    
    if (!self.info.tel) {
        self.info.tel = @"";
    }
    
    
    if (!self.info.id) {
        self.info.id = @"";
    }
    
//    XEAddressListInfo *info = [[AddressInfoManager manager]getTheDictionary];
//    //没有任何本子数据，直接设置成默认地址
//    if (!info.phone) {
//        self.info.def = @"1";
//    }


    __weak AddAddressViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance]saveEditorAddressWith:tag userid:[XEEngine shareInstance].uid provinceid:self.info.provinceId cityid:self.info.cityId districtid:self.info.districtId name:self.info.name phone:self.info.phone address:self.info.address tel:self.info.tel def:self.info.def del:self.ifDelete idnum:self.info.id];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        
        //获取失败信息
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return ;
        }
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            return;
            
        }
        if (jsonRet[@"object"]) {
            NSArray *array = jsonRet[@"object"];
            if (array.count == 0) {
                [XEProgressHUD AlertError:@"没有获取到数据" At:weakSelf.view];
                return;
            }
        }

        if ([jsonRet[@"result"] isEqualToString:@"保存成功"]) {
            [XEProgressHUD AlertSuccess:@"保存成功" At:weakSelf.view];
            self.info.id = [jsonRet[@"object"][@"id"]stringValue];
            if (self.ifCanDelete == YES) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"editVerifyInfo" object:nil];
                NSLog(@"发送通知");
            }
            [self performSelector:@selector(performPop) withObject:self afterDelay:1.5];

        } else  if ([jsonRet[@"result"] isEqualToString:@"用户地址已更新"]){
            [XEProgressHUD AlertSuccess:@"保存成功" At:weakSelf.view];
            if ([[AddressInfoManager manager]getTheAddressInfoWith:[XEEngine shareInstance].uid]) {
                self.info.id = [jsonRet[@"object"][@"id"]stringValue];
                XEAddressListInfo *addInfo = [[AddressInfoManager manager]getTheAddressInfoWith:[XEEngine shareInstance].uid];
                if ([addInfo.id  isEqualToString:self.info.id]) {
                    [[AddressInfoManager manager]addDictionaryWith:addInfo With:[XEEngine shareInstance].uid];
                }
                
            }

            if (self.ifCanDelete == YES) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"editVerifyInfo" object:nil];
                NSLog(@"发送通知");
            }
            [self performSelector:@selector(performPop) withObject:self afterDelay:1.5];

        }else if ([jsonRet[@"result"] isEqualToString:@"用户地址已删除"]){
            [XEProgressHUD AlertSuccess:@"用户地址已删除" At:weakSelf.view];
            self.info.id = [jsonRet[@"object"][@"id"]stringValue];

            if (self.ifCanDelete == YES) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"editVerifyInfo" object:nil];
                NSLog(@"发送通知");
            }
            ;
            if ([[AddressInfoManager manager]getTheAddressInfoWith:[XEEngine shareInstance].uid]) {
                XEAddressListInfo *addInfo = [[AddressInfoManager manager]getTheAddressInfoWith:[XEEngine shareInstance].uid];
                if ([addInfo.id  isEqualToString:self.info.id]) {
                    [[AddressInfoManager manager]deleteTheDictionaryWith:[XEEngine shareInstance].uid];
                }
                
            }
            [self performSelector:@selector(performPop) withObject:self afterDelay:1.5];
        }
    } tag:tag];
    
}
#pragma mark  延迟pop到上一级页面
- (void)performPop{
    if (self.delegate && [self.delegate respondsToSelector:@selector(postInfoWith:)]) {
        [self.delegate postInfoWith:self.info];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark 上移动画
- (void)animationChooseDataView{
    if (self.chooseDataView.frame.origin.y == (SCREEN_HEIGHT - 300)) {
            [UIView animateWithDuration:0.8 animations:^{
                self.chooseDataView.frame = CGRectMake(0, SCREEN_HEIGHT + 300, SCREEN_WIDTH, 300);
            }];
    }else{
            [UIView animateWithDuration:0.8 animations:^{
                self.chooseDataView.frame = CGRectMake(0, SCREEN_HEIGHT - 300, SCREEN_WIDTH, 300);
            }];
        }
}

#pragma mark 取消按钮
- (IBAction)cancleChoose:(id)sender {
    [self animationChooseDataView];
}

#pragma mark 完成按钮
- (IBAction)finishChhoose:(id)sender {
    [self animationChooseDataView];
    NSInteger provinceIndex = [self.dataPicker selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [self.dataPicker selectedRowInComponent: CITY_COMPONENT];
    NSInteger districtIndex = [self.dataPicker selectedRowInComponent: DISTRICT_COMPONENT];
    
    NSString *provinceStr = [self.province objectAtIndex: provinceIndex];
    NSString *cityStr = [city objectAtIndex: cityIndex];
    NSString *districtStr = [district objectAtIndex:districtIndex];
    
    if ([provinceStr isEqualToString: cityStr] && [cityStr isEqualToString: districtStr]) {
        cityStr = @"";
        districtStr = @"";
    }
    else if ([cityStr isEqualToString: districtStr]) {
        districtStr = @"";
    }
    
    NSString *showMsg = [NSString stringWithFormat: @"%@ %@ %@.", provinceStr, cityStr, districtStr];
    self.chooseedAddRess = showMsg;
    [self.addAddressTab reloadData];


}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}


#pragma mark 实现协议UIPickerViewDataSource方法
//确定Picker的轮子的个数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}


//确定picker的每个轮子的item数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [self.province count];
    }
    else if (component == CITY_COMPONENT) {
        return [city count];
    }
    else {
        return [district count];
    }
}


#pragma mark tableview 的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.leftArray.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell configureCellWithLeftStr:self.leftArray[indexPath.row] model:self.info indexPath:indexPath];
    cell.delegate = self;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
//        AddAddressCell *cell = [[AddAddressCell alloc]init];
//        
//        [cell.rightTextField resignFirstResponder];
//        NSLog(@"%@",cell.rightTextField);
        [self.view endEditing:YES];
//        [self animationChooseDataView];
        ChooseLocationViewController *chooseLocationVc=[[ChooseLocationViewController alloc] initWithLoactionType:ChooseLoactionTypeProvince WithCode:nil];
        chooseLocationVc.delegate=self;
        [self.navigationController pushViewController:chooseLocationVc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ChooseLocationDelegate
-(void) didSelectLocation:(NSDictionary *)location
{

    NSLog(@"最后返回的数据 === %@",location);
    [self.addAddressTab reloadData];
}
#pragma mark- Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [self.province objectAtIndex: row];
    }
    else if (component == CITY_COMPONENT) {
        NSLog(@"%@",[city objectAtIndex: row]);
        return [city objectAtIndex: row];
    }
    else {
        return [district objectAtIndex: row];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        selectedProvince = [self.province objectAtIndex: row];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [self.areaDic objectForKey: [NSString stringWithFormat:@"%ld", (long)row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        
        city = [[NSArray alloc] initWithArray: array];
        
        NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
        district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [city objectAtIndex: 0]]];
        [self.dataPicker selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        [self.dataPicker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [self.dataPicker reloadComponent: CITY_COMPONENT];
        [self.dataPicker reloadComponent: DISTRICT_COMPONENT];
        
    }
    else if (component == CITY_COMPONENT) {
        NSString *provinceIndex = [NSString stringWithFormat: @"%lu", (unsigned long)[self.province indexOfObject: selectedProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [self.areaDic objectForKey: provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        
        district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
        [self.dataPicker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [self.dataPicker reloadComponent: DISTRICT_COMPONENT];
    }
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return 80;
    }
    else if (component == CITY_COMPONENT) {
        return 100;
    }
    else {
        return 115;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 78, 30)] ;
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [self.province objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [city objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    else {
        myView =[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [district objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
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
