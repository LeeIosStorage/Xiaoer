//
//  XEChatHeaderView.h
//  Xiaoer
//
//  Created by 王鹏 on 15/8/29.
//
//

#import <UIKit/UIKit.h>

@interface XEChatHeaderView : UIView
+ (instancetype)chatHeaderView;


/**
     发话题
 *  设置点击的监听器
 *
 *  @param target 监听器
 *  @param action 监听方法
 */
- (void)publishAddTarget:(id)target action:(SEL)action;


/**
    问专家
 *  设置点击的监听器
 *
 *  @param target 监听器
 *  @param action 监听方法
 */
- (void)askExpectAddTarget:(id)target action:(SEL)action;
@end
