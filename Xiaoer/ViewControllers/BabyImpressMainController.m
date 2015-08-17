//
//  BabyImpressMainController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/23.
//
//

#import "BabyImpressMainController.h"
#import "BabyImpressVerifyController.h"
#import "BabyImpressAddController.h"
#import "BabyImpressMainCell.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "BabyImpressDeclareViewController.h"
#import "BabyImpressTransmitLoveController.h"
@interface BabyImpressMainController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *rullView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (nonatomic,strong)UIAlertView *chooseWayUpload;
@property (nonatomic,assign)BOOL ifHide;
@property (nonatomic,strong)NSMutableArray *imageArray ;
@property (nonatomic,strong)NSMutableArray *desArray;
/**
 *  疑问
 *
 */
- (IBAction)askBtn:(id)sender;
/**
 *  充值
 */
@property (weak, nonatomic) IBOutlet UIButton *topUp;

- (IBAction)topUpBtnToouched:(id)sender;

@end

@implementation BabyImpressMainController

- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        self.imageArray = [NSMutableArray arrayWithObjects:@"babyCellFirst",@"babyCellSecond",@"babyCellThird", nil];
    }
    return _imageArray;
}
- (NSMutableArray *)desArray{
    if (!_desArray) {
        self.desArray = [NSMutableArray arrayWithObjects:@"“10分公益”活动是由国家卫生计生委主导的“新家庭”项目，面向全国0~3岁婴幼儿家庭推出的爱心传递公益活动。每位参加活动奉献爱心的家长都将获得由“新家庭”送出的惊喜大礼哦~", nil];
    }
    return _desArray;
}




- (UIAlertView *)chooseWayUpload{
    if (!_chooseWayUpload) {
        self.chooseWayUpload = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    }
    return _chooseWayUpload;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ifHide = YES;
    self.topUp.layer.cornerRadius = 3;
    self.topUp.layer.masksToBounds = YES;
    [self configureTableView];


    self.title = @"宝宝印像";
    [self setRightButtonWithTitle:@"传递爱心" selector:@selector(transmitLove)];
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)transmitLove{
    NSLog(@"传递爱心");
    BabyImpressTransmitLoveController *transmitLove = [[BabyImpressTransmitLoveController alloc]init];
    [self.navigationController pushViewController:transmitLove animated:YES];
}

