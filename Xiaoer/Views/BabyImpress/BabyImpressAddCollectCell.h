//
//  BabyImpressAddCollectCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/27.
//
//

#import <UIKit/UIKit.h>

@protocol babyImpressAddbtnTouchedDelegate <NSObject>

- (void)babyImpressAddbtnTouched;

@end


@interface BabyImpressAddCollectCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic,assign)id<babyImpressAddbtnTouchedDelegate>delegate;
@end
