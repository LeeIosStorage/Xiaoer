//
//  RecipesViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import "RecipesViewController.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "XECategoryView.h"
#import "XERecipesInfo.h"
#import "UIColor+bit.h"

#define Selected_Color [UIColor colorWithRed:(1.0 * 58 / 255) green:(1.0 * 161 / 255) blue:(1.0 * 248 / 255) alpha:1]
#define UnSelected_Color [UIColor colorWithRed:(1.0 * 172 / 255) green:(1.0 * 177 / 255) blue:(1.0 * 183 / 255) alpha:1]
#define XEDisplayMotionHeight 47
#define XERefreshInterval     60 

#define kCategoryRefreshTime @"categoryRefreshTime"

static const CGFloat kNavbarButtonScaleFactor = 1.33333333f;

@interface RecipesViewController ()<UIScrollViewDelegate,XECategoryDelegate>
{
    CGFloat scrollBarWidth;
    CGFloat scrollIndex;
    BOOL bOverspeed;
}

@property (strong, nonatomic) IBOutlet UIView *categoryView;
@property (strong, nonatomic) IBOutlet UIScrollView *categoryScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *contentView;

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *categoryViews;

@property (nonatomic,assign) NSUInteger selectedIndex;
@property (nonatomic,strong) UIColor *selectedLabelColor;
@property (nonatomic,strong) UIColor *unselectedLabelColor;

@property (nonatomic, strong) NSMutableArray *hotGroups;
@property (nonatomic, strong) NSMutableDictionary *hotUnionDic;

@property (assign, nonatomic) BOOL bScroll;

@end

@implementation RecipesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    _unselectedLabelColor = UnSelected_Color;
    _selectedLabelColor = Selected_Color;
    _selectedIndex = 1;
    
    _hotUnionDic = [[NSMutableDictionary alloc] init];
    _hotGroups = [[NSMutableArray alloc] init];
    
    [self getCategoryInfo];
}

-(void)initNormalTitleNavBarSubviews{
    if (self.infoType == TYPE_RECIPES) {
        [self setTitle:@"食谱"];
    }else if (self.infoType == TYPE_NOURISH) {
        [self setTitle:@"养育"];
    }else if (self.infoType == TYPE_EVALUATION) {
        [self setTitle:@"测评"];
    }
    [self setRightButtonWithTitle:@"我收藏" selector:@selector(settingAction)];
}

- (void)getCategoryInfo{
    [XEProgressHUD AlertLoading];
    __weak RecipesViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getInfoWithBabyId:nil tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg];
            return;
        }
       // NSLog(@"jsonRet===============%@",jsonRet);
        
        NSArray *childs = [jsonRet objectForKey:@"object"];
        if (childs) {
            weakSelf.titles = [[NSMutableArray alloc] initWithCapacity:childs.count];
            weakSelf.categoryViews = [[NSMutableArray alloc] initWithCapacity:childs.count];
            for (NSDictionary* child in childs) {
                XECategoryView *cv = [[XECategoryView alloc] init];
                [weakSelf addTableWithTitle:[child objectForKey:@"title"] andView:cv];
            }
            [weakSelf initNavigationBarView];
            [weakSelf initContentScrollView];
            [weakSelf getCategoryInfoWithTag:weakSelf.titles[0] andIndex:0];
        }

        [XEProgressHUD AlertSuccess:@"获取成功."];
    }tag:tag];
}

- (void)getCategoryInfoWithTag:(NSString *)tagString andIndex:(NSUInteger)index{
//    [XEProgressHUD AlertLoading];
    __weak RecipesViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getListInfoWithNum:nil stage:index+1 cat:self.infoType tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
    
            return;
        }
        
        XECategoryView *cv = _categoryViews[index];
        cv.delegate = self;
        NSMutableArray *hotGroups = [[NSMutableArray alloc] init];
        for (NSDictionary *groupDic in [[jsonRet objectForKey:@"object"] objectForKey:@"infos"]) {
            XERecipesInfo *recipesInfo = [[XERecipesInfo alloc] init];
            [recipesInfo setRecipesInfoByDic:groupDic];
            [hotGroups addObject:recipesInfo];
        }
        [_hotUnionDic setValue:hotGroups forKey:_titles[index]];
        _hotGroups = [_hotUnionDic mutableArrayValueForKey:_titles[index]];
        cv.dateArray = _hotGroups;
//        cv.dateArray = hotGroups;
        [cv.tableView reloadData];
        
        [weakSelf recordCategoryRefreshTimeWith:index];
        
    } tag:tag];
}

