//
//  AppHospitalListCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/9/7.
//
//

#import <UIKit/UIKit.h>
#import "XEAppSubHospital.h"

@protocol appHospitalListCellDelegate <NSObject>

- (void)getInBtnTouchedWith:(XEAppSubHospital *)info;

@end

@interface AppHospitalListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *introLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;

@property (weak, nonatomic) IBOutlet UIButton *getIn;
@property (weak, nonatomic) IBOutlet UILabel *backLab;
@property (nonatomic,strong)XEAppSubHospital *info;
@property (nonatomic,assign)id<appHospitalListCellDelegate> delegate;
- (void)configureCellWith:(XEAppSubHospital *)info;

@end
