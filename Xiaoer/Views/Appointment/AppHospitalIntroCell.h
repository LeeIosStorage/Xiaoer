//
//  AppHospitalIntroCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/9/7.
//
//

#import <UIKit/UIKit.h>
#import "XEAppHospital.h"
#import "XEAppSubHospital.h"
@interface AppHospitalIntroCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UILabel *backLable;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBigBtn;
@property (nonatomic,strong)UILabel *introLab;

@property (weak, nonatomic) IBOutlet UIImageView *setLine;

- (void)configureIntroCellWith:(XEAppHospital *)info
                hideStr:(NSString *)hideStr;
@property (nonatomic,strong)XEAppHospital *info;
+ (CGFloat)cellHeightWith:(NSString *)string;
- (void)configureIntroCellWithSub:(XEAppSubHospital *)info;
- (void)appAppHospitalIntroCellTarget:(id)target action:(SEL)action;

@end
