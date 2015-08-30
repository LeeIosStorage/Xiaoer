//
//  BabyImpressCollectCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/25.
//
//

#import <UIKit/UIKit.h>

#import "XEBabyImpressMonthListInfo.h"


@protocol babyImpressShowBtnTouched <NSObject>

-(void)babyImpressShowBtnTouchedWith:(NSInteger)index;

@end


@interface BabyImpressCollectCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *mainBtn;
- (void)configureCellWith:(XEBabyImpressMonthListInfo *)info;
- (void)configureCellWithImage:(UIImage *)image;
@property (nonatomic,assign)id<babyImpressShowBtnTouched>delegate;
@end
