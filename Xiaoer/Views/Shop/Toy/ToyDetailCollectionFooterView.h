//
//  ToyDetailCollectionFooterView.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/9.
//
//

#import <UIKit/UIKit.h>

@interface ToyDetailCollectionFooterView : UICollectionReusableView
@property (nonatomic,strong)UIImageView  *backImageView;
@property (nonatomic,strong)UILabel *desLab;
@property (nonatomic,strong)UIButton *addBtn;
@property (nonatomic,strong)UIButton *deleBtn;
@property (nonatomic,strong)UIImageView *line;
- (void)configureFooterView;
@end
