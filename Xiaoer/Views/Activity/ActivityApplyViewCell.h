//
//  ActivityApplyViewCell.h
//  Xiaoer
//
//  Created by KID on 15/2/3.
//
//

#import <UIKit/UIKit.h>
#import "XEActivityInfo.h"

@interface ActivityApplyViewCell : UITableViewCell

@property (nonatomic, strong) XEActivityInfo *activityInfo;
@property (strong, nonatomic) IBOutlet UIImageView *activityImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *codeLabel;
@property (strong, nonatomic) IBOutlet UIButton *stateButton;

@end
