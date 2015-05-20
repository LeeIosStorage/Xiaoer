//
//  CardOfEastVerifyController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/5/19.
//
//

#import "CardOfEastVerifyController.h"
#import "CardOfEastSucceedController.h"
#import "XEEngine.h"
#import "NSString+Value.h"
#import "XEProgressHUD.h"

@interface CardOfEastVerifyController ()
-(void)checkPhone:(NSString *)phone;
@end

@implementation CardOfEastVerifyController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  注册单元格
     */
    [self.verifyTableView registerNib:[UINib nibWithNibName:@"CardInfoVerifyCell" bundle:nil] forCellReuseIdentifier:@"VerifyCell"];
    /**
     *  获取用户信息
     */
    [self getUserInfoInfomation];


    
}

- (void)getUserInfoInfomation{
    self.userIn = [XEEngine shareInstance].userInfo;
    self.leftLableTextArr = [NSMutableArray arrayWithObjects:@[@"卡号",@""],@[@"密码",@""],@[@"姓名",self.userIn.name],@[@"常用手机",self.userIn.phone],@[@"详细地址",self.userIn.address], nil];
}


#pragma mark cell的textfield的结束编辑执行的代理方法
- (void)passLeftLableText:(NSString *)LeftLableText textFieldtext:(NSString *)textFieldtext{
    
    
    if ([LeftLableText isEqualToString:@"卡号"]) {
        self.cardNum = textFieldtext;
    }
    
    if ([LeftLableText isEqualToString:@"密码"]) {
        self.passWord = textFieldtext;
    }
    
    if ([LeftLableText isEqualToString:@"姓名"]) {
        self.userIn.name = textFieldtext;
    }
    
    if ([LeftLableText isEqualToString:@"常用手机"]) {
        [self checkPhone:textFieldtext];
    }
    
    if ([LeftLableText isEqualToString:@"详细地址"]) {
        if (textFieldtext.length == 0) {
            [XEProgressHUD lightAlert:@"请输入您的地区"];
        }else{
            self.userIn.address = textFieldtext;
        }
    }
    //具体的判断与提示
    
}

- (void)checkInfoMationDown{
    if (self.cardNum.length == 0) {
        [XEProgressHUD lightAlert:@"请输入卡号"];
        return;
    }
    
    if (self.passWord.length == 0) {
        [XEProgressHUD lightAlert:@"请输入密码"];
        return;
    }
    
    if (self.userIn.name.length == 0) {
        [XEProgressHUD lightAlert:@"请输入姓名"];
        return;
    }
    
    if (self.userIn.phone.length == 0) {
        [XEProgressHUD lightAlert:@"请输入手机号"];
        return;
    }
    
    if (self.userIn.address.length == 0) {
        [XEProgressHUD lightAlert:@"请输入地址"];
        return;
    }
    [self saveInfo];

}
/**
 *  检测用户手机
 *
 */
-(void)checkPhone:(NSString *)phone{
    
    if (![phone isPhone]) {
        [XEProgressHUD lightAlert:@"请输入正确的手机号"];
        self.userIn.phone = phone;
        return;
    }
}


/**
 *  确认激活按钮
 *
 */
- (IBAction)verifyActivityBtn:(id)sender {
    
    [self checkInfoMationDown];
    

}


/**
 *  保存修改过的用户信息到本地
 */
- (void)saveInfo{
    __weak CardOfEastVerifyController *weakSelf = self;

    XEUserInfo *babyUserInfo = [XEEngine shareInstance].userInfo;
    [XEProgressHUD AlertLoading:@"保存中" At:self.view];
        int tag = [[XEEngine shareInstance] getConnectTag];
        [[XEEngine shareInstance] editUserInfoWithUid:babyUserInfo.uid name:babyUserInfo.name nickname:babyUserInfo.nickName hasBaby:babyUserInfo.hasbaby desc:babyUserInfo.desc district:babyUserInfo.region address:self.userIn.address phone:self.userIn.phone bbId:babyUserInfo.babyId bbName:babyUserInfo.babyNick bbGender:babyUserInfo.babyGender bbBirthday:babyUserInfo.birthdayString bbAvatar:babyUserInfo.babyAvatarId userAvatar:babyUserInfo.avatar dueDate:babyUserInfo.dueDateString hospital:self.userIn.hospital tag:tag];
        [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
            //        [XEProgressHUD AlertLoadDone];
            NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
            if (!jsonRet || errorMsg) {
                if (!errorMsg.length) {
                    errorMsg = @"保存修好失败";
                }
                [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
                return;
            }
            
            [XEProgressHUD AlertSuccess:[XEEngine getSuccessMsgWithReponseDic:jsonRet] At:weakSelf.view];
            [babyUserInfo setUserInfoByJsonDic:[[jsonRet objectForKey:@"object"] objectForKey:@"user"]];
            babyUserInfo.phone = self.userIn.phone;
            babyUserInfo.address = self.userIn.address;
            babyUserInfo.name = self.userIn.name;
            [XEEngine shareInstance].userInfo = babyUserInfo;

        }tag:tag];
    [self activity];


    



}


/**
 *  请求激活
 */
- (void)activity{
    __weak CardOfEastVerifyController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [XEEngine shareInstance].serverPlatform = TestPlatform;
    [[XEEngine shareInstance]activityEastCardWithKabaoid:@"9" userid:[XEEngine shareInstance].uid eno:@"1501000004" ekey:@"9385" tag:tag];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        /**
         *  获取失败信息
         */
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"激活失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }else{

            /**
             *  通知web页面激活按钮不可点击
             */
            [[NSNotificationCenter defaultCenter]postNotificationName:@"activity" object:nil];
            [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"] At:weakSelf.view];

            CardOfEastSucceedController *succeed = [[CardOfEastSucceedController alloc]init];
            UILabel *lable1 = (UILabel *)[succeed.view viewWithTag:1000];
            UILabel *lable2 = (UILabel *)[succeed.view viewWithTag:1001];
            [self.navigationController pushViewController:succeed animated:YES];
            succeed.cardNum.text = [NSString stringWithFormat:@"券号:%@",[[[jsonRet objectForKey:@"object"]objectForKey:@"cpe"] objectForKey:@"eastcardNo"]];
            succeed.cardPassWord.text = [NSString stringWithFormat:@"密码:%@",[[[jsonRet objectForKey:@"object"] objectForKey:@"cpe"] objectForKey:@"eastcardKey"]];
        }
    } tag:tag];
    

}


#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leftLableTextArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CardInfoVerifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VerifyCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell configureCellWith:[self.leftLableTextArr objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark  自定义全局变量 －懒加载

- (NSMutableArray *)leftLableTextArr{
    if (!_leftLableTextArr) {
        self.leftLableTextArr = [NSMutableArray array];
    }
    return _leftLableTextArr;
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
