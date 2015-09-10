//
//  AppOrderVerifyHeader.h
//  Xiaoer
//
//  Created by 王鹏 on 15/9/8.
//
//

#import <UIKit/UIKit.h>

@interface AppOrderVerifyHeader : UIView
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
+ (instancetype)appOrderVerifyHeader;
@end
