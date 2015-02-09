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
#import "PullToRefreshView.h"

@interface XEBaseSuperViewController : UIViewController <PullToRefreshViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *titleNavBar;
@property (nonatomic, strong) IBOutlet UIButton *titleNavBarRightBtn;
@property (nonatomic, strong) IBOutlet UIButton *titleNavBarRightBtn2;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

/*! @brief Pull View
 *
 */
@property (nonatomic, strong) PullToRefreshView *pullRefreshView;
@property (nonatomic, strong) PullToRefreshView *pullRefreshView2;

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

/*! @brief SegmentedControl控件
 *
 */
-(void) setSegmentedControlWithSelector:(SEL) selector items:(NSArray *)items;


//返回按钮, 前面默认是back
-(void) setLeftButtonTitle:(NSString *) buttonTitle;
-(void) setLeftButtonWithSelector:(SEL) selector;
-(void) setLeftButtonWithTitle:(NSString *) buttonTitle selector:(SEL) selector;

-(void) setLeftButtonWithImageName:(NSString *) butonImageName;
-(void) setLeftButtonWithImageName:(NSString *) butonImageName selector:(SEL) selector;
-(void) setLeft2ButtonWithImageName:(NSString *) butonImageName selector:(SEL) selector;

//right button
-(void) setRightButtonWithTitle:(NSString *) buttonTitle;
-(void) setRightButtonWithTitle:(NSString *) buttonTitle selector:(SEL) selector;
-(void) setRightButtonWithImageName:(NSString *) butonImageName selector:(SEL) selector;

-(void) setRight2ButtonWithTitle:(NSString *) buttonTitle selector:(SEL) selector;
-(void) setRight2ButtonWithImageName:(NSString *) butonImageName selector:(SEL) selector;

/*! @brief 设置tableview的contentInset
 *
 */
-(void) setContentInsetForScrollView:(UIScrollView *) scrollview;
-(void) setContentInsetForScrollView:(UIScrollView *) scrollview inset:(UIEdgeInsets) inset;

@end
