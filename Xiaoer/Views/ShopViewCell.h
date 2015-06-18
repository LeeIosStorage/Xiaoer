//
//  ShopViewCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/18.
//
//

#import <UIKit/UIKit.h>
@protocol TableViewCellDelegate <NSObject>
- (void)touchCellWithSection:(NSInteger )section row:(NSInteger )row;

@end

@interface ShopViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
- (void)configureCellWith:(NSIndexPath *)indexPath;
@property (nonatomic,assign)id<TableViewCellDelegate> delegate;
@property (nonatomic,assign)CGFloat itemHeight;
@end
