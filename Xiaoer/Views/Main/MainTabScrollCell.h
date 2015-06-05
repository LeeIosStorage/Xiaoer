//
//  MainTabScrollCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/4.
//
//

#import <UIKit/UIKit.h>

@protocol selestDelegate <NSObject>
- (void)pushToShopWith:(NSString *)string;
@end
@interface MainTabScrollCell : UITableViewCell<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *tabScrollCollectionView;
- (void)configureCollectionViewWith:(NSString *)string;
@property (nonatomic,assign)id <selestDelegate> delegate;
@property (nonatomic,strong)NSString *string;


@end
