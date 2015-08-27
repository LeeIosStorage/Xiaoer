//
//  BabyImpressVerifyController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/23.
//
//

#import "BabyImpressVerifyController.h"
#import "AddAddressViewController.h"
#import "AddressManagerController.h"
#import "XEAddressListInfo.h"
#import "BabyImpressPayWayController.h"
#import "BabyImpressMyPictureController.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "GoToPayViewController.h"
#import "AddressInfoManager.h"
#import "AppDelegate.h"
#import "BabyImpressMainController.h"
#import "MJExtension.h"
@interface BabyImpressVerifyController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,postInfoDelegate,refreshAddtessInfoDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIView *noAddressView;
@property (strong, nonatomic) IBOutlet UIView *haveAddressView;
@property (strong, nonatomic) IBOutlet UIView *noPayWayView;
@property (strong, nonatomic) IBOutlet UIView *havePayView;
@property (strong, nonatomic) IBOutlet UIView *noteView;

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (nonatomic,assign)BOOL ifHavePayWay;

@property (nonatomic,strong)XEAddressListInfo *addressInfo;
@property (weak, nonatomic) IBOutlet UILabel *infoPhone;
@property (weak, nonatomic) IBOutlet UILabel *infoAddress;
@property (weak, nonatomic) IBOutlet UILabel *infoName;

/**
 *  照片数量
 */
@property (weak, nonatomic) IBOutlet UILabel *numPhotoLab;
/**
 *  运费
 */
@property (weak, nonatomic) IBOutlet UILabel *carriageMoneyLab;
/**
 *  总金额
 */
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLab;
/**
 *  纯照片金额
 */
@property (weak, nonatomic) IBOutlet UILabel *photoMoney;

@property (weak, nonatomic) IBOutlet UILabel *totalLove;
/**
 *  需要充值
 */
@property (nonatomic,strong)UIAlertView *needRechargeAlert;


@property (nonatomic,strong)NSMutableArray *addListArray;

@end

@implementation BabyImpressVerifyController

- (NSMutableArray *)addListArray{
    if (!_addListArray) {
        self.addListArray = [NSMutableArray array];
    }
    return _addListArray;
}
- (UIAlertView *)needRechargeAlert{
    if (!_needRechargeAlert) {
        self.needRechargeAlert = [[UIAlertView alloc]initWithTitle:@"亲，您的爱心分不足以打印，请先充值爱心分或者呼叫好友赠送喔。" message:nil delegate:self cancelButtonTitle:@"暂时不去" otherButtonTitles:@"马上充值", nil];
    }
    return _needRechargeAlert;
}


- (NSMutableArray *)dataSources{
    if (!_dataSources) {
        self.dataSources = [NSMutableArray array];
    }
    return _dataSources;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if ([XEEngine shareInstance].userInfo.lovePoint) {
        self.totalLove.text =  [XEEngine shareInstance].userInfo.lovePoint;
    }else{
        self.totalLove.text = @"0";
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.tableview.backgroundColor = [UIColor clearColor];
    self.verifyBtn.layer.cornerRadius = 5;
    self.verifyBtn.layer.masksToBounds = YES;
    self.ifHavePayWay = NO;
    self.numPhotoLab.text = [NSString stringWithFormat:@"%ld张",(unsigned long)self.dataSources.count];
    self.carriageMoneyLab.text = @"0.00";


    self.photoMoney.text = [NSString stringWithFormat:@"%.2lu",self.dataSources.count*10];

    
    self.totalMoneyLab.attributedText = [self creatTotalMoneyTextWith:[NSString stringWithFormat:@"合计：￥%.2f",[self.carriageMoneyLab.text floatValue]]];

    [self configureTableView];
    [self getDefaultAddressInfo];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deledate:) name:@"editVerifyInfo" object:nil];


}
- (void)getDefaultAddressInfo{
    __weak BabyImpressVerifyController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    
    [[XEEngine shareInstance]getAddressListWithTag:tag userId:[XEEngine shareInstance].uid];
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
        NSArray *array = jsonRet[@"object"];
        if (array.count == 0) {
            [XEProgressHUD lightAlert:@"暂无默认地址信息，请添加"];
            return;
            
        }
        [self.addListArray removeAllObjects];
        if (jsonRet[@"object"]) {
            
            for (NSDictionary *dic in array) {
                XEAddressListInfo *info = [XEAddressListInfo objectWithKeyValues:dic];
                if ([info.def isEqualToString:@"1"]) {
                    self.addressInfo = info;
                }
                [self.addListArray addObject:info];
            }
            
            if (!self.addressInfo.id) {
                [XEProgressHUD lightAlert:@"暂无默认地址信息，请添加"];
            }
            [self configureTableView];
            
        }else{
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
        }
    } tag:tag];
    

}
- (void)refreshAddRessInfoList{
    __weak BabyImpressVerifyController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    
    [[XEEngine shareInstance]getAddressListWithTag:tag userId:[XEEngine shareInstance].uid];
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
        NSArray *array = jsonRet[@"object"];
        if (array.count == 0) {
            [XEProgressHUD lightAlert:@"暂无默认地址信息，请添加"];
            return;
            
        }
        [self.addListArray removeAllObjects];
        if (jsonRet[@"object"]) {
            for (NSDictionary *dic in array) {
                XEAddressListInfo *info = [XEAddressListInfo objectWithKeyValues:dic];
                [self.addListArray addObject:info];
            }
        }else{
            
        }
        
    } tag:tag];
}
- (void)deledate:(NSNotificationCenter *)sender{
    NSLog(@"进入");
    self.tableview.tableHeaderView = self.noAddressView;
    [self refreshAddRessInfoList];
    [self.tableview reloadData];

}


