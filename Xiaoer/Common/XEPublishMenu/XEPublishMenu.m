//
//  XEPublishMenu.m
//  Xiaoer
//
//  Created by KID on 15/1/28.
//
//

#import "XEPublishMenu.h"
#import "UIColor+bit.h"
#import "XEAMBlurView.h"

#define XEPublishMenuTag 1999
#define XEPublishMenuImageHeight 70
#define XEPublishMenuTitleHeight 15
#define XEPublishMenuVerticalPadding 31
#define XEPublishMenuHorizontalMargin 24

#define XEPublishMenuItemAppearKey  @"XEPublishMenuItemAppearKey"
#define XEPublishMenuAnimationTime 0.35

@interface XEPublishMenuItemButton : UIButton

+ (id)XEPublishMenuButtonWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(XEPublishMenuSelectedBlock)block;

@property(nonatomic,copy)XEPublishMenuSelectedBlock selectedBlock;

@end

@implementation XEPublishMenuItemButton

+ (id)XEPublishMenuButtonWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(XEPublishMenuSelectedBlock)block {
    
    XEPublishMenuItemButton *button = [XEPublishMenuItemButton buttonWithType:UIButtonTypeCustom];
    [button setImage:icon forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:0];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.selectedBlock = block;
    
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, XEPublishMenuImageHeight, XEPublishMenuImageHeight);
    self.titleLabel.frame = CGRectMake(0, XEPublishMenuImageHeight + 11, XEPublishMenuImageHeight, XEPublishMenuTitleHeight);
}
@end

@interface XEPublishMenu ()

@property (nonatomic,strong) XEAMBlurView *blurView;

@end

@implementation XEPublishMenu {
    UIImageView *_backgroundView;
    NSMutableArray *_buttonArray;
//    UIButton *_closeButton;
    
    NSArray *_delayArray;
    NSArray *_delayDisappearArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        ges.delegate = self;
        [self addGestureRecognizer:ges];
        _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor clearColor];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_backgroundView];
        [self setBlurView:[XEAMBlurView new]];
        [[self blurView] setFrame:CGRectMake(0,64,SCREEN_WIDTH, SCREEN_HEIGHT)];
        [[self blurView] setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        
//        [[self blurView] setBlurTintColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.00]];
        [_backgroundView addSubview:[self blurView]];
//        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(268, 23, 44, 44)];
//        [_closeButton setImage:[UIImage imageNamed:@"public_menu_close_normal.png"] forState:UIControlStateNormal];
//        [_closeButton setImage:[UIImage imageNamed:@"public_menu_close_hover.png"] forState:UIControlStateHighlighted];
//        [_closeButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_closeButton];
        _buttonArray = [[NSMutableArray alloc] initWithCapacity:6];
        //运动时间自然一点
        _delayArray = @[@(0.02), @(0.09), @(0.18), @(0.06), @(0.13), @(0.23)];
        _delayDisappearArray = @[@(0.25), @(0.20), @(0.15), @(0.13), @(0.12), @(0.0)];
    }
    return self;
}

- (void)addMenuItemWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(XEPublishMenuSelectedBlock)block
{
    XEPublishMenuItemButton *button = [XEPublishMenuItemButton XEPublishMenuButtonWithTitle:title andIcon:icon andSelectedBlock:block];
    
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [_buttonArray addObject:button];
}

- (CGRect)frameForButtonAtIndex:(NSUInteger)index
{
    NSUInteger columnCount = 2;
    NSUInteger columnIndex =  index % columnCount;
    NSUInteger rowIndex = index / columnCount;
    
    CGFloat offsetY = self.bounds.size.height;
    CGFloat verticalPadding = (self.bounds.size.width - XEPublishMenuHorizontalMargin - XEPublishMenuImageHeight * 3) / 2.0;
    CGFloat offsetX = XEPublishMenuHorizontalMargin + (SCREEN_WIDTH==320?50:60);
    offsetX += (XEPublishMenuImageHeight + verticalPadding) * columnIndex;
    offsetY += (XEPublishMenuImageHeight + XEPublishMenuTitleHeight + XEPublishMenuVerticalPadding) * rowIndex;
    
    return CGRectMake(offsetX, offsetY, XEPublishMenuImageHeight, (XEPublishMenuImageHeight + XEPublishMenuTitleHeight));
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    for (NSUInteger i = 0; i < _buttonArray.count; i++) {
//        LSPublishMenuItemButton *button = _buttonArray[i];
//        button.tag = i;
//        button.frame = [self frameForButtonAtIndex:i];
//    }
//}

- (void)setupMenuItems{
    for (NSUInteger i = 0; i < _buttonArray.count; i++) {
        XEPublishMenuItemButton *button = _buttonArray[i];
        button.tag = i;
        button.frame = [self frameForButtonAtIndex:i];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer.view isKindOfClass:[XEPublishMenuItemButton class]]) {
        return NO;
    }
    
    CGPoint location = [gestureRecognizer locationInView:self];
    for (UIView* subview in _buttonArray) {
        if (CGRectContainsPoint(subview.frame, location)) {
            return NO;
        }
    }
    return YES;
}

- (void)dismiss:(id)sender
{
    //做一次旋转
    //[self rotateAnimation:NO];
    [self menuItemDisappear];
}

-(void)zoomWithButton:(XEPublishMenuItemButton *)btn andZoom:(BOOL *)bZoom
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    if (bZoom) {
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)]];
    }else{
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    }
    animation.values = values;
    [btn.layer addAnimation:animation forKey:nil];
}

