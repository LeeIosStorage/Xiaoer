//
//  ToyListViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/19.
//
//

#import "ToyListViewController.h"
#import "XETitleNavBarView.h"
#import "ToyListCollectionCell.h"
#import "ToyCollectionHeaderCell.h"
#import "ToyDetailViewController.h"
@interface ToyListViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *naviLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UICollectionView *toyListCollection;
@property (nonatomic,strong)UICollectionViewFlowLayout *layOut;

@end

@implementation ToyListViewController
- (UICollectionViewFlowLayout *)layOut{
    if (!_layOut) {
        self.layOut = [[UICollectionViewFlowLayout alloc]init];
        _layOut.scrollDirection =  UICollectionViewScrollDirectionVertical;
        _layOut.minimumLineSpacing = 10;
        _layOut.minimumInteritemSpacing = 10;
    }
    return _layOut;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    布局导航条
    [self confugureNaviTitle];
    self.toyListCollection.delegate = self;
    self.toyListCollection.dataSource = self;
    
    [self.toyListCollection registerNib:[UINib nibWithNibName:@"ToyCollectionHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"header"];
    [self.toyListCollection registerNib:[UINib nibWithNibName:@"ToyListCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}

#pragma mark 布局导航条
- (void)confugureNaviTitle{
    self.titleNavBar.alpha = 0;
    self.view.backgroundColor = [UIColor purpleColor];
    self.naviLable.frame = CGRectMake(0, 20, SCREEN_WIDTH, 40);
    self.titleLable.text = @"玩具专场";
    [self.view addSubview:self.naviLable];
}

- (IBAction)back:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark collection delegate 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
    
}
//设置分区数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        ToyCollectionHeaderCell *header = [collectionView dequeueReusableCellWithReuseIdentifier:@"header" forIndexPath:indexPath];
        return header;
    }else{
        ToyListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        return cell;
        
    }
}

//每个Item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==0) {
        return CGSizeMake(SCREEN_WIDTH, 240);
    }else{
        return CGSizeMake((SCREEN_WIDTH - 30) / 2, (SCREEN_WIDTH - 30) / 2 + 60 );
    }
}

//每个Item的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}

//区头的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

//点击item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld %ld",(long)indexPath.section,(long)indexPath.row);
    ToyDetailViewController *detail = [[ToyDetailViewController alloc]init];
    [self.navigationController pushViewController:detail animated:YES];
    
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