#pragma mark 请求运费
- (void)getCarriageMoney{
    [[XEEngine shareInstance]refreshUserInfo];
    __weak BabyImpressVerifyController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance]qiNiuGetCarriageMoneyWith:tag provinceid:self.addressInfo.provinceId userid:[XEEngine shareInstance].uid];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        //获取失败信息
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return ;
        }
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"删除运费失败" At:weakSelf.view];
            return;
        }
        
        if ([jsonRet[@"object"] isKindOfClass:[NSNull class]]) {
            self.carriageMoneyLab.text = @"0.00";
            [XEProgressHUD AlertError:@"删除运费失败" At:weakSelf.view];
        }
        if (jsonRet[@"object"]) {
            self.carriageMoneyLab.text = [NSString stringWithFormat:@"%.2f",[jsonRet[@"object"] floatValue]/100];
        }
        self.totalMoneyLab.attributedText = [self creatTotalMoneyTextWith:[NSString stringWithFormat:@"合计：￥%.2f",[self.carriageMoneyLab.text floatValue]]];
        self.tableview.tableHeaderView = [self returnAddressView];
        [self.tableview reloadData];
    } tag:tag];
    
}


#pragma mark  创建价格text
- (NSMutableAttributedString *)creatTotalMoneyTextWith:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return nil;
    }
    NSString *dou = @"：";
    NSRange rang = [string rangeOfString:dou];
    NSMutableAttributedString *strA = [[NSMutableAttributedString alloc] initWithString:string];
    [strA addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, rang.location)];
    [strA addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, rang.location + 1)];
    [strA addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(rang.location, string.length  - rang.location)];
    [strA addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(rang.location + 1, string.length  - rang.location - 1)];
    return strA;
}
- (IBAction)verrfyBtnTouched:(id)sender {

    if ([self.totalLove.text floatValue] < [self.photoMoney.text floatValue]) {
        [self.needRechargeAlert show];
        return;
    }
    
    if (self.view.frame.origin.y == 0) {
    } else {
        [self animtionTabView];
    }
    
    if (!self.addressInfo.provinceId) {
        [XEProgressHUD lightAlert:@"请选择收货地址"];
        return;
    }
    NSString *textStr;
    if (self.textView.text.length == 0) {
        textStr = @"";
    }else{
        textStr = self.textView.text;
    }
    
    __weak BabyImpressVerifyController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    NSLog(@"结算  ＝＝  %@", self.addressInfo.id);
    [[XEEngine shareInstance]qiNiuOrderWith:tag userid:[XEEngine shareInstance].uid useraddressid:self.addressInfo.id mark:self.textView.text tip:@"1"];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {


        NSString *string = [[jsonRet objectForKey:@"code"] stringValue];
        
        if ([self.carriageMoneyLab.text floatValue]> 0) {
            //有运费
            
            if ([string isEqualToString:@"0"]) {
                [XEProgressHUD AlertSuccess:@"下单成功"];
                
                GoToPayViewController *goToPay = [[GoToPayViewController alloc]init];
                goToPay.orderPrice = [NSString stringWithFormat:@"%.2f",[jsonRet[@"object"][@"money"] floatValue]/100];
                goToPay.orderNum = [NSString stringWithFormat:@"%@",jsonRet[@"object"][@"orderNo"]];
                goToPay.from = @"1";
                [[AddressInfoManager manager]addDictionaryWith:self.addressInfo With:[XEEngine shareInstance].uid];
                [self.navigationController pushViewController:goToPay animated:YES];
                return;
            }else if ([string isEqualToString:@"5"]){
                
                [XEProgressHUD AlertError:@"尊敬的用户，订单实际已支付或发货无法再次下单" At:weakSelf.view];
                return;
                
            }else if ([string isEqualToString:@"6"]){
                
                [XEProgressHUD AlertError:@"亲，您的爱心分不足以打印，请先充值爱心分或者呼叫好友赠送喔。" At:weakSelf.view];
                return;
                
            }else if ([string isEqualToString:@"7"]){
                
                [XEProgressHUD AlertError:@"亲，您的爱心分不足以打印，请先充值爱心分或者呼叫好友赠送喔。" At:weakSelf.view];
                return;
                
            }else{
                [XEProgressHUD AlertError:@"下单失败" At:weakSelf.view];
                return;
 
            }
            
            
            
            
        }else{
            //无运费
            if ([string isEqualToString:@"0"]) {
                [XEProgressHUD AlertSuccess:@"订单支付成功，请留意稍后短信信息喔！"];
                [[AddressInfoManager manager]addDictionaryWith:self.addressInfo With:[XEEngine shareInstance].uid];
                [[XEEngine shareInstance]refreshUserInfo];
                [self.tableview reloadData];
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[BabyImpressMainController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                }
                
            }else if ([string isEqualToString:@"5"]){
                
                [XEProgressHUD AlertError:@"尊敬的用户，订单实际已支付或发货无法再次下单" At:weakSelf.view];
                return;
                
            }else if ([string isEqualToString:@"6"]){
                
                [XEProgressHUD AlertError:@"亲，您的爱心分不足以打印，请先充值爱心分或者呼叫好友赠送喔。" At:weakSelf.view];
                return;
                
            }else if ([string isEqualToString:@"7"]){
                
                [XEProgressHUD AlertError:@"亲，您的爱心分不足以打印，请先充值爱心分或者呼叫好友赠送喔。" At:weakSelf.view];
                return;
                
            }else{
                [XEProgressHUD AlertError:@"下单失败" At:weakSelf.view];
                return;
                
            }
        }
        
    } tag:tag];
    
}

