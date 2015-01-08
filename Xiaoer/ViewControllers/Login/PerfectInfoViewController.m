//
//  PerfectInfoViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/8.
//
//

#import "PerfectInfoViewController.h"
#import "AppDelegate.h"
#import "MineTabCell.h"

@interface PerfectInfoViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

- (IBAction)saveAction:(id)sender;
@end

@implementation PerfectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTilteLeftViewHide:YES];
    
    self.saveButton.layer.cornerRadius = 4;
    self.saveButton.layer.masksToBounds = YES;
    self.tableView.tableFooterView = self.footerView;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    //title
    [self setTitle:@"完善资料"];
    
    [self setRightButtonWithTitle:@"跳过" selector:@selector(skipAction:)];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - custom
-(void)skipAction:(id)sender{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate signIn];
}

- (IBAction)saveAction:(id)sender {
    
}

-(NSDictionary *)tableDataModule{
    NSDictionary *moduleDict;
    NSMutableDictionary *tmpMutDict = [NSMutableDictionary dictionary];
    
    
    //section = 0
    NSMutableDictionary *sectionDict0 = [NSMutableDictionary dictionary];
    NSString *intro = @"";
    NSDictionary *dict00 = @{@"titleLabel": @"我的头像",
                           @"intro": intro!=nil?intro:@"",
                           };
    [sectionDict0 setObject:dict00 forKey:[NSString stringWithFormat:@"r%ld",sectionDict0.count]];
    
    //section = 1
    NSMutableDictionary *sectionDict1 = [NSMutableDictionary dictionary];
    intro = @"妈妈";
    NSDictionary *dict10 = @{@"titleLabel": @"昵称",
                            @"intro": intro!=nil?intro:@"",
                            };
    NSDictionary *dict11 = @{@"titleLabel": @"我的身份",
                             @"intro": intro!=nil?intro:@"",
                             };
    NSDictionary *dict12 = @{@"titleLabel": @"地区",
                             @"intro": intro!=nil?intro:@"",
                             };
    NSDictionary *dict13 = @{@"titleLabel": @"详细地址",
                             @"intro": intro!=nil?intro:@"",
                             };
    NSDictionary *dict14 = @{@"titleLabel": @"常用手机",
                             @"intro": intro!=nil?intro:@"",
                             };
    [sectionDict1 setObject:dict10 forKey:[NSString stringWithFormat:@"r%ld",sectionDict1.count]];
    [sectionDict1 setObject:dict11 forKey:[NSString stringWithFormat:@"r%ld",sectionDict1.count]];
    [sectionDict1 setObject:dict12 forKey:[NSString stringWithFormat:@"r%ld",sectionDict1.count]];
    [sectionDict1 setObject:dict13 forKey:[NSString stringWithFormat:@"r%ld",sectionDict1.count]];
    [sectionDict1 setObject:dict14 forKey:[NSString stringWithFormat:@"r%ld",sectionDict1.count]];
    
    //section = 2
    NSMutableDictionary *sectionDict2 = [NSMutableDictionary dictionary];
    intro = @"";
    NSDictionary *dict20 = @{@"titleLabel": @"宝宝头像",
                             @"intro": intro!=nil?intro:@"",
                             };
    NSDictionary *dict21 = @{@"titleLabel": @"宝宝昵称",
                             @"intro": intro!=nil?intro:@"",
                             };
    NSDictionary *dict22 = @{@"titleLabel": @"宝宝性别",
                             @"intro": intro!=nil?intro:@"",
                             };
    NSDictionary *dict23 = @{@"titleLabel": @"出生日期",
                             @"intro": intro!=nil?intro:@"",
                             };
    [sectionDict2 setObject:dict20 forKey:[NSString stringWithFormat:@"r%ld",sectionDict2.count]];
    [sectionDict2 setObject:dict21 forKey:[NSString stringWithFormat:@"r%ld",sectionDict2.count]];
    [sectionDict2 setObject:dict22 forKey:[NSString stringWithFormat:@"r%ld",sectionDict2.count]];
    [sectionDict2 setObject:dict23 forKey:[NSString stringWithFormat:@"r%ld",sectionDict2.count]];
    
    
    
    [tmpMutDict setObject:sectionDict0 forKey:[NSString stringWithFormat:@"s%ld",tmpMutDict.count]];
    [tmpMutDict setObject:sectionDict1 forKey:[NSString stringWithFormat:@"s%ld",tmpMutDict.count]];
    [tmpMutDict setObject:sectionDict2 forKey:[NSString stringWithFormat:@"s%ld",tmpMutDict.count]];
    
    moduleDict = tmpMutDict;
    return moduleDict;
}

-(NSInteger)newSections{
    
    return [[self tableDataModule] allKeys].count;
}
-(NSInteger)newSectionPolicy:(NSInteger)section{
    
    NSDictionary *rowContentDic = [[self tableDataModule] objectForKey:[NSString stringWithFormat:@"s%ld", section]];
    return [rowContentDic count];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self newSections];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    view.backgroundColor = UIColorRGB(240, 240, 240);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 61;
    }else if (indexPath.section == 1){
        return 35;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 61;
        }
    }
    return 35;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self newSectionPolicy:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MineTabCell";
    MineTabCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    
    CGRect frame = cell.leftAvater.frame;
    frame.size.width = 61-8*2;
    frame.size.height = frame.size.width;
    frame.origin.x = cell.frame.size.width - frame.size.width - 12;
    cell.leftAvater.frame = frame;
    cell.leftAvater.layer.cornerRadius = 5;
    cell.leftAvater.layer.masksToBounds = YES;
    
    cell.introLabel.hidden = NO;
    cell.leftAvater.hidden = YES;
    if (indexPath.section == 0 || indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.leftAvater.hidden = NO;
        }
    }
    
    NSDictionary *cellDicts = [[self tableDataModule] objectForKey:[NSString stringWithFormat:@"s%ld", indexPath.section]];
    NSDictionary *rowDicts = [cellDicts objectForKey:[NSString stringWithFormat:@"r%ld", indexPath.row]];
    NSLog(@"cellDicts==%@",rowDicts);
    cell.titleLabel.text = [rowDicts objectForKey:@"titleLabel"];
    cell.introLabel.text = [rowDicts objectForKey:@"intro"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
}
@end
