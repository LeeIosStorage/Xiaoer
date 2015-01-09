//
//  XEBaseSuperViewController.m
//  Xiaoer
//
//  Created by KID on 14/12/31.
//
//

#import "XEBaseSuperViewController.h"
#import "XETitleNavBarView.h"

@interface XEBaseSuperViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton  *titleNavBarLeftButton;
@property (nonatomic, strong) UIView  *titleNavBarLeftCustomView;

@end

@implementation XEBaseSuperViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];//UIColorRGB(240, 240, 240)
    self.view.clipsToBounds = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    BOOL isAddTitleNavBar = NO;
    if (!_titleNavBar) {
        isAddTitleNavBar = YES;
        [self initTitleNavBar];
        
        [self.view insertSubview:_titleNavBar atIndex:0];
    }
    //不让系统给边缘view添加偏移
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    //ios7.0以上的系统都要改变下位置
    BOOL isNeedOffset = [XECommonUtils isUpperSDK];
    for (UIView *subview in [self.view subviews]) {
        if ([self.titleNavBar isEqual:subview]) {
            [self.view bringSubviewToFront:self.titleNavBar];
            if (isNeedOffset) {
                [XEUIUtils updateFrameWithView:subview superView:self.view isAddHeight:YES];
            }
        }else{
            BOOL isChange = YES;
            if (isNeedOffset) {
                isChange = [XEUIUtils updateFrameWithView:subview superView:self.view isAddHeight:NO];
            }else{
                //7.0以前的只要判断size是否跟父view 一样
                isChange = !(subview.frame.size.height >= self.view.frame.size.height || (isAddTitleNavBar && subview.frame.origin.y < self.titleNavBar.frame.size.height));
            }
            
            //如果view是tableview或其子view的时候设置contentInset
            if (!isChange && [subview isKindOfClass:[UIScrollView class]]){
                [self setContentInsetForScrollView:((UIScrollView *)subview)];
            }
        }
    }
    
    //normal title view
    if ([_titleNavBar isMemberOfClass:[XETitleNavBarView class]]) {
        [self initNormalTitleNavBarSubviews];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL) isHasNormalTitle
{
    return YES;
}

-(void) initTitleNavBar
{
    if (![self isHasNormalTitle]) {
        return;
    }
    _titleNavBar = [[XETitleNavBarView alloc] init:self];
    
    if ([_titleNavBar isMemberOfClass:[XETitleNavBarView class]]) {
        _titleNavBarLeftButton = ((XETitleNavBarView *) _titleNavBar).toolBarLeftButton;
        _titleNavBarRightBtn = ((XETitleNavBarView *) _titleNavBar).toolBarRightButton;
    }
}

//title
-(void) setTitle:(NSString *) title
{
    if (!_titleLabel) {
        if ([_titleNavBar isMemberOfClass:[XETitleNavBarView class]]) {
            _titleLabel = [((XETitleNavBarView *) _titleNavBar) setTitle:title];
        }else{
            super.title = title;
        }
    }else{
        [_titleLabel setText:title];
    }
}
-(void) setTitle:(NSString *) title font:(UIFont *) font
{
    if (!_titleLabel) {
        if ([_titleNavBar isMemberOfClass:[XETitleNavBarView class]]) {
            _titleLabel = [((XETitleNavBarView *) _titleNavBar) setTitle:title font:font];
        }
    }else{
        [_titleLabel setText:title];
        _titleLabel.font = font;
    }
    
}

-(void) initNormalTitleNavBarSubviews{
    
}

-(void) setTilteLeftViewHide:(BOOL)isHide{
    
    if (_titleNavBarLeftButton) {
        _titleNavBarLeftButton.hidden = isHide;
    }
    
    if (_titleNavBarLeftCustomView) {
        _titleNavBarLeftCustomView.hidden = isHide;
    }
}

//返回按钮, 前面默认是的back

-(void) setLeftButtonTitle:(NSString *) buttonTitle
{
    if (![_titleNavBar isMemberOfClass:[XETitleNavBarView class]]) {
        return;
    }
    
    if (_titleNavBarLeftButton) {
        [_titleNavBarLeftButton setTitle:buttonTitle forState:UIControlStateNormal];
    }
}

-(void) setLeftButtonWithSelector:(SEL) selector
{
    if (![_titleNavBar isMemberOfClass:[XETitleNavBarView class]]) {
        return;
    }
    if (_titleNavBarLeftButton) {
        _titleNavBarLeftButton.hidden = NO;
        [_titleNavBarLeftButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
}

//right button
-(void) setRightButtonWithTitle:(NSString *) buttonTitle{
    if (![_titleNavBar isMemberOfClass:[XETitleNavBarView class]]) {
        return;
    }
    
    if (_titleNavBarRightBtn) {
        _titleNavBarRightBtn.hidden = NO;
        [_titleNavBarRightBtn setTitle:buttonTitle forState:UIControlStateNormal];
    }
}
-(void) setRightButtonWithTitle:(NSString *) buttonTitle selector:(SEL) selector
{
    if (![_titleNavBar isMemberOfClass:[XETitleNavBarView class]]) {
        return;
    }
    
    if (_titleNavBarRightBtn) {
        _titleNavBarRightBtn.hidden = NO;
        [_titleNavBarRightBtn setTitle:buttonTitle forState:UIControlStateNormal];
        [_titleNavBarRightBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - ScrollViewContentInset
-(void) setContentInsetForScrollView:(UIScrollView *) scrollview
{
    if (![scrollview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    CGFloat topInset = 0;
    if (!self.titleNavBar) {
        topInset = XE_Default_TitleNavBar_Height;
        if ([XECommonUtils isUpperSDK]) {
            topInset += STAUTTAR_DEFAULT_HEIGHT;
        }
    }else{
        topInset = self.titleNavBar.frame.size.height;
    }
    
    UIEdgeInsets inset = UIEdgeInsetsMake(topInset, 0, 0, 0);
    
    [self setContentInsetForScrollView:scrollview inset:inset];
}

-(void) setContentInsetForScrollView:(UIScrollView *) scrollview inset:(UIEdgeInsets) inset
{
    if (![scrollview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    
    [scrollview setContentInset:inset];
    [scrollview setScrollIndicatorInsets:inset];
}

@end
