//
//  ExpertListViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import "ExpertListViewController.h"
#import "ExpertListViewCell.h"
#import "UIImageView+WebCache.h"
#import "ExpertIntroViewController.h"

@interface ExpertListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *expertList;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation ExpertListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = UIColorRGB(240, 240, 240);
    [self refreshExpertList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    [self setTitle:@"晓儿专家"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)refreshExpertList{
    
    __weak ExpertListViewController *weakSelf = self;
    weakSelf.expertList = [[NSMutableArray alloc] init];
    [weakSelf.expertList addObject:@""];
    [weakSelf.expertList addObject:@""];
    [weakSelf.expertList addObject:@""];
    
    [weakSelf.tableView reloadData];
}

#pragma mark - custom


#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _expertList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.row == 1) {
//        return 100;
//    }
    return 145;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ExpertListViewCell";
    ExpertListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:@"http://f.hiphotos.baidu.com/image/pic/item/0823dd54564e9258a4909fe99f82d158ccbf4e14.jpg"] placeholderImage:[UIImage imageNamed:@""]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
    ExpertIntroViewController *vc = [[ExpertIntroViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
