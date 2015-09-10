//
//  AppHospitalListHeaderView.m
//  Xiaoer
//
//  Created by 王鹏 on 15/9/7.
//
//

#import "AppHospitalListHeaderView.h"

@implementation AppHospitalListHeaderView



+ (instancetype)appHospitalListHeaderView{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"AppHospitalListHeaderView" owner:nil options:nil] lastObject];
}
- (void)appHospitalListHeaderViewTarget:(id)target action:(SEL)action{
    [self.righrBigBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    [self.rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
}
@end
