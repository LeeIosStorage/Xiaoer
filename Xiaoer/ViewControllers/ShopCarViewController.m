//
//  ShopCarViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/22.
//
//

#import "ShopCarViewController.h"
#import "ShopCarCell.h"
@interface ShopCarViewController ()<UITableViewDataSource,UITableViewDelegate,changeNumShopDelegate>
/**
 *  保存现价的数组
 */
@property (nonatomic,strong)NSMutableArray *afterPrice;
/**
 *  保存原价的数组
 */
@property (nonatomic,strong)NSMutableArray *fommerPrice;
/**
 *  保存是否被点击的数组 0 代表没有被点击  1代表被点击了
 */
@property (nonatomic,strong)NSMutableArray *touchedArray;
/**
 *  保存数量的数组
 */
@property (nonatomic,strong)NSMutableArray *numShop;

/**
 *  保留分区的数量的数组
 */
@property (nonatomic,strong)NSMutableArray *sectionNum;

@end

@implementation ShopCarViewController
- (NSMutableArray *)sectionNum{
    if (!_sectionNum){
        self.sectionNum = [NSMutableArray arrayWithObjects:@"1", nil];
    }
    return _sectionNum;
}
- (NSMutableArray *)afterPrice{
    if (!_afterPrice) {
        self.afterPrice = [NSMutableArray arrayWithObjects:@"12",@"40", nil];
    }
    return _afterPrice;
}

- (NSMutableArray *)fommerPrice{
    if (!_fommerPrice) {
        self.fommerPrice = [NSMutableArray arrayWithObjects:@"15",@"60", nil];
    }
    return _fommerPrice;
}

- (NSMutableArray *)touchedArray{
    if (!_touchedArray) {
        self.touchedArray = [NSMutableArray arrayWithObjects:@"0",@"0", nil];
    }
    return _touchedArray;
}
- (NSMutableArray *)numShop{
    if (!_numShop) {
        self.numShop = [NSMutableArray arrayWithObjects:@"1",@"1", nil];
    }
    return _numShop;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    //初始化优惠和小记的现实树木
    self.privilegeLab.text = @"0.00元";
    self.totalPrice.text = @"0.00元";
    
    [self configureTabView];
    [self configurePatBtn];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark cellDelagate
- (void)returnIndexOfShop:(NSInteger)index andNumberText:(NSString *)numText{
    self.numShop[index] = numText;
    self.totalPrice.text = [self calculateTotalPrice];
    self.privilegeLab.text = [self calculatePrivilege];
    [self.shopCarTab reloadData];
}
//- (void)returnIndexOfShop:(NSInteger)index andIfTouchedWith:(NSString *)string{
//    self.touchedArray[index] = string;
//    self.totalPrice.text = [self calculateTotalPrice];
//    self.privilegeLab.text = [self calculatePrivilege];
//    [self.shopCarTab reloadData];
//}

#pragma mark 计算小记价格
- (NSString *)calculateTotalPrice{
    CGFloat totalPric = 0;
    for (int i = 0; i < self.touchedArray.count; i++) {
        if ([self.touchedArray[i] isEqualToString:@"0"]) {
            //没有被点击加入结算不尽兴任何操作
        }else{
            CGFloat pric = [self.afterPrice[i] floatValue];
            CGFloat num = [self.numShop[i] floatValue];
            CGFloat onePric = pric*num;
            totalPric+= onePric;
        }
    }
    return [NSString stringWithFormat:@"%.2f元",totalPric];
    
}
#pragma mark  计算优惠价格
- (NSString *)calculatePrivilege{
    CGFloat totalPric = 0;
    for (int i = 0; i < self.touchedArray.count; i++) {
        if ([self.touchedArray[i] isEqualToString:@"0"]) {
            //没有被点击加入结算不尽兴任何操作
        }else{
            CGFloat fommerPric = [self.fommerPrice[i] floatValue];
            CGFloat afterPric = [self.afterPrice[i] floatValue];
            CGFloat cha = fommerPric - afterPric;
            CGFloat num = [self.numShop[i] floatValue];
            CGFloat onePric = cha*num;
            totalPric+= onePric;
        }
    }
    return [NSString stringWithFormat:@"%.2f元",totalPric];
}
#pragma mark  结算按钮点击
- (IBAction)payBtnTouched:(id)sender {
    NSLog(@"去结算按钮点击");
}

#pragma mark 布局支付按钮的layer
- (void)configurePatBtn{

    self.payBtn.layer.cornerRadius = 10;
    self.payBtn.layer.masksToBounds = YES;

}
#pragma mark 布局添加tableview属性

- (void)configureTabView{
    
    self.shopCarTab.delegate = self;
    self.shopCarTab.dataSource = self;
    self.shopCarTab.backgroundColor = [UIColor clearColor];
    [self.shopCarTab registerNib:[UINib nibWithNibName:@"ShopCarCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.shopCarTab.tableFooterView = self.tabFooterView;
}

#pragma mark tableView delegate datasources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.touchedArray.count;
}

//暂定的一个分区 隐藏区头
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionNum.count;
}

#warning 暂时隐藏区头
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0;
//}

//#warning 隐藏了区头
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *header = [self returnSectionHeader];
//    for (UIView *obj in header.subviews) {
//        if (obj.tag == 2) {
//            UILabel *lable = (UILabel *)obj;
//            lable.text = @"满22件";
//            
//        }
//    }
//    
//    return header;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.touchedArray[indexPath.row] isEqualToString:@"0"]) {
        self.touchedArray[indexPath.row] = @"1";
    }else{
        self.touchedArray[indexPath.row] = @"0";
    }
    NSLog(@"%@",self.touchedArray[indexPath.row]);
    self.totalPrice.text = [self calculateTotalPrice];
    self.privilegeLab.text = [self calculatePrivilege];
    [self.shopCarTab reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.delegate = self;
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    cell.numShopLab.text = [self.numShop objectAtIndex:indexPath.row];
    CGFloat formerPric = [[self.fommerPrice objectAtIndex:indexPath.row] floatValue] * [[self.numShop objectAtIndex:indexPath.row] floatValue];
    cell.formerPrice.text = [NSString stringWithFormat:@"¥%.2f",formerPric];
    CGFloat afterPric = [[self.afterPrice objectAtIndex:indexPath.row] floatValue] * [[self.numShop objectAtIndex:indexPath.row] floatValue];
    cell.afterPrice.text = [NSString stringWithFormat:@"¥%.2f",afterPric];
    cell.numShopLab.text = [self.numShop objectAtIndex:indexPath.row];
    NSLog(@"self.touchedArray[indexPath.row] ===== %@",self.touchedArray[indexPath.row]);
    
    [cell configureCellWith:indexPath andStateStr:self.touchedArray[indexPath.row]];
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        if (self.touchedArray.count > 1) {
            [self.afterPrice removeObjectAtIndex:indexPath.row];
            [self.fommerPrice removeObjectAtIndex:indexPath.row];
            [self.numShop removeObjectAtIndex:indexPath.row];
            [self.touchedArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }else{
            [self.afterPrice removeObjectAtIndex:indexPath.row];
            [self.fommerPrice removeObjectAtIndex:indexPath.row];
            [self.numShop removeObjectAtIndex:indexPath.row];
            [self.touchedArray removeObjectAtIndex:indexPath.row];
            [self.sectionNum removeObjectAtIndex:indexPath.section];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];
            
        }

        //删除结束的时候tableview的footerView不会重新计算价格，这里需要重新赋值，然后再roloadData
        self.totalPrice.text = [self calculateTotalPrice];
        self.privilegeLab.text = [self calculatePrivilege];
        [tableView reloadData];
        
    }
}

