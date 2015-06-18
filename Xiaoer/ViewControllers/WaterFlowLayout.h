//
//  WaterFlowLayout.h
//  瀑布流
//
//  Created by 王鹏 on 15/6/15.
//  Copyright (c) 2015年 王鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WaterFlowLayout;

@protocol UICollectionViewDelegateWaterFlowLayout <UICollectionViewDelegate>

- (CGFloat)collectionView:(UICollectionView *)collectionView
          waterFlowLayout:(WaterFlowLayout *)layout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface WaterFlowLayout : UICollectionViewLayout
@property (nonatomic, assign) id<UICollectionViewDelegateWaterFlowLayout> delegate;

@property (nonatomic, assign) NSUInteger numberOfColumns;//瀑布流的列数
@property (nonatomic, assign) CGSize itemSize;//每一个item的大小
@property (nonatomic, assign) UIEdgeInsets sectionInsets;//分区的上下左右四个边距
@property (nonatomic,strong)NSIndexPath *indexPath;
@end
