//
//  InformationViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/3.
//
//

#import "InformationViewController.h"
#import "RecipesViewController.h"
#import "ExpertListViewController.h"
#import "ActivityViewController.h"
#import "InfomationViewCell.h"
@interface InformationViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

//有四个选项的collectionView
@property (weak, nonatomic) IBOutlet UICollectionView *infomationCollection;


@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资讯";
    [self.infomationCollection  registerNib:[UINib nibWithNibName:@"InfomationViewCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    
}


#pragma mark collectionView delegate
//item 数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

//设置分区数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//布局
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    InfomationViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.titleLable.frame = CGRectMake(cell.contentView.frame.size.width/2 - 30, cell.contentView.frame.size.height/2 - 6, cell.contentView.frame.size.width - 60 , 12);
    cell.titleLable.backgroundColor = [UIColor redColor];
    if (indexPath.row == 0) {
        cell.titleLable.text = @"食谱";
        cell.imageView.image = [UIImage imageNamed:@"infomation_shiPu"];
                cell.titleLable.backgroundColor = [UIColor colorWithRed:248/255.0 green:193/255.0 blue:71/255.0 alpha:1];


    }
    if (indexPath.row == 1) {
        cell.titleLable.text = @"养育";
        cell.imageView.image = [UIImage imageNamed:@"infomation_yangyu"];
        cell.titleLable.backgroundColor = [UIColor colorWithRed:31/255.0 green:170/255.0 blue:225/255.0 alpha:1];



    }
    if (indexPath.row == 2) {
        cell.titleLable.text = @"专家";
        cell.imageView.image = [UIImage imageNamed:@"infomation_zhuanjia"];
        cell.titleLable.backgroundColor = [UIColor colorWithRed:113/255.0 green:81/255.0 blue:154/255.0 alpha:1];

    }
    if (indexPath.row == 3) {
        cell.titleLable.text = @"活动";
        cell.imageView.image = [UIImage imageNamed:@"infomation_huodong"];

        cell.titleLable.backgroundColor = [UIColor colorWithRed:103/255.0 green:181/255.0 blue:68/255.0 alpha:1];



    }
    /**
     *  圆角
     */
    cell.layer.cornerRadius = 10;
    return cell;
}


//点击item 跳转
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0 :{
            RecipesViewController *rVc = [[RecipesViewController alloc] init];
            rVc.infoType = TYPE_RECIPES;
            [self.navigationController pushViewController:rVc animated:YES];
        }
            break;
        case 1:{
            RecipesViewController *rVc = [[RecipesViewController alloc] init];
            rVc.infoType = TYPE_NOURISH;
            [self.navigationController pushViewController:rVc animated:YES];
            
        }
            break;

        case 2:{
            
            ExpertListViewController *vc = [[ExpertListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            ActivityViewController *vc = [[ActivityViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
            break;
        default:
            break;
    }
    
}


//每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH - 30 * 3)/2, (SCREEN_WIDTH - 30 * 3)/2);
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