#warning  暂时不要区尾
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return [self returnSectionFooter];
//}

- (UIView *)returnSectionHeader{
    UIView *SectionHeader = [[UIView alloc]init];
    SectionHeader.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
    imageView.image = [UIImage imageNamed:@"HeaderJian"];
    imageView.tag = 0;
    
    UILabel *topTitle = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, SCREEN_WIDTH - 60, 20)];
    topTitle.text = @"玩具专场";
    topTitle.textColor = [UIColor blackColor];
    topTitle.tag = 1;
    
    UILabel *leftTitle = [[UILabel alloc]initWithFrame:CGRectMake(60, 25, 60, 20)];
    leftTitle.text = @"满2件";
    leftTitle.textColor = [UIColor lightGrayColor];
    leftTitle.tag = 2;
    
    UILabel *rightTitle = [[UILabel alloc]initWithFrame:CGRectMake(130, 25, 80, 20)];
    rightTitle.text = @"已打9折";
    rightTitle.textColor = [UIColor lightGrayColor];
    rightTitle.tag = 3;
    
    [SectionHeader addSubview:imageView];
    [SectionHeader addSubview:topTitle];
    [SectionHeader addSubview:leftTitle];
    [SectionHeader addSubview:rightTitle];
    
    return SectionHeader;
    
}

- (UIView *)returnSectionFooter{
    UIView *sectionFooter = [[UIView alloc]init];
    sectionFooter.backgroundColor = [UIColor whiteColor];
    
    UILabel *xiaoji = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 110, 0, 45, 25)];
    xiaoji.text = @"小计：";
    xiaoji.textColor = [UIColor blackColor];
    xiaoji.font = [UIFont systemFontOfSize:15];
    
    UILabel *xiaojiPric = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 0, 65, 25)];
    xiaojiPric.text = @"56元";
    xiaojiPric.textColor = [UIColor redColor];
    xiaojiPric.font = [UIFont systemFontOfSize:15];
    
    UILabel *youhui = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 110, 25, 65, 25)];
    youhui.text = @"优惠：";
    youhui.textColor = [UIColor lightGrayColor];
    youhui.font = [UIFont systemFontOfSize:15];
    
    UILabel *youhuiPric = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 25, 65, 25)];
    youhuiPric.text = @"2.6元";
    youhuiPric.textColor = [UIColor blackColor];
    youhuiPric.font = [UIFont systemFontOfSize:15];
    
    UIImageView *fenGe = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 37, 40, 1)];
    fenGe.image = [UIImage imageNamed:@"s_n_set_line"];
    
    [sectionFooter addSubview:xiaoji];
    [sectionFooter addSubview:xiaojiPric];
    [sectionFooter addSubview:youhui];
    [sectionFooter addSubview:youhuiPric];
    [sectionFooter addSubview:fenGe];
    return  sectionFooter;
    
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
