//
//  SearchListViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/22.
//
//

#import "SearchListViewController.h"
#import "SearchListCell.h"
#import "XEEngine.h"
#import "XEShopListInfo.h"
#import "XEProgressHUD.h"
#import "MJExtension.h"
#import "ToyDetailViewController.h"
@interface SearchListViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *dataSources;

@end

@implementation SearchListViewController
- (NSMutableArray *)dataSources{
    if (!_dataSources) {
        self.dataSources = [NSMutableArray array];
    }
    return _dataSources;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configuresearchView];
    [self congigureTableView];

    // Do any additional setup after loading the view from its nib.
}
#pragma mark 布局TableView

- (void)congigureTableView{
    self.searchTab.delegate = self;
    self.searchTab.dataSource = self;
    [self.searchTab registerNib:[UINib nibWithNibName:@"SearchListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
//    self.searchTab.tableHeaderView = self.searchHeader;
}
#pragma mark 请求搜索数据
- (void)getSearchDataWith:(NSString *)string{
    __weak SearchListViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance]getShopListInfoMationWith:tag category:@"" pagenum:@"" type:@"" name:string serieid:@""];
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
        NSArray *array = jsonRet[@"object"][@"goodses"];
        if (self.dataSources.count > 0) {
            [self.dataSources removeAllObjects];
        }

        if (array.count > 0) {

            for (NSDictionary *dic in array) {
                XEShopListInfo *info = [XEShopListInfo objectWithKeyValues:dic];
                [self.dataSources addObject:info];
            }
            
        }
        
        [self.searchTab reloadData];
        
    } tag:tag];
}

#pragma mark 布局searchView

- (void)configuresearchView{
    CGRect tframe = self.titleNavBar.frame;
    self.searchView.center = self.titleNavBar.center;
    CGRect frame = self.searchView.frame;
    frame.origin.y = tframe.size.height - frame.size.height;
    self.searchView.frame = frame;
    [self.searchView setBackgroundColor:SKIN_COLOR];
    self.searchBar.showsCancelButton = NO;
    //光标颜色
    self.searchBar.tintColor = [UIColor whiteColor];
    self.searchBar.delegate = self;
    //外边框颜色
    self.searchBar.barTintColor = [UIColor whiteColor];
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.backgroundImage = [self imageWithColor:SKIN_COLOR size:self.searchBar.frame.size];
    //设置放大镜图片
    [self.searchBar setImage:[UIImage imageNamed:@"shopSearchBar"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    //谁输入框的背景颜色
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"激活"] forState:UIControlStateNormal];
    //外围加一个search边框可见
    self.searchHeaderLable.layer.borderColor = [UIColor whiteColor].CGColor;
    self.searchHeaderLable.layer.borderWidth = 1;
    self.searchHeaderLable.layer.cornerRadius = 5;
    [self.titleNavBar addSubview:self.searchView];

}

#pragma mark searchBar delegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //设置开始输入的时候文字的颜色为白色
    for (UIView *view in searchBar.subviews){
            for (id subview in view.subviews){
                if ( [subview isKindOfClass:[UITextField class]] ){
                    [(UITextField *)subview setTextColor:[UIColor whiteColor]];
                    return;
                }
            }
        }
    
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"%@",searchText);
    [self getSearchDataWith:searchText];
    
    
}

#pragma marksearchbar背景色

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
#pragma mark 取消按钮 释放第一响应
- (IBAction)cancle:(id)sender {
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableView delegate 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell configureCellWith:self.dataSources[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XEShopListInfo *info = self.dataSources[indexPath.row];
    ToyDetailViewController *detail = [[ToyDetailViewController alloc]init];
    detail.shopId = info.id;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:detail animated:YES];
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
