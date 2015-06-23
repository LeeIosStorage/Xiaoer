//
//  WaterFlowLayout.m
//  瀑布流
//
//  Created by 王鹏 on 15/6/15.
//  Copyright (c) 2015年 王鹏. All rights reserved.
//

#import "WaterFlowLayout.h"

@interface WaterFlowLayout  ()

@property (nonatomic, assign) NSUInteger numberOfItems;//item的数量
@property (nonatomic, assign) CGFloat interitemSpacing;//item的列间距
@property (nonatomic, retain) NSMutableArray *columnHeights;//用来保存每列的总高度的数组
@property (nonatomic, retain) NSMutableArray *itemAttributes;//用来保存最终计算出的每个item的数据的数组（数据保存在layoutAttribut对象的各个属性中）

@end

@implementation WaterFlowLayout
- (NSMutableArray *)itemAttributes{
    if (!_itemAttributes) {
        self.itemAttributes = [NSMutableArray array];
    }
    return _itemAttributes;
}
- (void)prepareLayout{
    [super prepareLayout];
    [self configureItem];
}

- (void)configureItem{
    if (self.itemAttributes.count >0 ) {
        [self.itemAttributes removeAllObjects];
    }
    
    
    //计算item的列间距
    self.interitemSpacing = 0;
    
    //计算出内容视图的有效宽度
    CGFloat contentWidth = self.collectionView.frame.size.width - self.sectionInsets.left - self.sectionInsets.right - self.interitemSpacing;
    
    //通过collectionView获取item的数量
    self.numberOfItems = [self.collectionView numberOfItemsInSection:0];
    
    //根据item的数量来计算item的大小位置，以及所存在的列
    for (NSInteger i = 0; i < self.numberOfItems; i++) {
        //为每一个item创建对应indexPath
        self.indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CGFloat itemHeigth = 0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:waterFlowLayout:heightForItemAtIndexPath:)]) {
            //通过代理对象实现的协议方法来获取每一个item最终的高度
            itemHeigth = [self.delegate collectionView:self.collectionView waterFlowLayout:self heightForItemAtIndexPath:self.indexPath];
        }
        CGFloat delta_x = 0;
        CGFloat delta_y = 0;


        NSLog(@"self.numberOfItems == %ld",self.numberOfItems);
    if (self.numberOfItems == 2) {
        switch (self.indexPath.row) {
            case 0:
            {
                delta_x = self.sectionInsets.left;
                delta_y = self.sectionInsets.top;
                //保存在我们创建的专门用于保存布局的item的相关属性的layoutAttributes对象中
                UICollectionViewLayoutAttributes *layoutAttributes1 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:self.indexPath];
                //为layoutAttributes的frame属性赋值
                layoutAttributes1.frame = CGRectMake(delta_x, delta_y,contentWidth/2, itemHeigth);
                //将得到的layoutAttributes放入对应的数组中
                [self.itemAttributes addObject:layoutAttributes1];
            }

                break;
            case 1:
            {
                delta_x = self.sectionInsets.left + contentWidth/2;
                delta_y = self.sectionInsets.top;
                //保存在我们创建的专门用于保存布局的item的相关属性的layoutAttributes对象中
                UICollectionViewLayoutAttributes *layoutAttributes1 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:self.indexPath];
                //为layoutAttributes的frame属性赋值
                layoutAttributes1.frame = CGRectMake(delta_x, delta_y,contentWidth/2, itemHeigth);
                //将得到的layoutAttributes放入对应的数组中
                [self.itemAttributes addObject:layoutAttributes1];
            }
                
                break;
            default:
                break;
        }
    }else if (self.numberOfItems == 1){
        delta_x = self.sectionInsets.left;
        delta_y = self.sectionInsets.top;
        //保存在我们创建的专门用于保存布局的item的相关属性的layoutAttributes对象中
        UICollectionViewLayoutAttributes *layoutAttributes1 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:self.indexPath];
        //为layoutAttributes的frame属性赋值
        layoutAttributes1.frame = CGRectMake(delta_x, delta_y, contentWidth, itemHeigth);
        //将得到的layoutAttributes放入对应的数组中
        [self.itemAttributes addObject:layoutAttributes1];
        
        
    }else  if (self.numberOfItems == 3){
        switch (self.indexPath.row) {
            case 0:
            {
                delta_x = self.sectionInsets.left;
                delta_y = self.sectionInsets.top;
                //保存在我们创建的专门用于保存布局的item的相关属性的layoutAttributes对象中
                UICollectionViewLayoutAttributes *layoutAttributes1 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:self.indexPath];
                //为layoutAttributes的frame属性赋值
                layoutAttributes1.frame = CGRectMake(delta_x, delta_y, self.itemSize.width, itemHeigth);
                //将得到的layoutAttributes放入对应的数组中
                [self.itemAttributes addObject:layoutAttributes1];
            }
                
                break;
            case 1:
                
            {
                delta_x = self.sectionInsets.left + self.itemSize.width + self.interitemSpacing ;
                delta_y = self.sectionInsets.top;
                //保存在我们创建的专门用于保存布局的item的相关属性的layoutAttributes对象中
                UICollectionViewLayoutAttributes *layoutAttributes2 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:self.indexPath];
                //为layoutAttributes的frame属性赋值
                layoutAttributes2.frame = CGRectMake(delta_x, delta_y, [UIScreen mainScreen].bounds.size.width - self.itemSize.width, itemHeigth/2);
                //将得到的layoutAttributes放入对应的数组中
                [self.itemAttributes addObject:layoutAttributes2];
            }
                
                break;
            case 2:
            {
                delta_x = self.sectionInsets.left + self.itemSize.width + self.interitemSpacing;
                delta_y = itemHeigth/2 + self.sectionInsets.top ;
                //保存在我们创建的专门用于保存布局的item的相关属性的layoutAttributes对象中
                UICollectionViewLayoutAttributes *layoutAttributes3 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:self.indexPath];
                //为layoutAttributes的frame属性赋值
                layoutAttributes3.frame = CGRectMake(delta_x, delta_y, [UIScreen mainScreen].bounds.size.width - self.itemSize.width, itemHeigth/2);
                //将得到的layoutAttributes放入对应的数组中
                [self.itemAttributes addObject:layoutAttributes3];
            }
                break;
            default:
                break;
        }
        
    }
}
        

}

- (CGSize)collectionViewContentSize{

    CGSize sizes = CGSizeMake([UIScreen mainScreen].bounds.size.width, 202);
    return sizes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.itemAttributes objectAtIndex:indexPath.row];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
        return self.itemAttributes;
}
@end
