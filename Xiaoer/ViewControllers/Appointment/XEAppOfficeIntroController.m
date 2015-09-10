//
//  XEAppOfficeIntroController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/9/7.
//
//

#import "XEAppOfficeIntroController.h"
#import "AppHospitalIntroCell.h"
#import "AppHospitalListHeaderView.h"
#import "XEAppOfficeAppointmentController.h"

@interface XEAppOfficeIntroController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *appointment;
- (IBAction)appointClick:(id)sender;
@end

@implementation XEAppOfficeIntroController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约挂号";

    self.appointment.layer.cornerRadius = 5;
    self.appointment.layer.masksToBounds = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self configureTableView];
    self.webView.delegate = self;
    NSLog(@"%@  %@",self.tableView,self.hos);
    //网页加载
    NSString *url = [NSString stringWithFormat:@"%@/hb/hospital/deptDetailh5/%@",[[XEEngine shareInstance] baseUrl],self.sub.id];
    
    [self loadWebViewWithUrl:[NSURL URLWithString:url]];
    // Do any additional setup after loading the view from its nib.
}
- (void)configureTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"AppHospitalIntroCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    AppHospitalListHeaderView *header = [AppHospitalListHeaderView appHospitalListHeaderView];
    header.titleLable.text = self.hos.name;
    header.rightBtn.hidden = YES;
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [AppHospitalListHeaderView appHospitalListHeaderView].frame.size.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AppHospitalIntroCell cellHeightWith:self.sub.des];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppHospitalIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell configureIntroCellWithSub:self.sub];
    cell.selectionStyle = 0;
    cell.rightBtn.hidden = YES;
    return cell;
}


- (void)loadWebViewWithUrl:(NSURL *)url {
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    [XEProgressHUD AlertLoading:@"正在加载"];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [XEProgressHUD AlertSuccess:@"加载成功"];
    CGRect frame = self.footerView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size.height = fittingSize.height;
    self.footerView.frame = frame;
    self.tableView.tableFooterView = self.footerView;
    [self.tableView reloadData];
}

#pragma mark  预约按钮点击
- (IBAction)appointClick:(id)sender {
    XELog(@"appointClick");
    XEAppOfficeAppointmentController *app = [[XEAppOfficeAppointmentController alloc]init];
    app.sub = self.sub;
    app.hospitalName = self.hos.name;
    [self.navigationController pushViewController:app animated:YES];
}
@end
