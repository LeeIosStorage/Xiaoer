//
//  ShopCarViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/22.
//
//

#import "ShopCarViewController.h"
#import "ShopCarCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XEShopCarInfo.h"
#import "VerifyIndentViewController.h"
@interface ShopCarViewController ()<UITableViewDataSource,UITableViewDelegate,changeNumShopDelegate>
/**
 *  保存现价的数组
 */
@property (nonatomic,strong)NSMutableArray *afterPrice;
/**
 *  保存原价的数组
 */
@property (nonatomic,strong)NSMutableArray *fommerPrice;
/**
 *  保存是否被点击的数组 0 代表没有被点击  1代表被点击了
 */
@property (nonatomic,strong)NSMutableArray *touchedArray;
/**
 *  保存数量的数组
 */
@property (nonatomic,strong)NSMutableArray *numShop;

/**
 *  保留分区的数量的数组
 */
@property (nonatomic,strong)NSMutableArray *sectionNum;

@property (nonatomic,assign)NSInteger shopCarPage;

@property (nonatomic,assign)BOOL ifToEnd;

/**
 *  保存商品数组
 */
@property (nonatomic,strong)NSMutableArray *dataSources;


@end

@implementation ShopCarViewController
- (NSMutableArray *)dataSources{
    if (!_dataSources) {
        self.dataSources = [NSMutableArray array];
    }
    return _dataSources;
}
- (NSMutableArray *)sectionNum{
    if (!_sectionNum){
        self.sectionNum = [NSMutableArray arrayWithObjects:@"1", nil];
    }
    return _sectionNum;
}
- (NSMutableArray *)afterPrice{
    if (!_afterPrice) {
        self.afterPrice = [NSMutableArray arrayWithObjects:@"12",@"40", nil];
    }
    return _afterPrice;
}

- (NSMutableArray *)fommerPrice{
    if (!_fommerPrice) {
        self.fommerPrice = [NSMutableArray arrayWithObjects:@"15",@"60", nil];
    }
    return _fommerPrice;
}

- (NSMutableArray *)touchedArray{
    if (!_touchedArray) {
        self.touchedArray = [NSMutableArray array];
    }
    return _touchedArray;
}
- (NSMutableArray *)numShop{
    if (!_numShop) {
        self.numShop = [NSMutableArray arrayWithObjects:@"1",@"1", nil];
    }
    return _numShop;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.payBtn.layer.cornerRadius = 10;
    self.payBtn.layer.masksToBounds = YES;
    
    //初始化优惠和小记的现实价格
    self.privilegeLab.text = @"0.00元";
    self.totalPrice.text = @"0.00元";
    
    self.ifToEnd = NO;
    
    self.shopCarPage = 1;
    
    [self configureTabView];
    
    [self getShopCarInfomation];
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark 头部刷新
- (void)headerLoadData{
    
    //添加数据（刷新一次，新添加5个数据）
    self.ifToEnd = NO;
    self.shopCarPage = 1;
    [self getShopCarInfomation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        // 调用endRefreshing可以结束刷新状态
        [self.shopCarTab headerEndRefreshing];
    });
    
}


#pragma mark  尾部刷新
- (void)footerLoadData{
    
    if (self.ifToEnd == NO) {
        
        self.shopCarPage ++;
        [self getShopCarInfomation];
        
    }else{
        
        [XEProgressHUD lightAlert:@"已经到最后一页"];
        
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        // 调用endRefreshing可以结束刷新状态
        [self.shopCarTab footerEndRefreshing];
    });
    
}


#pragma mark 获取数据

- (void)getShopCarInfomation{
    
    __weak ShopCarViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    
    [[XEEngine shareInstance]getShopCarListInfomationWith:tag userid:[XEEngine shareInstance].uid onlygoods:@"1" pagenum:[NSString stringWithFormat:@"%ld",self.shopCarPage]];
    
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
        if ([jsonRet[@"object"][@"goodses"] isKindOfClass:[NSNull class]]) {
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            return;
        }
        
        NSString *endStr = [jsonRet[@"object"][@"end"]stringValue];
        if ([endStr isEqualToString:@"0"]) {
            self.ifToEnd = YES;
        }
        
        NSArray *array = jsonRet[@"object"][@"goodses"];
        
        if (array.count <= 0) {
            [XEProgressHUD lightAlert:@"购物车暂无商品"];
            return;
        }
        
        
        if (self.shopCarPage == 1 && self.dataSources.count > 0) {
            [self.dataSources removeAllObjects];
            [self.touchedArray removeAllObjects];
        }
        
        for (NSDictionary *dic in array) {
            
            XEShopCarInfo *info = [XEShopCarInfo objectWithKeyValues:dic];
            [self.dataSources addObject:info];
            [self.touchedArray addObject:@"0"];
        }
        
        [self.shopCarTab reloadData];
    } tag:tag];
    
}


#pragma mark 刷新购物车

