//
//  MainTabScrollCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/4.
//
//

#import "MainTabScrollCell.h"
#import "MainTabScrollCollectCell.h"
@implementation MainTabScrollCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCollectionViewWith:(NSString *)string{
    self.string = string;
    self.backgroundColor = [UIColor clearColor];
    [self.tabScrollCollectionView registerNib:[UINib nibWithNibName:@"MainTabScrollCollectCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    self.tabScrollCollectionView.delegate = self;
    self.tabScrollCollectionView.dataSource = self;
    
}
#pragma mark collectionView delegate
//item 数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

//设置分区数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//布局
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MainTabScrollCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];

    if (cell == nil) {
        NSArray* cells1 = [[NSBundle mainBundle] loadNibNamed:@"MainTabScrollCollectCell" owner:nil options:nil];
        cell = [cells1 objectAtIndex:0];
    }

    UIColor *color = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    NSString *string = [NSString stringWithFormat:@"%ld %ld",(long)indexPath.section,(long)indexPath.row];
    [cell configure:self.string];
    
    return cell;
}


//点击item 跳转
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *sting = [NSString stringWithFormat:@" %ld %ld ",(long)indexPath.section,(long)indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToShopWith:)]) {
        [self.delegate pushToShopWith:sting];
    }

}


//每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(150, 180);
}
@end