- (IBAction)noAddressBtnTouched:(id)sender {
    if (self.addListArray.count == 0) {
        AddAddressViewController *add = [[AddAddressViewController alloc]init];
        add.delegate = self;
        add.ifHaveDeleteBtn = NO;
        [self.navigationController pushViewController:add animated:YES];
    }else{
        
        AddressManagerController *manager = [[AddressManagerController alloc]init];
        manager.delegate = self;
        manager.fromVerifyInfo = self.addressInfo;
        [self.navigationController pushViewController:manager animated:YES];
    }

}
- (void)postInfoWith:(XEAddressListInfo *)info{
    self.addressInfo = info;
    [self getCarriageMoney];
}
- (IBAction)haveAddressBtnTouched:(id)sender {
    AddressManagerController *manager = [[AddressManagerController alloc]init];
    manager.delegate = self;
    manager.fromVerifyInfo = self.addressInfo;
    [self.navigationController pushViewController:manager animated:YES];
}

- (void)refreshAddressInfoWith:(XEAddressListInfo *)info{
    self.addressInfo = info;
    [self getCarriageMoney];
}

#warning 暂时不设置配送方式
- (IBAction)noPayBtnTouched:(id)sender {
    
//    BabyImpressPayWayController *payWay = [[BabyImpressPayWayController alloc]init];
//    [self.navigationController pushViewController:payWay animated:YES];
}

