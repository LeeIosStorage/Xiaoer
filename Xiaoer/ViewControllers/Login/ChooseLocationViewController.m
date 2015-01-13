//
//  ChooseLocationViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/12.
//
//

#import "ChooseLocationViewController.h"
#import "XEEngine.h"

@interface ChooseLocationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    ChooseLoactionType _locationType;
}
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation ChooseLocationViewController

-(id) initWithLoactionType:(ChooseLoactionType) type WithCode:(NSString *) code
{
    self =[super init];
    if (self) {
        _locationType=type;
        _searchLocationCode=code;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = UIColorRGB(240, 240, 240);
    _tableView.contentInset=UIEdgeInsetsMake(81, 0, 0, 0);
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = view;
    [self getRegion];
}

-(void)getRegion{
    
    __weak ChooseLocationViewController *weakSelf=self;
    int tag =[[XEEngine shareInstance] getConnectTag];
    if (_dataArray.count>0) {
        [self.tableView reloadData];
    }else{
        if (_locationType == ChooseLoactionTypeProvince){
            [[XEEngine shareInstance] getCommonAreaRoot:tag];
        }else{
            [[XEEngine shareInstance] getCommonAreaNodeWithCode:_searchLocationCode tag:tag];
        }
        
        [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
            if (weakSelf == nil) {
                return ;
            }
            NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
            if (!jsonRet || errorMsg) {
                if (!errorMsg.length) {
                    errorMsg = @"请求失败";
                }
                return;
            }
            weakSelf.dataArray = [NSArray array];
            if (_locationType ==ChooseLoactionTypeProvince) {
                weakSelf.dataArray = [jsonRet objectForKey:@"object"];
            }else{
                weakSelf.dataArray = [jsonRet objectForKey:@"object"];
            }
            if (![weakSelf.dataArray isKindOfClass:[NSArray class]]) {
                weakSelf.dataArray = nil;
            }
            
            [weakSelf.tableView reloadData];
        } tag:tag];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews
{
    [self setTitle:@"选择地区"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        cell.backgroundColor = [UIColor whiteColor];
    }
    if (_locationType == ChooseLoactionTypeCountry) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *location =[_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [location objectForKey:@"name"];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *location =[_dataArray objectAtIndex:indexPath.row];
    
//    if (![[location objectForKey:@"name"] isEqualToString:@"市辖区"] && ![[location objectForKey:@"name"] isEqualToString:@"县"]) {
//        NSString *codeName = [location objectForKey:@"name"];
//        _searchLocationCodeName = _searchLocationCodeName!=nil?_searchLocationCodeName:@"";
//        NSMutableString *mutStr = [NSMutableString stringWithString:_searchLocationCodeName];
//        [mutStr appendString:[NSString stringWithFormat:@" %@",codeName]];
//        _searchLocationCodeName = mutStr;
//        
//    }
    if (_locationType == ChooseLoactionTypeCountry) {
        
        NSString *codeName = [location objectForKey:@"name"];
        if ([[location objectForKey:@"name"] isEqualToString:@"市辖区"] || [[location objectForKey:@"name"] isEqualToString:@"县"]){
            codeName = @"";
        }
        _searchLocationCodeName = [NSString stringWithFormat:@"%@ %@",_searchLocationCodeName,codeName];
        NSMutableDictionary *mutLocation = [NSMutableDictionary dictionaryWithDictionary:location];
        if (_searchLocationCodeName) {
            [mutLocation setObject:_searchLocationCodeName forKey:@"fullname"];
        }
        [_delegate didSelectLocation:mutLocation];
        [self.navigationController popToViewController:_delegate animated:YES];
        return;
    }else{
//        NSArray *tempArray = [location objectForKey:@"children"];
        if (_locationType==ChooseLoactionTypeProvince) {
            ChooseLoactionType nextType=ChooseLoactionTypeLocal;
            ChooseLocationViewController *chooseLocationVc=[[ChooseLocationViewController alloc] initWithLoactionType:nextType WithCode:[location objectForKey:@"code"]];
            NSString *codeName = [location objectForKey:@"name"];
            chooseLocationVc.searchLocationCodeName = codeName!=nil?[NSString stringWithFormat:@" %@",codeName]:@"";
            chooseLocationVc.delegate = self.delegate;
            [self.navigationController pushViewController:chooseLocationVc animated:YES];
            return;
        }if (_locationType==ChooseLoactionTypeLocal) {
            ChooseLoactionType nextType=ChooseLoactionTypeCountry;
            ChooseLocationViewController *chooseLocationVc=[[ChooseLocationViewController alloc] initWithLoactionType:nextType WithCode:[location objectForKey:@"code"]];
            NSString *codeName = [location objectForKey:@"name"];
            if ([[location objectForKey:@"name"] isEqualToString:@"市辖区"] || [[location objectForKey:@"name"] isEqualToString:@"县"]){
                codeName = @"";
            }
            chooseLocationVc.searchLocationCodeName = [NSString stringWithFormat:@"%@ %@",_searchLocationCodeName,codeName];
            chooseLocationVc.delegate = self.delegate;
            [self.navigationController pushViewController:chooseLocationVc animated:YES];
            return;
        }else{
            [self.delegate didSelectLocation:location];
            [self.navigationController popToViewController:self.delegate animated:YES];
        }
        
    }
}

@end
