//
//  ShopCarCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/22.
//
//

#import <UIKit/UIKit.h>

@protocol changeNumShopDelegate <NSObject>

- (void)returnIndexOfShop:(NSInteger )index
            andNumberText:(NSString *)numText;

@end


@interface ShopCarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *formerPrice;
@property (weak, nonatomic) IBOutlet UILabel *afterPrice;

@property (weak, nonatomic) IBOutlet UILabel *numShopLab;
- (void)configureCellWith:(NSIndexPath *)indexPth;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic,assign)id<changeNumShopDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *setLineLab;

@end
