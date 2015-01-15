//
//  ExpertIntroViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import "ExpertIntroViewController.h"
#import "XETopicViewCell.h"
#import "UIImageView+WebCache.h"

@interface ExpertIntroViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *doctorTopics;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *doctorNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *doctorCollegeLabel;
@property (strong, nonatomic) IBOutlet UILabel *doctorIntroLabel;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) IBOutlet UIButton *topicButton;
@property (strong, nonatomic) IBOutlet UIButton *fansButton;

- (IBAction)topicAction:(id)sender;
- (IBAction)fansAction:(id)sender;
@end

@implementation ExpertIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self refreshDoctorInfoShow];
    [self refreshExpertInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    [self setTitle:@"专家介绍"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)refreshExpertInfo{
    
    __weak ExpertIntroViewController *weakSelf = self;
    weakSelf.doctorTopics = [[NSMutableArray alloc] init];
    [weakSelf.doctorTopics addObject:@""];
    [weakSelf.doctorTopics addObject:@""];
    [weakSelf.doctorTopics addObject:@""];
    [weakSelf.doctorTopics addObject:@""];
    [weakSelf.doctorTopics addObject:@""];
    
    [weakSelf.tableView reloadData];
}

#pragma mark - custom
-(void)refreshDoctorInfoShow{
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2;
    self.avatarImageView.layer.masksToBounds = YES;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:@"http://f.hiphotos.baidu.com/image/pic/item/0823dd54564e9258a4909fe99f82d158ccbf4e14.jpg"] placeholderImage:[UIImage imageNamed:@""]];
    
    self.tableView.tableHeaderView = self.headView;
}

- (IBAction)topicAction:(id)sender {
    
}

- (IBAction)fansAction:(id)sender {
    
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _doctorTopics.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [XETopicViewCell heightForTopicInfo];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"XETopicViewCell";
    XETopicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
}

@end
