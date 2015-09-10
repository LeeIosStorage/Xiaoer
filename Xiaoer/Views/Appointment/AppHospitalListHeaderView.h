//
//  AppHospitalListHeaderView.h
//  Xiaoer
//
//  Created by 王鹏 on 15/9/7.
//
//

#import <UIKit/UIKit.h>

@interface AppHospitalListHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *righrBigBtn;
+ (instancetype)appHospitalListHeaderView;
- (void)appHospitalListHeaderViewTarget:(id)target action:(SEL)action;
@end
