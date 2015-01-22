//
//  XECategoryView.h
//  Xiaoer
//
//  Created by KID on 15/1/16.
//
//

#import "XERecipesInfo.h"
#import "PullToRefreshView.h"

@protocol XECategoryDelegate<NSObject>

@optional
- (void)didTouchCellWithRecipesInfo:(XERecipesInfo *)recipesInfo;
- (void)didRefreshRecipesInfos;
- (void)didChangeLayoutWithOffset:(CGFloat)offset;

@end

@interface XECategoryView : UIView

@property (strong, nonatomic) IBOutlet UIView *maskView;

@property (strong, nonatomic) NSMutableArray *dateArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) id <XECategoryDelegate> delegate;

@property (assign, nonatomic) BOOL bRefresh;

@property (strong, nonatomic) PullToRefreshView *pullRefreshView;

- (void)refreshAdsScrollView;

@end