- (void)refreshShopCarWithDel:(NSString *)del withIndoIndex:(NSInteger)index{
    __weak ShopCarViewController *weakSelf = self;
    
    XEShopCarInfo *info = (XEShopCarInfo *)self.dataSources[index];
    int tag = [[XEEngine shareInstance] getConnectTag];
    if (info.standard) {
        
    } else {
        info.standard = @"";
    }

    
    [[XEEngine shareInstance]refreshShopCarWithTag:tag del:del idNum:info.id num:info.num userid:[XEEngine shareInstance].uid goodsid:info.serieId standard:info.standard];
    
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        //获取失败信息
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return ;
        }
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"加载失败 请重试" At:weakSelf.view];
            return;
        }

    } tag:tag];
     
}
#pragma mark  结算

- (IBAction)payBtnTouched:(id)sender {
    
    NSLog(@"去结算按钮点击");
    //保存要支付的商品的数组
    NSMutableArray *shopArray = [NSMutableArray array];
    for (int i = 0 ; i < self.touchedArray.count; i++) {
        if ([self.touchedArray[i] isEqualToString:@"1"]) {
            XEShopCarInfo *info = (XEShopCarInfo *)self.dataSources[i];
            [shopArray addObject:info];
        }
 
    }
    
    if (shopArray.count == 0) {
        
        [XEProgressHUD lightAlert:@"请选择要支付的商品"];
        
    }else{
        VerifyIndentViewController *verify = [[VerifyIndentViewController alloc]init];
        verify.shopArray = shopArray;
        [self.navigationController pushViewController:verify animated:YES];
        
    }
}



#pragma mark 布局添加tableview属性

- (void)configureTabView{
    
    self.shopCarTab.delegate = self;
    self.shopCarTab.dataSource = self;
    self.shopCarTab.backgroundColor = [UIColor clearColor];
    [self.shopCarTab addHeaderWithTarget:self action:@selector(headerLoadData)];
    [self.shopCarTab addFooterWithTarget:self action:@selector(footerLoadData)];
    [self.shopCarTab registerNib:[UINib nibWithNibName:@"ShopCarCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.shopCarTab.tableFooterView = self.tabFooterView;
}

#pragma mark tableView delegate datasources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

//暂定的一个分区 隐藏区头
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionNum.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.touchedArray[indexPath.row] isEqualToString:@"0"]) {
        self.touchedArray[indexPath.row] = @"1";
    }else{
        self.touchedArray[indexPath.row] = @"0";
    }
    NSLog(@"%@",self.touchedArray[indexPath.row]);
    self.totalPrice.text = [self calculateTotalPrice];
    self.privilegeLab.text = [self calculatePrivilege];
    [self.shopCarTab reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.delegate = self;
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    XEShopCarInfo *info = (XEShopCarInfo *)self.dataSources[indexPath.row];

    [cell configureCellWith:indexPath andStateStr:self.touchedArray[indexPath.row]info:info];
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak ShopCarViewController *weakSelf = self;
    XEShopCarInfo *info = (XEShopCarInfo *)self.dataSources[indexPath.row];
    int tag = [[XEEngine shareInstance] getConnectTag];
    if (info.standard) {
    } else {
        info.standard = @"";
    }
    [[XEEngine shareInstance]refreshShopCarWithTag:tag del:@"1" idNum:info.id num:info.num userid:[XEEngine shareInstance].uid goodsid:info.serieId standard:info.standard];
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        if (self.touchedArray.count > 1) {
            [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
                //获取失败信息
                NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
                if (errorMsg) {
                    [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
                    return ;
                }
                if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
                    [XEProgressHUD AlertError:@"删除失败，请重试" At:weakSelf.view];
                    return;
                }
                
                [self.dataSources removeObjectAtIndex:indexPath.row];
                [self.touchedArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
                
            } tag:tag];


        }else{
            
            [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
                //获取失败信息
                NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
                if (errorMsg) {
                    [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
                    return ;
                }
                if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
                    [XEProgressHUD AlertError:@"删除失败，请重试" At:weakSelf.view];
                    return;
                }
                [self.dataSources removeObjectAtIndex:indexPath.row];
                [self.touchedArray removeObjectAtIndex:indexPath.row];
                //一定要删除分区数量
                [self.sectionNum removeAllObjects];
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];
 
                
            } tag:tag];


        }

        //删除结束的时候tableview的footerView不会重新计算价格，这里需要重新赋值，然后再roloadData
        self.totalPrice.text = [self calculateTotalPrice];
        self.privilegeLab.text = [self calculatePrivilege];
        [tableView reloadData];
        
    }
}

#warning  暂时不要区尾
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return [self returnSectionFooter];
//}