- (void)configureTableView{
    self.tableView.delegate= self;
    self.tableView.dataSource = self;
    [self.tableView  registerNib:[UINib nibWithNibName:@"BabyImpressMainCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.tableHeaderView = [self creatHeaderView];
    self.tableView.tableFooterView = [self creatFooterView];
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 40;
}
- (UIView *)creatHeaderView{
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 260, SCREEN_WIDTH - 40, 0)];
    lable.font = [UIFont systemFontOfSize:16];
    lable.numberOfLines = 0;
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil];
    lable.text = @"      10分公益”活动是由国家卫生计生委主导的“新家庭”项目，面向全国0~3岁婴幼儿家庭推出的爱心传递公益活动。每位参加活动奉献爱心的家长都将获得由“新家庭”送出的惊喜大礼哦~";
    
    CGRect rect = [lable.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    CGRect textFram = lable.frame;
    textFram.size.height = rect.size.height ;
    lable.frame = textFram;
    [self.headerView addSubview:lable];
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 260 + rect.size.height);
    return  self.headerView;
    
}
- (UIView *)creatFooterView{
    UIView *footer = [[UIView alloc]init];
    UILabel *rulLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, SCREEN_WIDTH - 40, 0)];
    rulLab.text = @"1、本活动面向全国0~3岁婴幼儿家庭的家长。\n2、用户每奉献一份0.1元的爱心，都将免费获得由主办方提供免费冲印的宝宝照片一张，以回馈其付出的爱心。\n3、每个注册用户首月限上传20张照片，主办方将免费冲印并包邮递送；从次月开始可邀请好友共同参与爱心传递，上传上限为30张照片，邮费自理。\n\n\t“新家庭”诚挚地邀请您一起参加“10 分公益”。您的每一份爱心，都将是对“婴幼儿早期发展和促进”公益行动最珍贵的帮助。献上“10分”爱心，获得精美照片，还在等什么呢？ ";
    rulLab.font = [UIFont systemFontOfSize:16];
    rulLab.numberOfLines = 0;
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil];
    CGRect rect = [rulLab.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    CGRect textFram = rulLab.frame;
    textFram.size.height = rect.size.height ;
    rulLab.frame = textFram;
    [self.rullView addSubview:rulLab];
    self.rullView.frame = CGRectMake(0, 0, SCREEN_WIDTH, rect.size.height + 60 );
    self.footerView.frame = CGRectMake(0, self.rullView.frame.size.height, SCREEN_WIDTH, 160);
    footer.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.rullView.frame.size.height + self.footerView.frame.size.height);
    [footer addSubview:self.footerView];
    [footer addSubview:self.rullView];
    return footer;
    
}
- (void)hideCell{
    NSLog(@"点击");
    self.ifHide =! self.ifHide;
    [self.tableView reloadData];
}
#pragma mark tableView delegate 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
    return     [self contentHeightWith:self.desArray[indexPath.row]];

    }else{

    }
    
    return 0;
}
- (CGFloat)contentHeightWith:(NSString *)desStr{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName, nil];
    CGRect rect = [desStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height + 260;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.ifHide == YES) {
            return 0;
        }else{
            return 0;
        }
    }
    return 0;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        view.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = [[UIImageView alloc]init];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 120, 20)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(hideCell) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        button.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 60, 40);
        [view addSubview:imageView];
        [view addSubview:button];
        [view addSubview:lable];
        if (self.ifHide == YES) {
            lable.text = @"查看活动详情";
            imageView.frame = CGRectMake(SCREEN_WIDTH - 40, 13, 13 , 20);
            imageView.image = [UIImage imageNamed:@"babyPayWayRight"];

        }else{
            lable.text = @"收起活动详情";
            imageView.frame = CGRectMake(SCREEN_WIDTH - 40, 13, 20, 13);
            imageView.image = [UIImage imageNamed:@"babyPayWayDown"];
        }
        return view;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BabyImpressMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    if (self.ifHide == YES) {
        [cell configureCellWithDesStr:[self.desArray lastObject] imageStr:[self.imageArray lastObject]];
    }else{
        [cell configureCellWithDesStr:self.desArray[indexPath.row] imageStr:self.imageArray[indexPath.row]];
    }

    return cell;
}

#pragma mark 上传照片按钮点击
- (IBAction)uploadPhotoBtnTouched:(id)sender {
        [self.chooseWayUpload show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    [XEEngine shareInstance].serverPlatform = TestPlatform;
    if (alertView == self.chooseWayUpload) {
        
        NSLog(@"%ld ",(long)buttonIndex);

        switch (buttonIndex) {
            case 0:
                //取消
            {

            }
                break;
            case 1:
                //拍照
            {
                if ([[XEEngine shareInstance] needUserLogin:nil]) {
                    return;
                }
                if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"未检测到摄像头" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                    return;
                }else{
                    BabyImpressAddController *add = [[BabyImpressAddController alloc]init];
                    add.index = 0;
                    [self.navigationController pushViewController:add animated:YES];


                }

            }
                break;
            case 2:
                //从手机相册选择
            {
                if ([[XEEngine shareInstance] needUserLogin:nil]) {
                    return;
                }
                BabyImpressAddController *add = [[BabyImpressAddController alloc]init];
                add.index = 1;
                [self.navigationController pushViewController:add animated:YES];
            }
                break;
            default:
                break;
        }
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
#pragma mark 充值

- (IBAction)topUpBtnToouched:(id)sender {

}
#pragma mark 疑问

- (IBAction)askBtn:(id)sender {
    BabyImpressDeclareViewController *declare = [[BabyImpressDeclareViewController alloc]init];
    [self.navigationController pushViewController:declare animated:YES];
}
@end
