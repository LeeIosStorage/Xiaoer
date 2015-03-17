//
//  TicketListViewCell.h
//  Xiaoer
//
//  Created by KID on 15/3/17.
//
//

#import <UIKit/UIKit.h>
#import "XEActivityInfo.h"

@interface TicketListViewCell : UITableViewCell

@property (strong, nonatomic) XEActivityInfo *activityInfo;

@property (strong, nonatomic) IBOutlet UIImageView *infoImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *rushNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *rushButton;
@property (strong, nonatomic) IBOutlet UIImageView *stateImageView;

@end
