//
//  AddressManagerController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/23.
//
//

#import "AddressManagerController.h"
#import "AddressManagerCell.h"
@interface AddressManagerController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AddressManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址管理";
    [self.tabView registerNib:[UINib nibWithNibName:@"AddressManagerCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    self.tabView.backgroundColor = [UIColor clearColor];
    [self setRightButtonWithImageName:@"AddAddress" selector:@selector(addAddressBtn)];

    // Do any additional setup after loading the view from its nib.
}
- (void)addAddressBtn{
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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
