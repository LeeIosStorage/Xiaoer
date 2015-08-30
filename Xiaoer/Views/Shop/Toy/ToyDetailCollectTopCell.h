//
//  ToyDetailCollectTopCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/9.
//
//

#import <UIKit/UIKit.h>
#import "XEShopDetailInfo.h"

@protocol topCancleBtnTouched <NSObject>

- (void)TopCancleBtnTouched;

@end

@interface ToyDetailCollectTopCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UILabel *choosedLab;
@property (nonatomic,strong)id<topCancleBtnTouched>delegate;
- (void)configureCellWithmodel:(XEShopDetailInfo *)info
                      chooseStr:(NSMutableString *)chooserStr;
@end
