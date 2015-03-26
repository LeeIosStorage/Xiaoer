//
//  ExpertListViewCell.h
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import <UIKit/UIKit.h>
#import "XEDoctorInfo.h"

@interface ExpertListViewCell : UITableViewCell

@property (strong, nonatomic) XEDoctorInfo *doctorInfo;
@property (assign, nonatomic) BOOL isNurser;

@property (strong, nonatomic) IBOutlet UIView *whiteBgView;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *doctorNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *doctorAgeLabel;
@property (strong, nonatomic) IBOutlet UILabel *doctorCollegeLabel;
@property (strong, nonatomic) IBOutlet UILabel *doctorIntroLabel;
@property (strong, nonatomic) IBOutlet UIButton *consultButton;
@property (strong, nonatomic) IBOutlet UIImageView *lineImageView;

+ (float)heightForDoctorInfo:(XEDoctorInfo *)doctorInfo;

@end
