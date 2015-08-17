//
//  BabyImpressTransmitLoveController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/8/14.
//
//

#import "BabyImpressTransmitLoveController.h"
#import "BabyImpressBoundPhoneController.h"
@interface BabyImpressTransmitLoveController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UILabel *phoneLab;

@property (weak, nonatomic) IBOutlet UILabel *numLoveLab;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *numLoveTextfield;
@property (weak, nonatomic) IBOutlet UIButton *vetifyBtn;

@property (nonatomic,strong)NSString *phoneText;
@property (nonatomic,strong)NSString *numText;

- (IBAction)vetifuBtnTouched:(id)sender;

@end

@implementation BabyImpressTransmitLoveController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"传递爱心";
    [self setRightButtonWithTitle:@"绑定手机" selector:@selector(pinlessPhone)];
    [self configureTableView];
    /**
     * 给texfField 添加 动态通知
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change:) name:UITextFieldTextDidChangeNotification object:nil];
    
    /**
     *  键盘将要出现的监听
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(babyImpressKeyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    /**
     *  键盘将要消失的监听
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(babyImpressKeyBoardEndChangeFrame:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}
- (void)dealloc{
    /**
     *  移通知
     */
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];

}
- (void)change:(NSNotification *)sender{
    UITextField *textField = sender.object;
    if ([textField isEqual:self.phoneTextField]) {
        NSLog(@"电话  %@",self.phoneTextField.text);
        
    }
    if ([textField isEqual:self.numLoveTextfield]) {
        NSLog(@"数量  %@",self.numLoveTextfield.text);
    }
    
}

- (void)configureTableView{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableHeaderView = [self creatTabHeaderView];
    self.tableView.tableFooterView = self.footerView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.phoneLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.phoneLab.layer.borderWidth = 1;
    self.phoneLab.layer.masksToBounds = YES;
    self.phoneLab.layer.cornerRadius = 5;
    
    self.numLoveLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.numLoveLab.layer.borderWidth = 1;
    self.numLoveLab.layer.masksToBounds = YES;
    self.numLoveLab.layer.cornerRadius = 5;
    
    
    self.numLoveTextfield.delegate = self;
    self.phoneTextField.delegate = self;

    self.phoneTextField.placeholder = @"请输入传递爱心人手机号码";
    self.numLoveTextfield.placeholder = @"请输入传递爱心值（最低10分最高100分）";
    self.vetifyBtn.layer.cornerRadius = 5;
    self.vetifyBtn.layer.masksToBounds = YES;
    
}
- (UIView *)creatTabHeaderView{
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, SCREEN_WIDTH - 40, 0)];
    lable.font = [UIFont systemFontOfSize:17];
    lable.numberOfLines = 0;
    lable.text = @"\t 首月20张，次月10张照片，觉着不够？想要每天都能有一张宝宝照片记忆？可以，晓儿了解到好多宝妈，宝爸的心声，故此通过传递爱心的办法，可以使每个用户每个月打印的照片达到30张喔！\n\t 每位宝妈，宝爸通过好友赠送，可获得更多照片打印权，快去邀请亲朋好友来赠送自己照片打印权吧。这里需要注意喔：为了防止赠送出错，每个用户都需要绑定唯一手机号码验证成功之后才能顺利接受赠送喔！";
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName, nil];

    CGRect rect = [lable.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    CGRect textFram = lable.frame;
    textFram.size.height = rect.size.height ;
    lable.frame = textFram;
    [self.headerView addSubview:lable];
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70 + rect.size.height);
    return self.headerView;
    
}
#pragma mark  tableView delegate 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

#pragma mark -  UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (void)pinlessPhone{
    NSLog(@"绑定手机");
    BabyImpressBoundPhoneController *phone = [[BabyImpressBoundPhoneController alloc]init];
    [self.navigationController pushViewController:phone animated:YES];
}

- (IBAction)vetifuBtnTouched:(id)sender {
    NSLog(@"确认传递爱心");

    [self.phoneTextField resignFirstResponder];
    [self.numLoveTextfield resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark 键盘将要消失的监听
- (void)babyImpressKeyBoardEndChangeFrame:(NSNotification *)note{
    
    //取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}


- (void)selfChangeFrame{
    //取出键盘动画的时间
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    
}
#pragma mark 键盘将要出现的监听
- (void)babyImpressKeyBoardWillChangeFrame:(NSNotification *)note{
    //取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //取出键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    //计算控制器的view需要偏移评议的距离
    
    
    CGFloat transForm =  keyboardFrame.size.height;
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, -transForm , SCREEN_WIDTH, SCREEN_HEIGHT);
        
    }];
    
}

@end
