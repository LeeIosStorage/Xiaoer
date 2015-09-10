//
//  XEAppOrderInfomationController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/9/8.
//
//

#import "XEAppOrderInfomationController.h"
#import "XEAPPAgreeDeclarationController.h"
#import "AppOrderInfomationCell.h"
#import "NSString+Value.h"
#import "MyAttributedStringBuilder.h"
#import "XEAppOrderVerifyController.h"
#import "XEUIUtils.h"
@interface XEAppOrderInfomationController ()<UITableViewDataSource,UITableViewDelegate,appOrderInfomationDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIButton *aggreBtn;
@property (weak, nonatomic) IBOutlet UIButton *postOrder;
@property (nonatomic,assign)BOOL ifAgree;
- (IBAction)postOrderClick:(id)sender;
@property (nonatomic,strong)NSMutableArray *dataSources;
@end

@implementation XEAppOrderInfomationController
- (NSMutableArray *)dataSources{
    if (!_dataSources) {
        self.dataSources = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    }
    return _dataSources;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约信息";
    self.view.backgroundColor =LGrayColor;
    self.ifAgree = YES;
    self.postOrder.layer.cornerRadius = 8;
    self.postOrder.layer.masksToBounds = YES;
    self.chooseBtn.imageView.image = [UIImage imageNamed:@"app_choose"];
    [self configureTableView];
    

}
- (void)configureTableView{
    [self.tableView registerNib:[UINib nibWithNibName:@"AppOrderInfomationCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.footerView.backgroundColor = LGrayColor;
    self.tableView.tableFooterView = self.footerView;

    
}

#pragma mark --- UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppOrderInfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = 0;
    [cell configureCellWith:indexPath];
    return cell;
}
- (IBAction)chooseAgree:(id)sender {
    if ([self.chooseBtn.imageView.image isEqual:[UIImage imageNamed:@"app_noChoose"]])
    {
        [self.chooseBtn setImage:[UIImage imageNamed:@"app_choose"] forState:UIControlStateNormal];
        self.ifAgree = YES;
        
    }else
    {
        [self.chooseBtn setImage:[UIImage imageNamed:@"app_noChoose"] forState:UIControlStateNormal];
        self.ifAgree = NO;
    }

}
- (IBAction)showDeclation:(id)sender {
    XEAPPAgreeDeclarationController *declation = [[XEAPPAgreeDeclarationController alloc]init];
    [self.navigationController pushViewController:declation animated:YES];
}
- (IBAction)postOrderClick:(id)sender {
    [self.view endEditing:YES];
    if (self.ifAgree == YES) {
        
    }else{
        [XEProgressHUD lightAlert:@"您还没有同意《晓儿挂号用户协议》"];
        return;
    }
    
    NSString *name = self.dataSources[0];
    if (name.length <=0)
    {
        [XEProgressHUD lightAlert:@"请填写就诊人姓名"];
        return;
        
    }
    NSString *cardNum = self.dataSources[1];
    if ([XEUIUtils validateIDCardNumber:cardNum] == YES) {
        NSLog(@"可以");
    }else{
        [XEProgressHUD lightAlert:@"请填写正确的身份证号"];
        return;
    }


    
    NSString *phone = self.dataSources[2];
    if (phone.length != 11) {
        [XEProgressHUD lightAlert:@"请填写正确的手机号码"];
        return;
    }
    

     [self postOrderData];
   
}
- (void)postOrderData
{
    int tag = [[XEEngine shareInstance]getConnectTag];
    [[XEEngine shareInstance]appOrderInfomationGoToOrderWith:tag userid:[XEEngine shareInstance].uid linkname:self.dataSources[0] linkphone:self.dataSources[2] linkcardno:self.dataSources[1] hdaid:self.hdaid];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        if ([jsonRet[@"code"] isEqual:@0]) {
            [XEProgressHUD AlertSuccess:@"下单成功"];
            XEAppOrderVerifyController *order = [[XEAppOrderVerifyController alloc]init];
            order.dic = jsonRet[@"object"];
            
            [self.navigationController pushViewController:order animated:YES];

            return ;
        }
      
        else if ([jsonRet[@"code"] isEqual:@2]) {
            [XEProgressHUD AlertError:@"您输入的手机号有误"];
            return ;
        }
        else if ([jsonRet[@"code"] isEqual:@3]) {
            [XEProgressHUD AlertError:@"您输入的身份证号有误"];
            return ;
        }
        
        else if ([jsonRet[@"code"] isEqual:@5]) {
            [XEProgressHUD AlertSuccess:@"专家坐诊不存在"];
            return ;
        }
        else if ([jsonRet[@"code"] isEqual:@6]) {
            [XEProgressHUD AlertSuccess:@"专家坐诊剩余名额不足1"];
            return ;
        }
        else if ([jsonRet[@"code"] isEqual:@7]) {
            [XEProgressHUD AlertSuccess:@"实际下单而未付款已超过3单，请支付或15分钟后再下单"];
            return ;
        }else{
            [XEProgressHUD AlertError:@"下单失败"];
        }
        
    } tag:tag];
}
- (void)passLeftLabTextWith:(NSString *)leftText textFieldText:(NSString *)textFieldText{
    if ([leftText isEqualToString:@"就诊人"]) {
        NSLog(@"就诊人");
        if (textFieldText) {
            self.dataSources[0] = textFieldText;
        }
    }
    if ([leftText isEqualToString:@"身份账号"]) {
        NSLog(@"身份证号");
        if (textFieldText) {
            self.dataSources[1] = textFieldText;
        }

    }
    if ([leftText isEqualToString:@"联系手机"]) {
        NSLog(@"联系手机");
        if (textFieldText) {
            self.dataSources[2] = textFieldText;
        }

    }
}
@end