//设置导航
- (void)initNavigationBarView{
    
    CGFloat itemMargin = 20;
    CGFloat itemMarginLeft = 15;
    scrollBarWidth = itemMarginLeft;
    
    for (UIButton *button in _categoryScrollView.subviews) {
        [button removeFromSuperview];
    }
    
    for (int i = 0; i < _titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        
        CGSize titleSize = [button.titleLabel.text sizeWithFont:button.titleLabel.font];
        [button setFrame:CGRectMake(scrollBarWidth, 12, titleSize.width, 20)];
        scrollBarWidth += itemMargin + titleSize.width;
        
        [button setTitleColor:self.unselectedLabelColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectedLabelColor forState:UIControlStateSelected];
        
        button.tag = i+1;
        [button addTarget:self action:@selector(categoryItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_categoryScrollView addSubview:button];
        
        if (i == 0) {
            [button setTitleColor:self.selectedLabelColor forState:UIControlStateNormal];
            button.transform = CGAffineTransformIdentity;
            button.transform = CGAffineTransformMakeScale(kNavbarButtonScaleFactor, kNavbarButtonScaleFactor);
        }
    }
    
    _categoryScrollView.contentSize = CGSizeMake(scrollBarWidth, _categoryScrollView.frame.size.height);
    //滚动动态计算
    [self needScrollIndex];
}

- (void)needScrollIndex{
    for (UIButton *button in _categoryScrollView.subviews) {
        if (button.frame.origin.x > 160) {
            scrollIndex = button.tag - 2;
            return;
        }
    }
}

- (void)initContentScrollView{
    
    _contentView.contentSize = CGSizeMake(_contentView.frame.size.width * _titles.count, _contentView.frame.size.height);
    _contentView.directionalLockEnabled = YES;
    for (UIView *view in _contentView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < [_categoryViews count]; i++) {
        id obj = [_categoryViews objectAtIndex:i];
        if ([obj isKindOfClass:[UIView class]]) {
            UIView *view = (UIView *)obj;
            CGFloat scrollWidth = _contentView.frame.size.width;
            CGFloat scrollHeight = _contentView.frame.size.height;
            [view setFrame:CGRectMake(i*scrollWidth, 0, scrollWidth, scrollHeight)];
            [_contentView addSubview:view];
        }
    }
}

- (void)recordCategoryRefreshTimeWith:(NSUInteger)index{
    NSTimeInterval categoryRefreshTime = [[NSDate date] timeIntervalSince1970];
    NSString *key = [NSString stringWithFormat:@"%@_%@_%ld", kCategoryRefreshTime, [XEEngine shareInstance].uid,index];
    [[NSUserDefaults standardUserDefaults] setDouble:categoryRefreshTime forKey:key];
}

- (BOOL)categoryNecessaryRefreshWith:(NSUInteger)index{
    //获取分类最近刷新时间
    NSString *key = [NSString stringWithFormat:@"%@_%@_%ld", kCategoryRefreshTime, [XEEngine shareInstance].uid,index];
    double categoryRefreshTime = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970];
    if (nowtime - categoryRefreshTime > XERefreshInterval) {
        return YES;
    }else {
        return NO;
    }
}

- (void)categoryItemClicked:(UIButton *)button{
    self.selectedIndex = button.tag;
}

- (void)setSelectedIndex:(NSUInteger)index{
    
    if (index != self.selectedIndex) {
        UIButton *origin = (UIButton *)[_categoryScrollView viewWithTag:self.selectedIndex];
        if ([origin isKindOfClass:[UIButton class]]) {
            //origin.transform = CGAffineTransformIdentity;
            origin.transform = CGAffineTransformMakeScale(1.f, 1.f);
            [origin setTitleColor:self.unselectedLabelColor forState:UIControlStateNormal];
        }
        
        UIButton *button = (UIButton *)[_categoryScrollView viewWithTag:index];
        [button setTitleColor:self.selectedLabelColor forState:UIControlStateNormal];
        button.transform = CGAffineTransformMakeScale(kNavbarButtonScaleFactor, kNavbarButtonScaleFactor);
        
        _selectedIndex = index;
        [self transitionToViewAtIndex:index-1];
        if ([self categoryNecessaryRefreshWith:index-1]) {
            XECategoryView *cv = _categoryViews[index-1];
            cv.delegate = self;
            //            [cv.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
            //[cv.pullUpView onlyLoading];
            
            [self getCategoryInfoWithTag:_titles[_selectedIndex-1] andIndex:_selectedIndex-1];
        }
    }
}

//添加分类名和分类页
- (void)addTableWithTitle:(NSString *)title andView:(UIView *)view{
    [_titles addObject:title];
    [_categoryViews addObject:view];
}

-(void)categoryScrollToVisible:(NSUInteger)index{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGSize viewSize = _categoryScrollView.frame.size;
        CGRect rect;
        if (index > scrollIndex) {
            CGFloat titleWidth = 0;
            for (int i = scrollIndex; i < index; i++) {
                titleWidth += [_titles[index] sizeWithFont:[UIFont systemFontOfSize:15]].width;
            }
            rect = CGRectMake((index - scrollIndex) * 20 + titleWidth, 0, viewSize.width, viewSize.height);
        }else {
            rect = CGRectMake(0, 0, viewSize.width, viewSize.height);
        }
        dispatch_async(dispatch_get_main_queue(),^{
            [_categoryScrollView scrollRectToVisible:rect animated:YES];
        });
    });
}

