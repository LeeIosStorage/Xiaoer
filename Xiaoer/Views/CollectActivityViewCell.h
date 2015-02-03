//
//  CollectActivityViewCell.h
//  Xiaoer
//
//  Created by KID on 15/2/3.
//
//

#import <UIKit/UIKit.h>
#import "XEDoctorInfo.h"

@interface CollectActivityViewCell : UITableViewCell

@property (strong, nonatomic) XEDoctorInfo *doctorInfo;

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *doctorNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *doctorCollegeLabel;

@end
