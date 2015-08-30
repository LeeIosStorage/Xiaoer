//
//  BabyImpressPayWayOtherCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/25.
//
//

#import <UIKit/UIKit.h>


@protocol changeIndexpathNumDelagete <NSObject>
- (void)ifNumIsZeroWith:(BOOL )ifNumZero;


@end


@interface BabyImpressPayWayOtherCell : UITableViewCell
@property (nonatomic,assign)id<changeIndexpathNumDelagete>delegate;
@end
