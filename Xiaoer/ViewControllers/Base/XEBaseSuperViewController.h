//
//  XEBaseSuperViewController.h
//  Xiaoer
//
//  Created by KID on 14/12/31.
//
//

#import <UIKit/UIKit.h>
#import "XECommonUtils.h"
#import "XEUIUtils.h"

@interface XEBaseSuperViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIView *titleNavBar;
@property (nonatomic, strong) IBOutlet UIButton *titleNavBarRightBtn;

//title
-(void) setTitle:(NSString *) title;
-(void) setTitle:(NSString *) title font:(UIFont *) font;

-(BOOL) isHasNormalTitle;
/*! @brief 子类中重写些函数去初始化基本的titleNavBar
 *
 */
-(void) initNormalTitleNavBarSubviews;

/*! @brief 隐藏返回按钮
 *
 */
-(void) setTilteLeftViewHide:(BOOL)isHide;

/*! @brief 设置tableview的contentInset
 *
 */

//返回按钮, 前面默认是back
-(void) setLeftButtonTitle:(NSString *) buttonTitle;
-(void) setLeftButtonWithSelector:(SEL) selector;

//right button
-(void) setRightButtonWithTitle:(NSString *) buttonTitle;
-(void) setRightButtonWithTitle:(NSString *) buttonTitle selector:(SEL) selector;

-(void) setContentInsetForScrollView:(UIScrollView *) scrollview;
-(void) setContentInsetForScrollView:(UIScrollView *) scrollview inset:(UIEdgeInsets) inset;

@end
