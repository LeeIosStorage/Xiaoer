//
//  EveryOneWeekController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/8.
//
//

#import "EveryOneWeekController.h"
#import "OneWeakCell.h"
@interface EveryOneWeekController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTabView;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@end

@implementation EveryOneWeekController

//- (void)loadView{
//    [super loadView];
////    [self.view addSubview:self.tableView];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainTabView registerNib:[UINib nibWithNibName:@"OneWeakCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cells"];
    self.mainTabView.dataSource = self;
    self.mainTabView.delegate = self;
    self.mainTabView.tableHeaderView = self.headerView;

    
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OneWeakCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cells"];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"OneWeakCell" owner:self options:nil];
        cell = array.lastObject;
    }

    return cell;
}
- (IBAction)touchHeaderBtn:(id)sender {
    NSLog(@"点击头部");
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
