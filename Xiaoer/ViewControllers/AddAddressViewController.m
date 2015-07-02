//
//  AddAddressViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/21.
//
//

#import "AddAddressViewController.h"
#import "AddAddressCell.h"
#define saveColor [UIColor colorWithRed:43/255.0 green:186/255.0 blue:230/255.0 alpha:1]
@interface AddAddressViewController ()<UITableViewDataSource,UITableViewDelegate,cellTextFieldEndEditing>
@property (nonatomic,strong)NSMutableArray *leftArray;
@property (nonatomic,strong)NSMutableDictionary *areaDic;
@property (nonatomic,strong)NSArray *province;
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
    
    [self configureTabView];
    [self configurePickerView];
    [self configureCommonAddressBtn];
    
    

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
    NSLog(@"%@ %@",string,str);
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
    return self.leftArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell configureCellWith:indexPath AndString:[self.leftArray objectAtIndex:indexPath.row]];
    cell.delegate = self;
    if (indexPath.row == 1) {
        cell.rightTextField.text = self.chooseedAddRess;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        AddAddressCell *cell = [[AddAddressCell alloc]init];
        
        [cell.rightTextField resignFirstResponder];
        NSLog(@"%@",cell.rightTextField);
        [self animationChooseDataView];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
