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
@interface BabyImpressMainController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *rullView;
@property (weak, nonatomic) IBOutlet UILabel *rulLab;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (nonatomic,strong)UIAlertView *chooseWayUpload;
@property (nonatomic,assign)BOOL ifHide;
@property (nonatomic,strong)NSMutableArray *imageArray ;
@property (nonatomic,strong)NSMutableArray *desArray;
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
        self.desArray = [NSMutableArray arrayWithObjects:@"2015年，“新家庭”启动了《“婴幼儿早期发展评估与促进”公益计划》，依照国家卫生计生委针对0-3岁婴幼儿发展的统一标准，逐步帮助社区指导中心、早教中心配置“婴幼儿早期发展评估与促进”软硬件系统。为更多宝宝免费提供语言、动作、适应、社交等多方面能力发展的科学评估和促进指导。",@"为了帮助更多的社区指导中心、早教中心尽快能够采购和配置“婴幼儿早期发展评估与促进”软硬件系统，让更多的宝宝能够得到免费发展评估和指导，“新家庭”发起了“10分公益”主题活动，希望邀请您及您周边的0-3岁家庭，以互帮互助的爱心，共同为推进我们的《“婴幼儿早期发展评估与促进”公益计划》献出一小份心意——不要那么多，每份爱心只要10分钱！",@"您的每一份爱心，都将得到超乎想象的惊喜：“新家庭”将在创学科技、晓儿信息、恒印影像、七牛云存储等单位的大力支持下，在您每献出每一份0.1元爱心的同时，我们都将免费为您冲印宝宝照片一张，多献多得，惊喜全年。", nil];
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
    [self configureTableView];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(begainPostImage:) name:@"begainPostImage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endPostImage:) name:@"endPostImage" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)begainPostImage:(NSNotificationCenter *)sender{
    NSLog(@"收到开始上传通知");
    self.ifPostFinished = NO;
}
- (void)endPostImage:(NSNotificationCenter *)sender{
    NSLog(@"收到正在上传通知");
    
    self.ifPostFinished = YES;
}

- (void)configureTableView{
    self.tableView.delegate= self;
    self.tableView.dataSource = self;
    [self.tableView  registerNib:[UINib nibWithNibName:@"BabyImpressMainCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [self creatFooterView];
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 40;
}

- (UIView *)creatFooterView{
    UIView *footer = [[UIView alloc]init];
    self.rulLab.text = @"1:本活动暂限0-3岁婴幼儿家庭参加;\n2:用户每献一份0.1元爱心即获得免费冲印6寸照片一张；\n3:用户首月上传照片的上限为20张，次月上限为10张；\n4:次月始，邀请好友参与本次活动，上传上限增为30张；\n5:照片将在每月一次性打印后快递至用户指定地址，首月免收快递费（全国通用）；\n6:本次公益活动将于2015年9月正式开始，主办方将有权根据活动进程适当调整活动规则。  \n";
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil];
    CGRect rect = [self.rulLab.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    CGRect textFram = self.rulLab.frame;
    textFram.size.height = rect.size.height ;
    self.rulLab.frame = textFram;
    self.rullView.frame = CGRectMake(0, 0, SCREEN_WIDTH, rect.size.height + 100 );
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

    return 40;
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
            return 1;
        }else{
            return 3;
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
    if (self.ifPostFinished == YES) {
        [self.chooseWayUpload show];
    }else{
        [XEProgressHUD lightAlert:@"正在上传图片，请到别处看看"];
    }
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

@end
