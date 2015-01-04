//
//  XEUIUtils.h
//  Xiaoer
//
//  Created by KID on 14/12/31.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XEUIKitMacro.h"

@interface XEUIUtils : NSObject

#pragma mark -- adapter ios7
/*! @brief 改变view的大小, 主要是适配ios7的stautar 如果是addHeight的就添加高度，把y为-statusBar.frame.size.height,不为add时就往下移
 *
 */
+(BOOL)updateFrameWithView:(UIView *)view superView:(UIView *)superView isAddHeight:(BOOL)isAddHeight;

/*! @brief 改变view的大小, 主要是适配ios7的stautar 如果是addHeight的就添加高度，把y为-height,不为add时就往下移
 *
 */
+(BOOL)updateFrameWithView:(UIView *)view superView:(UIView *)superView isAddHeight:(BOOL)isAddHeight delHeight:(CGFloat)height;

@end