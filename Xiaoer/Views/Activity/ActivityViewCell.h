//
//  ActivityViewCell.h
//  Xiaoer
//
//  Created by KID on 15/1/16.
//
//

#import <UIKit/UIKit.h>
#import "XEActivityInfo.h"

@interface ActivityViewCell : UITableViewCell

@property (nonatomic, strong) XEActivityInfo *activityInfo;
@property (strong, nonatomic) IBOutlet UIImageView *activityImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateAndAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalnumLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@end
