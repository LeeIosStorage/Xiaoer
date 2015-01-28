//
//  XEPublishMenu.h
//  Xiaoer
//
//  Created by KID on 15/1/28.
//
//

#import <UIKit/UIKit.h>

typedef void (^XEPublishMenuSelectedBlock)(void);

@interface XEPublishMenu : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, strong)UIImageView *backgroundImgView;

- (void)addMenuItemWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(XEPublishMenuSelectedBlock)block;

- (void)show;

@end