- (void)configureTableView{
    [self.tableview  registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableview.delegate  = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [self creatFooterView];
    self.tableview.tableHeaderView = [self returnAddressView];
    
    self.textView.delegate = self;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 8;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
}

- (UIView *)creatFooterView{
    for (UIView *view in self.tableview.tableFooterView.subviews) {
        [view removeFromSuperview];
    }
    
    
    UIView *footer = [[UIView alloc]init];
    UIView *payWay = [self returhPayWayView];
#warning 此版本备注留言不要 暂时隐藏
    self.noteView.frame = CGRectMake(0, payWay.frame.size.height, SCREEN_WIDTH, 0);
    self.footerView.frame = CGRectMake(0, payWay.frame.size.height + self.noteView.frame.size.height, SCREEN_WIDTH, 290);
    footer.frame = CGRectMake(0, 0, SCREEN_WIDTH, payWay.frame.size.height + self.noteView.frame.size.height + self.footerView.frame.size.height);
    [footer addSubview:payWay];
    [footer addSubview:self.noteView];
    [footer addSubview:self.footerView];
    if (self.addressInfo) {
        [self getCarriageMoney];
        NSLog(@"  self.addressInfo.id == %@",self.addressInfo.id);

    }
    return footer;
}
- (UIView *)returnAddressView{

    if (!self.addressInfo.id) {
        return  self.noAddressView;
    }else{
        self.infoAddress.text = self.addressInfo.address;
        self.infoName.text = self.addressInfo.name;
        self.infoPhone.text = self.addressInfo.phone;
        NSLog(@"  self.addressInfo.id == %@",self.addressInfo.id);

        return self.haveAddressView;
    }
}

- (UIView *)returhPayWayView{
    
    if (self.ifHavePayWay == NO) {
        self.noPayWayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        return self.noPayWayView;
    }else{
        self.havePayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 135);

        return self.havePayView;
    }
    
}

#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark alert Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"buttonIndex  == %ld",(long)buttonIndex);
    if (alertView == self.needRechargeAlert) {
        switch (buttonIndex) {
            case 0:
                
                break;
            case 1:
                [self judgeIfCanRecharge];
                break;
            default:
                break;
        }
    }
}
- (void)judgeIfCanRecharge{
    
    NSLog(@"充值");
    if ([[XEEngine shareInstance] needUserLogin:nil]) {
        return;
    }
    
    __weak BabyImpressVerifyController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance]loveIfCanOrderWith:tag userid:[XEEngine shareInstance].uid];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"该月已有已支付爱心订单,不允许下单" At:weakSelf.view];
            return;
        }
        
        /**
         *  下单
         */
        [self placeAnOrder];
    } tag:tag];

}
- (void)placeAnOrder{
    
    __weak BabyImpressVerifyController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance]lovePlaceAnOrderWith:tag userid:[XEEngine shareInstance].uid];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"该月实际已有已付款爱心订单,下单失败!" At:weakSelf.view];
            return;
        }
        [XEProgressHUD AlertSuccess:@"下单成功"];
        GoToPayViewController *pay = [[GoToPayViewController alloc]init];
        pay.orderPrice = [NSString stringWithFormat:@"%.2f",[jsonRet[@"object"][@"money"] floatValue]/100];
        pay.orderNum = [NSString stringWithFormat:@"%@",jsonRet[@"object"][@"orderNo"]];
        pay.from = @"2";
        [self.navigationController pushViewController:pay animated:YES];
        
    } tag:tag];
}
#pragma mark 回车键 回收键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark 
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self animtionTabView];
}
- (void)animtionTabView{
    if (SCREEN_HEIGHT >= 568) {
        return;
    }
    if (self.view.frame.origin.y == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.tableview setContentOffset:CGPointMake(0, 0) animated:NO];
            self.view.frame = CGRectMake(0, - (SCREEN_WIDTH/3), SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
        
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.tableview setContentOffset:CGPointMake(0, 0) animated:NO];
            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.view.frame.origin.y == 0) {
        
    } else {
        [self animtionTabView];
    }
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
