//
//  NewIntroView.m
//  Xiaoer
//
//  Created by KID on 15/1/6.
//
//

#import "NewIntroView.h"

@implementation NewIntroView
{
    NSMutableArray *_pageViews;
}

- (id)initWithFrame:(CGRect)frame andPages:(NSArray *)pagesArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _pageViews = [NSMutableArray array];
        _introPages = pagesArray;
        [self buildBackgroundImage];
        [self buildScrollView];
    }
    return self;
}

- (void)buildBackgroundImage {
    self.bgImageView = [[UIImageView alloc] initWithFrame:self.frame];
    self.bgImageView.backgroundColor = [UIColor clearColor];
    self.bgImageView.contentMode = UIViewContentModeScaleToFill;
    self.bgImageView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.bgImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.bgImageView];
}

- (void)buildScrollView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    for (int idx = 0; idx < _introPages.count; idx++) {
        [_pageViews addObject:[self viewForPage:_introPages[idx] atXIndex:idx]];
        [self.scrollView addSubview:_pageViews[idx]];
    }
    
    self.scrollView.contentSize = CGSizeMake(_introPages.count*320, self.scrollView.frame.size.height);
    [self addSubview:self.scrollView];
}

- (UIView *)viewForPage:(UIImage *)pageImage atXIndex:(int)index {
    
    UIView *pageView = [[UIView alloc] initWithFrame:
                        CGRectMake(index*320, 0, self.scrollView.frame.size.width,self.scrollView.frame.size.height)];
    
    CGRect frame = self.scrollView.frame;
    CGFloat x = 0;
    CGRect beginFrame = frame;
    beginFrame.origin.x = x;
    beginFrame = (index == 0 ? self.frame : beginFrame);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:beginFrame];
    imageView.image = pageImage;
    [pageView addSubview:imageView];
    
    if (index == _introPages.count - 1) {
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.frame = CGRectMake(0, 0, 100, 40);
        [loginBtn setTitle:@"登陆" forState:0];
//        CGFloat originalH = self.frame.size.height > 500 ? 508 : 420;
        loginBtn.center = self.center;
        [loginBtn setBackgroundImage:[UIImage imageNamed:@"welcom_button"] forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        [pageView addSubview:loginBtn];
        
    }
    
    return pageView;
}

- (void)loginAction:(id)sender
{
    if (self.loginIntroCallBack) {
        self.loginIntroCallBack();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
