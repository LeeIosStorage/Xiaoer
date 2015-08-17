//
//  BabyImpressPayWayController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/25.
//
//

#import "BabyImpressPayWayController.h"
#import "BabyImpressPayWayCell.h"
#import "BabyImpressPayWayOtherCell.h"
@interface BabyImpressPayWayController ()<UITableViewDataSource,UITableViewDelegate,changeIndexpathNumDelagete,payWayCellDelageta>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign)BOOL ifZero;
// 自费 保存选择状态的数组 0未选择 1已选择
@property (nonatomic,strong)NSMutableArray *ownStateArray;
/**
 *  早教中心 保存选择状态的数组 0未选择 1已选择
 */
@property (nonatomic,strong)NSMutableArray *otherStateArray;



@end

@implementation BabyImpressPayWayController
- (NSMutableArray *)otherStateArray{
    if (!_otherStateArray) {
        self.otherStateArray = [NSMutableArray array];
    }
    return _otherStateArray;
}
- (NSMutableArray *)ownStateArray{
    if (!_ownStateArray) {
        self.ownStateArray = [NSMutableArray array];
    }
    return _ownStateArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"配送方式";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self configureTableView];
    self.ifZero = NO;
    // Do any additional setup after loading the view from its nib.
}
- (void)configureTableView{
    [self.tableView registerNib:[UINib nibWithNibName:@"BabyImpressPayWayCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BabyImpressPayWayOtherCell" bundle:nil] forCellReuseIdentifier:@"other"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 40;
    [self.ownStateArray addObject:@"1"];
    [self.otherStateArray addObject:@"0"];
    [self.otherStateArray addObject:@"0"];
    [self.otherStateArray addObject:@"0"];
    [self.otherStateArray addObject:@"0"];
    [self.otherStateArray addObject:@"0"];

}
#pragma mark tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    lable.backgroundColor = [UIColor clearColor];
    if (section == 0) {
        lable.text = @"    自费快递";
    }else{
        lable.text = @"    早教中心（免费）";
    }
    return lable;
    
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1 ) {
        if (self.ifZero == YES) {
            return 1;
        }else{
            return self.otherStateArray.count;
        }
    }else{
        return self.ownStateArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 0) {
        return 40;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        BabyImpressPayWayOtherCell *other = [tableView dequeueReusableCellWithIdentifier:@"other" forIndexPath:indexPath];
        other.delegate = self;
        other.selectionStyle = 0;
        other.delegate = self;
        other.tag = indexPath.section *1000 + indexPath.row;
        return other;

    }else{
        
        BabyImpressPayWayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = 0;
        cell.tag = indexPath.section*1000 + indexPath.row;
        cell.delegate = self;
        
        if (indexPath.section == 0) {
            if ([self.ownStateArray[indexPath.row] isEqualToString:@"0"]) {
                [cell.chooseBtn setBackgroundImage:[UIImage imageNamed:@"babyPayWayNoUse"] forState:UIControlStateNormal];
            }else{
                [cell.chooseBtn setBackgroundImage:[UIImage imageNamed:@"babyPayWayUse"] forState:UIControlStateNormal];

            }
            [cell configureCellBtnWith:self.ownStateArray[indexPath.row]];
        }
        
        if (indexPath.section == 1) {
            if ([self.otherStateArray[indexPath.row] isEqualToString:@"0"]) {
                [cell.chooseBtn setBackgroundImage:[UIImage imageNamed:@"babyPayWayNoUse"] forState:UIControlStateNormal];
            }else{
                [cell.chooseBtn setBackgroundImage:[UIImage imageNamed:@"babyPayWayUse"] forState:UIControlStateNormal];
                
            }
            [cell configureCellBtnWith:self.otherStateArray[indexPath.row]];
        }
        
        
        
        return cell;
    }
    
    return nil;

}

- (void)payWayCellBtnTouchedWithTag:(NSInteger)index stateStr:(NSString *)string{
    NSLog(@"index === %ld",index);
    if (index < 999) {
        for (int i = 0; i < self.ownStateArray.count; i++) {
            self.ownStateArray[i] = @"0";
        }
        for (int j = 0; j < self.otherStateArray.count; j++) {
            self.otherStateArray[j] = @"0";
        }
        
        self.ownStateArray[index] = string;
    }else{
        NSLog(@"index/1000 === %ld",index%1000);
        for (int i = 0; i < self.ownStateArray.count; i++) {
            self.ownStateArray[i] = @"0";
        }
        for (int j = 0; j < self.otherStateArray.count; j++) {
            self.otherStateArray[j] = @"0";
        }
        self.otherStateArray[index%1000] = string;
        
    }
    [self.tableView reloadData];
}
#pragma mark cell delegate
- (void)ifNumIsZeroWith:(BOOL)ifNumZero{
    self.ifZero = ifNumZero;
    [self.tableView reloadData];
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
