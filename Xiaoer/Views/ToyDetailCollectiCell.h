//
//  ToyDetailCollectiCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/9.
//
//

#import <UIKit/UIKit.h>

@protocol btnTouchDelegate <NSObject>

- (void)touchBtnwith:(NSString *)btnTitle
              btnTag:(NSInteger )btnTag;

@end


@interface ToyDetailCollectiCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic,assign)id<btnTouchDelegate>delegate;


- (void)configureCellWithStr:(NSString *)str
                   indexPath:(NSIndexPath *)indexPath
    ifChangeBackColorToSkc:(BOOL)change;
@end
