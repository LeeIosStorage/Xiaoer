//
//  ShopViewCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/18.
//
//

#import "ShopViewCell.h"
#import "WaterFlowLayout.h"
#import "WaterCollectionCell.h"
@interface ShopViewCell  ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateWaterFlowLayout>
@property (nonatomic,strong)WaterFlowLayout *flowOut;

@end


@implementation ShopViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configureCellWith:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        self.flowOut.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/2, 0);
    }else{
        self.flowOut.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/2 + 50, 0);
    }
    self.itemHeight = self.contentView.frame.size.height;
    self.collectionview.collectionViewLayout = self.flowOut;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerNib:[UINib nibWithNibName:@"WaterCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}
- (WaterFlowLayout *)flowOut{
    if (!_flowOut) {
        self.flowOut = [[WaterFlowLayout alloc]init];
        _flowOut.numberOfColumns = 2;
        _flowOut.delegate = self;
        _flowOut.sectionInsets = UIEdgeInsetsMake(0,0, 0, 0);
    }
    return _flowOut;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView waterFlowLayout:(WaterFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath{
    
        return self.itemHeight;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WaterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.waterImage.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)collectionView.superview.superview;
    NSLog(@" tag = %ld",collectionView.superview.superview.tag);
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchCellWithSection:row:)] ) {
        [self.delegate touchCellWithSection:cell.tag row:indexPath.row];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
