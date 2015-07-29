//
//  BabyImpressPrintController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/25.
//
//

#import "BabyImpressPrintController.h"
#import "BabyImpressCollectCell.h"

@interface BabyImpressPrintController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *printCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *printBtn;
@end

@implementation BabyImpressPrintController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.printCollectionView.backgroundColor = [UIColor clearColor];
    self.printBtn.layer.borderColor = SKIN_COLOR.CGColor;
    self.printBtn.layer.borderWidth = 1;
    self.printBtn.layer.cornerRadius = 5;
    
    [self configureCollectionView];
    // Do any additional setup after loading the view from its nib.
}
- (void)configureCollectionView{
    self.printCollectionView.delegate = self;
    self.printCollectionView.dataSource = self;
    [self.printCollectionView registerNib:[UINib nibWithNibName:@"BabyImpressCollectCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    UICollectionViewFlowLayout *flowOut = [[UICollectionViewFlowLayout alloc]init];
    flowOut.scrollDirection =  UICollectionViewScrollDirectionVertical;
    flowOut.minimumLineSpacing = 10;
    flowOut.minimumInteritemSpacing = 0;
    self.printCollectionView.collectionViewLayout = flowOut;
    
}

- (IBAction)printBtnTouched:(id)sender {
    NSLog(@"打印");
}

#pragma mark collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
    
}
//设置分区数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BabyImpressCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;

}

//每个Item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake((self.view.frame.size.width - 20)/3, (self.view.frame.size.width - 20)/3);
    
}

//每个Item的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(10, 0, 10, 0);
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
