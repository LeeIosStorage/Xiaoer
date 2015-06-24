//
//  ShopViewCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/24.
//
//

#import <UIKit/UIKit.h>

@protocol TouchCellDelegate <NSObject>

//- (void)touchCellWithSection:(NSInteger)section row:(NSInteger)row;

- (void)touchCellWithCellTag:(NSInteger)cellTag btnTag:(NSInteger)btnTag;
@end



@interface ShopViewCell : UITableViewCell
- (void)configureCellWith:(NSIndexPath *)indexPath andNumberOfItemsInCell:(NSInteger)num;

@property (weak, nonatomic) IBOutlet UIButton *btnA;
@property (weak, nonatomic) IBOutlet UIButton *btnB;
@property (weak, nonatomic) IBOutlet UIButton *btnC;
@property (nonatomic,assign)id<TouchCellDelegate>delegate;

@end
