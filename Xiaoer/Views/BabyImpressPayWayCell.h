//
//  BabyImpressPayWayCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/25.
//
//

#import <UIKit/UIKit.h>

@protocol payWayCellDelageta <NSObject>

- (void)payWayCellBtnTouchedWithTag:(NSInteger )index
                           stateStr:(NSString *)string;

@end


@interface BabyImpressPayWayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (nonatomic,assign)id<payWayCellDelageta>delegate;

@end