#pragma mark - delegages
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _contentView) {
        if (0==fmod(scrollView.contentOffset.x,scrollView.frame.size.width)){
            _selectedIndex = scrollView.contentOffset.x/scrollView.frame.size.width+1;
            if ([self categoryNecessaryRefreshWith:_selectedIndex-1]) {
                XECategoryView *cv = _categoryViews[_selectedIndex-1];
                cv.delegate = self;
                //                [cv.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
//                [cv.pullUpView onlyLoading];
                [self getCategoryInfoWithTag:_titles[_selectedIndex-1] andIndex:_selectedIndex-1];
            }
            [self categoryScrollToVisible:_selectedIndex-1];
        }
        _bScroll = NO;
    }
    if (bOverspeed) {
        for (UIButton *button in _categoryScrollView.subviews) {
            if (button.tag == _selectedIndex) {
                [button setTitleColor:self.selectedLabelColor forState:UIControlStateNormal];
                button.transform = CGAffineTransformMakeScale(kNavbarButtonScaleFactor, kNavbarButtonScaleFactor);
            }else{
                button.transform = CGAffineTransformMakeScale(1.f, 1.f);
                [button setTitleColor:self.unselectedLabelColor forState:UIControlStateNormal];
            }
        }
        bOverspeed = NO;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == _contentView) {
        _bScroll = YES;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (scrollView == _contentView) {
        if (_bScroll && (_selectedIndex == 1 || _selectedIndex == _titles.count)) {
            _bScroll = NO;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == _contentView) {
        if (decelerate) {
            _selectedIndex = scrollView.contentOffset.x/scrollView.frame.size.width+1;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _contentView) {
        // 左 or 右
        UIButton *relativeButton = nil;
        UIButton *currentButton = (UIButton *)[_categoryScrollView viewWithTag:_selectedIndex];
        
        CGFloat offset = scrollView.contentOffset.x - (_selectedIndex - 1)*scrollView.frame.size.width;
        if(offset > 0 && _selectedIndex < [self.titles count]){//右
            relativeButton = (UIButton *)[_categoryScrollView viewWithTag:_selectedIndex+1];
        }else if(offset < 0 && _selectedIndex > 1){
            relativeButton = (UIButton *)[_categoryScrollView viewWithTag:_selectedIndex-1];
        }
        offset = fabsf(offset);
        if (offset > 320) {
            //滑动太快算法有点问题，控制一下
            bOverspeed = YES;
            return;
        }
        
        if (relativeButton) {
            
            CGFloat scrollViewWidth = scrollView.frame.size.width;
            CGFloat currentScaleFactor = (kNavbarButtonScaleFactor)-(kNavbarButtonScaleFactor-1)*fabsf(offset)/scrollViewWidth;
            CGFloat relativeScaleFactor = (kNavbarButtonScaleFactor-1)*fabsf(offset)/scrollViewWidth+1.f;
            
            UIColor *currentColor = [UIColor colorWithRed:((self.unselectedLabelColor.red-self.selectedLabelColor.red)*offset/scrollViewWidth+self.selectedLabelColor.red)
                                                    green:((self.unselectedLabelColor.green-self.selectedLabelColor.green)*offset/scrollViewWidth+self.selectedLabelColor.green)
                                                     blue:((self.unselectedLabelColor.blue-self.selectedLabelColor.blue)*offset/scrollViewWidth+self.selectedLabelColor.blue)
                                                    alpha:1];
            
            UIColor *relativeColor = [UIColor colorWithRed:((self.selectedLabelColor.red-self.unselectedLabelColor.red)*offset/scrollViewWidth+self.unselectedLabelColor.red)
                                                     green:((self.selectedLabelColor.green-self.unselectedLabelColor.green)*offset/scrollViewWidth+self.unselectedLabelColor.green)
                                                      blue:((self.selectedLabelColor.blue-self.unselectedLabelColor.blue)*offset/scrollViewWidth+self.unselectedLabelColor.blue)
                                                     alpha:1];
            
            currentButton.transform = CGAffineTransformMakeScale(currentScaleFactor,currentScaleFactor);
            [currentButton setTitleColor:currentColor forState:UIControlStateNormal];
            
            relativeButton.transform = CGAffineTransformMakeScale(relativeScaleFactor,relativeScaleFactor);
            [relativeButton setTitleColor:relativeColor forState:UIControlStateNormal];
        }
    }
}


- (void)transitionToViewAtIndex:(NSUInteger)index{
    [self categoryScrollToVisible:index];
    [_contentView setContentOffset:CGPointMake(index * _contentView.frame.size.width, 0)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)settingAction{
    
    NSLog(@"=================我的收藏");
}

- (void)didTouchCellWithRecipesInfo:(XERecipesInfo *)recipesInfo{

    NSLog(@"==================%@",recipesInfo.title);
}

@end
