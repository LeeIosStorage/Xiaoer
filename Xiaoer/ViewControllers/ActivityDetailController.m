//
//  ActivityDetailController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/25.
//
//

#import "ActivityDetailController.h"
#import "ActivityDetailCell.h"
@interface ActivityDetailController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ActivityDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.shopBackLab.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];    
    //布局导航条
    [self confugureNaviTitle];
    //布局tableview
    [self configureTableView];
    

    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark 布局tableview

- (void)configureTableView{
    
    self.tabView.backgroundColor = [UIColor clearColor];
    [self.tabView registerNib:[UINib nibWithNibName:@"ActivityDetailCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tabView.delegate = self;
    self.tabView.dataSource  = self;
    self.tabView.tableHeaderView = self.tabeHeaderView;
    
}
#pragma mark 布局导航条
    
- (void)confugureNaviTitle{
    
    self.titleNavBar.alpha = 0;
    self.naviLable.frame = CGRectMake(0, 20, SCREEN_WIDTH, 40);
    [self.view addSubview:self.naviLable];
}

#pragma mark 返回按钮

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tabveView delegate 

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ActivityDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