//-(void)rotateAnimation:(BOOL)bShow{
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * (bShow?0.5:-0.5)];
//    rotationAnimation.duration = bShow?XEPublishMenuAnimationTime:XEPublishMenuAnimationTime+0.2;
//    rotationAnimation.cumulative = YES;
//    [_closeButton.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//}

- (void)buttonTapped:(XEPublishMenuItemButton*)btn {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        double delayInSeconds = XEPublishMenuAnimationTime;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self removeFromSuperview];
            btn.selectedBlock();
        });
        dispatch_async(dispatch_get_main_queue(),^{
            //做一次放大
            for (XEPublishMenuItemButton *button in _buttonArray) {
                [self zoomWithButton:button andZoom:(button.tag==btn.tag?YES:NO)];
            }
        });
    });
}

- (void)menuItemAppear{
    for (int i = 0; i < _buttonArray.count; i++) {
        double delayInSeconds = [_delayArray[i] doubleValue];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            XEPublishMenuItemButton *item = (XEPublishMenuItemButton *)_buttonArray[i];
            [self riseMenuItem:item];
        });
    }
}

- (void)menuItemDisappear{
    for (int i = 0; i < _buttonArray.count; i++) {
        double delayInSeconds = [_delayDisappearArray[i] doubleValue];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            XEPublishMenuItemButton *item = (XEPublishMenuItemButton *)_buttonArray[i];
            [self dropMenuItem:item];
        });
    }
    
    [UIView animateWithDuration:0.2 delay:XEPublishMenuAnimationTime options:UIViewAnimationOptionCurveEaseIn animations:^{
        _backgroundView.alpha = 0.7;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//上升动画
- (void)riseMenuItem:(XEPublishMenuItemButton *)item
{
    CGPoint fromPosition = item.center;
    CGPoint toPosition = CGPointMake(fromPosition.x, fromPosition.y - CGRectGetHeight(self.bounds) / 2 - 120);
    CGPoint finalPosition = CGPointMake(toPosition.x, toPosition.y + 20);
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = @[[NSValue valueWithCGPoint:fromPosition], [NSValue valueWithCGPoint:toPosition], [NSValue valueWithCGPoint:finalPosition]];
    positionAnimation.keyTimes = @[@(0), @(0.6), @(1)];
    positionAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithControlPoints:0.10 :0.87 :0.68 :1.0], [CAMediaTimingFunction functionWithControlPoints:0.66 :0.37 :0.70 :0.95]];
    positionAnimation.duration = XEPublishMenuAnimationTime;
    [item.layer addAnimation:positionAnimation forKey:XEPublishMenuItemAppearKey];
    item.layer.position = finalPosition;
}

//下降动画
- (void)dropMenuItem:(XEPublishMenuItemButton *)item
{
    CGPoint fromPosition = item.center;
    CGPoint finalPosition = CGPointMake(fromPosition.x, fromPosition.y + CGRectGetHeight(self.bounds) / 2 + 500);
    
    CABasicAnimation *dropAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    dropAnimation.duration = 0.3;
    dropAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
    dropAnimation.toValue = [NSValue valueWithCGPoint:finalPosition];
    dropAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [item.layer addAnimation:dropAnimation forKey:XEPublishMenuItemAppearKey];
    
    item.layer.position = finalPosition;
    if (item.selectedBlock) {
        item.selectedBlock = nil;
    }
}

- (void)show{
    UIViewController *appRootViewController;
    UIWindow *window;
    
    window = [[[UIApplication sharedApplication] delegate] window];
    appRootViewController = window.rootViewController;
    
    UIViewController *topViewController = appRootViewController;
    while (topViewController.presentedViewController != nil)
    {
        topViewController = topViewController.presentedViewController;
    }
    
    if ([topViewController.view viewWithTag:XEPublishMenuTag]) {
        [[topViewController.view viewWithTag:XEPublishMenuTag] removeFromSuperview];
    }
    
    self.frame = [UIScreen mainScreen].bounds;
    [topViewController.view addSubview:self];
    
    [self setupMenuItems];
    //[self rotateAnimation:YES];
    [self menuItemAppear];
}

@end
