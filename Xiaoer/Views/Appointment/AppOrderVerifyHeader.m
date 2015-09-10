//
//  AppOrderVerifyHeader.m
//  Xiaoer
//
//  Created by 王鹏 on 15/9/8.
//
//

#import "AppOrderVerifyHeader.h"

@implementation AppOrderVerifyHeader


+ (instancetype)appOrderVerifyHeader{
    return [[[NSBundle mainBundle]loadNibNamed:@"AppOrderVerifyHeader" owner:nil options:nil] lastObject];
}
- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
}
@end
