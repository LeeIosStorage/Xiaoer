//
//  MainTabScrollCollectCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/4.
//
//

#import <UIKit/UIKit.h>

@interface MainTabScrollCollectCell : UICollectionViewCell


@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *titleLable;
@property (nonatomic,strong)UILabel *newPrices;
@property (nonatomic,strong)UILabel *oldPrices;
@property (nonatomic,strong)UILabel *selled;


- (void)configure:(NSString *)color;
@end
