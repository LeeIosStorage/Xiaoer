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
-(void) setContentInsetForScrollView:(UIScrollView *) scrollview;
-(void) setContentInsetForScrollView:(UIScrollView *) scrollview inset:(UIEdgeInsets) inset;

@end
