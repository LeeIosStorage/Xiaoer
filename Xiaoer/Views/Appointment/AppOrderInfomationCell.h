//
//  AppOrderInfomationCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/9/8.
//
//

#import <UIKit/UIKit.h>


@protocol appOrderInfomationDelegate <NSObject>

- (void)passLeftLabTextWith:(NSString *)leftText
              textFieldText:(NSString *)textFieldText;

@end

@interface AppOrderInfomationCell : UITableViewCell
- (void)configureCellWith:(NSIndexPath *)indexpath;
- (void)configureVerifyCellWith:(NSIndexPath *)indexpath
                            dic:(NSDictionary *)dic;

@property (nonatomic,assign)id<appOrderInfomationDelegate> delegate;
@end
