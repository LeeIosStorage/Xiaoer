//
//  ToyDetailCollectHeaderView.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/9.
//
//

#import <UIKit/UIKit.h>

@interface ToyDetailCollectHeaderView : UICollectionReusableView
@property (nonatomic,strong)UILabel *titleLab;
- (void)configureHeaderViewWith:(NSString *)str;
@end