- (UIView *)returnSectionHeader{
    UIView *SectionHeader = [[UIView alloc]init];
    SectionHeader.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
    imageView.image = [UIImage imageNamed:@"HeaderJian"];
    imageView.tag = 0;
    
    UILabel *topTitle = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, SCREEN_WIDTH - 60, 20)];
    topTitle.text = @"玩具专场";
    topTitle.textColor = [UIColor blackColor];
    topTitle.tag = 1;
    
    UILabel *leftTitle = [[UILabel alloc]initWithFrame:CGRectMake(60, 25, 60, 20)];
    leftTitle.text = @"满2件";
    leftTitle.textColor = [UIColor lightGrayColor];
    leftTitle.tag = 2;
    
    UILabel *rightTitle = [[UILabel alloc]initWithFrame:CGRectMake(130, 25, 80, 20)];
    rightTitle.text = @"已打9折";
    rightTitle.textColor = [UIColor lightGrayColor];
    rightTitle.tag = 3;
    
    [SectionHeader addSubview:imageView];
    [SectionHeader addSubview:topTitle];
    [SectionHeader addSubview:leftTitle];
    [SectionHeader addSubview:rightTitle];
    
    return SectionHeader;
    
}

#pragma mark cellDelagate
- (void)returnIndexOfShop:(NSInteger)index andNumberText:(NSString *)numText{
    XEShopCarInfo *info = (XEShopCarInfo *)self.dataSources[index];
    info.num = numText;
    
    [self refreshShopCarWithDel:@"0" withIndoIndex:index];
    if ([self.touchedArray[index] isEqualToString:@"1"]) {
        self.totalPrice.text = [self calculateTotalPrice];
        self.privilegeLab.text = [self calculatePrivilege];
    }
    [self.shopCarTab reloadData];
    
}


#pragma mark 计算小记价格
- (NSString *)calculateTotalPrice{
    
    CGFloat totalPric = 0;
    for (int i = 0; i < self.touchedArray.count; i++) {
        if ([self.touchedArray[i] isEqualToString:@"0"]) {
            //没有被点击加入结算不尽兴任何操作
        }else{
            XEShopCarInfo *info = (XEShopCarInfo *)self.dataSources[i];
            CGFloat pric = [info.price floatValue];
            CGFloat num = [info.num floatValue];
            CGFloat onePric = pric*num;
            totalPric+= onePric;
        }
    }
    return [NSString stringWithFormat:@"%.2f元",totalPric/100];
    
}
#pragma mark  计算优惠价格
- (NSString *)calculatePrivilege{
    CGFloat totalPric = 0;
    for (int i = 0; i < self.touchedArray.count; i++) {
        if ([self.touchedArray[i] isEqualToString:@"0"]) {
            //没有被点击加入结算不尽兴任何操作
        }else{
            XEShopCarInfo *info = (XEShopCarInfo *)self.dataSources[i];
            CGFloat fommerPric = [info.origPrice floatValue];
            CGFloat afterPric = [info.price floatValue];
            CGFloat cha = fommerPric - afterPric;
            CGFloat num = [info.num floatValue];
            CGFloat onePric = cha*num;
            totalPric+= onePric;
        }
    }
    return [NSString stringWithFormat:@"%.2f元",totalPric/100];
}
- (UIView *)returnSectionFooter{
    UIView *sectionFooter = [[UIView alloc]init];
    sectionFooter.backgroundColor = [UIColor whiteColor];
    
    UILabel *xiaoji = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 110, 0, 45, 25)];
    xiaoji.text = @"小计：";
    xiaoji.textColor = [UIColor blackColor];
    xiaoji.font = [UIFont systemFontOfSize:15];
    
    UILabel *xiaojiPric = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 0, 65, 25)];
    xiaojiPric.text = @"56元";
    xiaojiPric.textColor = [UIColor redColor];
    xiaojiPric.font = [UIFont systemFontOfSize:15];
    
    UILabel *youhui = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 110, 25, 65, 25)];
    youhui.text = @"优惠：";
    youhui.textColor = [UIColor lightGrayColor];
    youhui.font = [UIFont systemFontOfSize:15];
    
    UILabel *youhuiPric = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 25, 65, 25)];
    youhuiPric.text = @"2.6元";
    youhuiPric.textColor = [UIColor blackColor];
    youhuiPric.font = [UIFont systemFontOfSize:15];
    
    UIImageView *fenGe = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 37, 40, 1)];
    fenGe.image = [UIImage imageNamed:@"s_n_set_line"];
    
    [sectionFooter addSubview:xiaoji];
    [sectionFooter addSubview:xiaojiPric];
    [sectionFooter addSubview:youhui];
    [sectionFooter addSubview:youhuiPric];
    [sectionFooter addSubview:fenGe];
    return  sectionFooter;
    
}


//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0;
//}

//#warning 隐藏了区头
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *header = [self returnSectionHeader];
//    for (UIView *obj in header.subviews) {
//        if (obj.tag == 2) {
//            UILabel *lable = (UILabel *)obj;
//            lable.text = @"满22件";
//
//        }
//    }
//
//    return header;
//}

#warning 暂时隐藏区头
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0;
//}
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
