//
//  XEChatHeaderView.m
//  Xiaoer
//
//  Created by 王鹏 on 15/8/29.
//
//

#import "XEChatHeaderView.h"

@interface XEChatHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *publish;

@property (weak, nonatomic) IBOutlet UIButton *ask;

@end

@implementation XEChatHeaderView

+ (instancetype)chatHeaderView{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"XEChatHeaderView" owner:nil options:nil] lastObject];
}
- (void)publishAddTarget:(id)target action:(SEL)action{
    [self.publish addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
- (void)askExpectAddTarget:(id)target action:(SEL)action{
    [self.ask addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
@end
