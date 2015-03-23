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
#import "XELinkerHandler.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "CollectionViewController.h"

//#define Selected_Color [UIColor colorWithRed:(1.0 * 58 / 255) green:(1.0 * 161 / 255) blue:(1.0 * 248 / 255) alpha:1]
#define UnSelected_Color [UIColor colorWithRed:(1.0 * 172 / 255) green:(1.0 * 177 / 255) blue:(1.0 * 183 / 255) alpha:1]
#define XEDisplayMotionHeight 47
#define XERefreshInterval     30

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
@property (nonatomic, strong) NSMutableDictionary *endDic;
@property (nonatomic, strong) NSMutableDictionary *pageNumDic;
@property (nonatomic, strong) NSMutableDictionary *hotUnionDic;

@property (assign, nonatomic) BOOL bScroll;

@end

@implementation RecipesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _unselectedLabelColor = UnSelected_Color;
    _selectedLabelColor = SKIN_COLOR;

    _selectedIndex = 1;
    
    _pageNumDic = [[NSMutableDictionary alloc] init];
    _endDic = [[NSMutableDictionary alloc] init];
    _hotUnionDic = [[NSMutableDictionary alloc] init];
    _hotGroups = [[NSMutableArray alloc] init];
    
    [self getCacheCategoryInfo];
    [self getCategoryInfo];
}

-(void)initNormalTitleNavBarSubviews{
    if (self.infoType == TYPE_RECIPES) {
        [self setTitle:@"食谱"];
    }else if (self.infoType == TYPE_NOURISH) {
        [self setTitle:@"养育"];
    }else if (self.infoType == TYPE_EVALUATION) {
        [self setTitle:@"评测"];
    }else if (self.infoType == TYPE_ACTIVITY) {
        [self setTitle:@"活动"];
    }else if (self.infoType == TYPE_ATTENTION) {
        [self setTitle:@"注意力"];
    }else if (self.infoType == TYPE_HABIT) {
        [self setTitle:@"好习惯"];
    }
    [self setRightButtonWithImageName:@"common_collect_icon" selector:@selector(settingAction)];
}

- (void)getCacheCategoryInfo{
    __weak RecipesViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getInfoWithBabyId:nil tag:tag];
    
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            NSArray *childs = [jsonRet objectForKey:@"object"];
            if (childs) {
                weakSelf.titles = [[NSMutableArray alloc] initWithCapacity:childs.count];
                weakSelf.categoryViews = [[NSMutableArray alloc] initWithCapacity:childs.count];
                for (NSDictionary* child in childs) {
                    XECategoryView *cv = [[XECategoryView alloc] init];
                    [weakSelf addTableWithTitle:[child objectForKey:@"title"] andView:cv];
                }
                if (weakSelf.bSpecific) {
                    [weakSelf initNavigationBarView];
                    [weakSelf initContentScrollView];
                    [weakSelf getCacheCategoryInfoWithTag:weakSelf.titles[0] andIndex:weakSelf.stage-1];
                }else{
                    [weakSelf initNavigationBarView];
                    [weakSelf initContentScrollView];
                    [weakSelf getCacheCategoryInfoWithTag:weakSelf.titles[0] andIndex:0];
                }
            }
        }
    }];
}

- (void)getCategoryInfo{
    __weak RecipesViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getInfoWithBabyId:nil tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        
        NSArray *childs = [jsonRet objectForKey:@"object"];
        if (childs) {
            weakSelf.titles = [[NSMutableArray alloc] initWithCapacity:childs.count];
            weakSelf.categoryViews = [[NSMutableArray alloc] initWithCapacity:childs.count];
            for (NSDictionary* child in childs) {
                XECategoryView *cv = [[XECategoryView alloc] init];
                [weakSelf addTableWithTitle:[child objectForKey:@"title"] andView:cv];
            }
            if (weakSelf.bSpecific) {
                [weakSelf initNavigationBarView];
                [weakSelf initContentScrollView];
                if (weakSelf.bSpecific) {
                    weakSelf.selectedIndex = weakSelf.stage;
                }
                [weakSelf getCategoryInfoWithTag:weakSelf.titles[0] andIndex:weakSelf.stage-1];
            }else{
                [weakSelf initNavigationBarView];
                [weakSelf initContentScrollView];
                [weakSelf getCategoryInfoWithTag:weakSelf.titles[0] andIndex:0];
            }
        }
    }tag:tag];
}

- (void)getCacheCategoryInfoWithTag:(NSString *)tagString andIndex:(NSUInteger)index{
    __weak RecipesViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getListInfoWithNum:0 stage:index+1 cat:self.infoType tag:tag];
    
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            NSMutableArray *hotGroups = [[NSMutableArray alloc] init];
            for (NSDictionary *groupDic in [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"infos"]) {
                XERecipesInfo *recipesInfo = [[XERecipesInfo alloc] init];
                [recipesInfo setRecipesInfoByDic:groupDic];
                [hotGroups addObject:recipesInfo];
            }
            
            XECategoryView *cv = weakSelf.categoryViews[index];
            cv.dateArray = hotGroups;
            cv.delegate = self;
            [cv.tableView reloadData];
            [cv.maskView setHidden:YES];
        }
    }];
}

- (void)getCategoryInfoWithTag:(NSString *)tagString andIndex:(NSUInteger)index{
//    [XEProgressHUD AlertLoading];
    __weak RecipesViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getListInfoWithNum:0 stage:index+1 cat:self.infoType tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        
        XECategoryView *cv = _categoryViews[index];
        cv.delegate = self;
        
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (cv.bRefresh) {
                [cv.pullRefreshView finishedLoading];
                cv.bRefresh = NO;
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        
        NSMutableArray *hotGroups = [[NSMutableArray alloc] init];
        
        for (NSDictionary *groupDic in [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"infos"]) {
            XERecipesInfo *recipesInfo = [[XERecipesInfo alloc] init];
            [recipesInfo setRecipesInfoByDic:groupDic];
            [hotGroups addObject:recipesInfo];
        }
        [weakSelf.hotUnionDic setValue:hotGroups forKey:weakSelf.titles[index]];
        weakSelf.hotGroups = [weakSelf.hotUnionDic mutableArrayValueForKey:weakSelf.titles[index]];
        cv.dateArray = weakSelf.hotGroups;
        if (hotGroups.count > 0) {
            [cv.tableView reloadData];
        }else {
            [cv.maskView setHidden:NO];
        }
        
        [weakSelf recordCategoryRefreshTimeWith:index];
        
        [weakSelf.endDic setValue:[[jsonRet objectForKey:@"object"] objectForKey:@"end"] forKey:weakSelf.titles[index]];
        [weakSelf.pageNumDic setValue:@"1" forKey:weakSelf.titles[index]];
        if (cv.bRefresh) {
            [cv.pullRefreshView finishedLoading];
            //            cv.pullRefreshView.enabled = NO;
            cv.bRefresh = NO;
        }

        int cursor = [weakSelf.endDic intValueForKey:weakSelf.titles[index]];
        if (cursor == 0) {
            cv.tableView.showsInfiniteScrolling = NO;
//            [cv.tableView.infiniteScrollingView stopAnimating];
        }else{
            cv.tableView.showsInfiniteScrolling = YES;
        }
  
        [cv.tableView addInfiniteScrollingWithActionHandler:^{
            if (!weakSelf) {
                return;
            }
            
            int cursor = [weakSelf.endDic intValueForKey:weakSelf.titles[index]];
            if (cursor == 0) {
                [cv.tableView.infiniteScrollingView stopAnimating];
                cv.tableView.showsInfiniteScrolling = NO;
                return;
            }
            
            __block NSInteger pageNum = [weakSelf.pageNumDic intValueForKey:weakSelf.titles[index]] + 1;
            [weakSelf.pageNumDic setValue:[NSNumber numberWithInteger:pageNum] forKey:weakSelf.titles[index]];
            
            int tag = [[XEEngine shareInstance] getConnectTag];
            [[XEEngine shareInstance] getListInfoWithNum:pageNum stage:index+1 cat:self.infoType tag:tag];
            [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
                if (!weakSelf) {
                    return;
                }
                [cv.tableView.infiniteScrollingView stopAnimating];
                NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
                if (!jsonRet || errorMsg) {
                    [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
                    return;
                }
                NSMutableArray *hotGroups = [NSMutableArray arrayWithArray:[weakSelf.hotUnionDic arrayObjectForKey:weakSelf.titles[index]]];
                
//                NSInteger countIndex = hotGroups.count;
                for (NSDictionary *groupDic in [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"infos"]) {
                    XERecipesInfo *recipesInfo = [[XERecipesInfo alloc] init];
                    [recipesInfo setRecipesInfoByDic:groupDic];
                    [hotGroups addObject:recipesInfo];
                }
                
                [weakSelf.hotUnionDic setValue:hotGroups forKey:weakSelf.titles[index]];
                [weakSelf.endDic setValue:[[jsonRet objectForKey:@"object"] objectForKey:@"end"] forKey:weakSelf.titles[index]];
                weakSelf.hotGroups = [weakSelf.hotUnionDic mutableArrayValueForKey:weakSelf.titles[index]];
                //数据变化以后要及时刷新tableview
                [cv.tableView reloadData];
            
//                NSIndexPath *ip = [NSIndexPath indexPathForRow:countIndex inSection:0];
//                [cv.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                
                int cursor = [weakSelf.endDic intValueForKey:weakSelf.titles[index]];
                if (cursor == 0) {
                    cv.tableView.showsInfiniteScrolling = NO;
                }else{
                    cv.tableView.showsInfiniteScrolling = YES;
                    pageNum = [weakSelf.pageNumDic intValueForKey:weakSelf.titles[index]] + 1;
                    [weakSelf.pageNumDic setValue:[NSNumber numberWithInteger:pageNum] forKey:weakSelf.titles[index]];
                }
            } tag:tag];
        }];
    } tag:tag];
}

//设置导航
- (void)initNavigationBarView{
    
    CGFloat itemMargin = SCREEN_WIDTH == 320?20:32;
    CGFloat itemMarginLeft = SCREEN_WIDTH == 320?15:20;
    scrollBarWidth = itemMarginLeft;
    
    for (UIButton *button in _categoryScrollView.subviews) {
        [button removeFromSuperview];
    }
    
    for (int i = 0; i < _titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        //暂时不要
//        CGSize titleSize = [button.titleLabel.text sizeWithFont:button.titleLabel.font];
        CGSize titleSize =[button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
        [button setFrame:CGRectMake(scrollBarWidth, 12, titleSize.width, 20)];
        scrollBarWidth += itemMargin + titleSize.width;
//        CGFloat titleWidth = (SCREEN_WIDTH - (self.titles.count - 1)*20)/self.titles.count;
//        [button setFrame:CGRectMake(scrollBarWidth, 12, titleWidth, 20)];
//        scrollBarWidth += itemMargin + titleWidth;
        
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
    NSString *key = [NSString stringWithFormat:@"%@_%@_%d_%lu", kCategoryRefreshTime, [XEEngine shareInstance].uid,self.infoType,(unsigned long)index];
    [[NSUserDefaults standardUserDefaults] setDouble:categoryRefreshTime forKey:key];
}

- (BOOL)categoryNecessaryRefreshWith:(NSUInteger)index{
    //获取分类最近刷新时间
    NSString *key = [NSString stringWithFormat:@"%@_%@_%d_%lu", kCategoryRefreshTime, [XEEngine shareInstance].uid,self.infoType,(unsigned long)index];
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
            [cv.pullRefreshView triggerPullToRefresh];
            //[self getCategoryInfoWithTag:_titles[_selectedIndex-1] andIndex:_selectedIndex-1];
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
                [cv.pullRefreshView triggerPullToRefresh];
                //[self getCategoryInfoWithTag:_titles[_selectedIndex-1] andIndex:_selectedIndex-1];
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
    CollectionViewController *cVc = [[CollectionViewController alloc] init];
    [self.navigationController pushViewController:cVc animated:YES];
}

- (void)didTouchCellWithRecipesInfo:(XERecipesInfo *)recipesInfo{
    
    id vc = [XELinkerHandler handleDealWithHref:recipesInfo.recipesActionUrl From:self.navigationController];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didRefreshRecipesInfos {
//    NSLog(@"==================didRefreshRecipesInfos");
    [self getCacheCategoryInfoWithTag:_titles[_selectedIndex-1] andIndex:_selectedIndex-1];
    [self getCategoryInfoWithTag:_titles[_selectedIndex-1] andIndex:_selectedIndex-1];
}

-(void)dealloc {
    self.pageNumDic = nil;
    self.endDic = nil;
    self.hotUnionDic = nil;
    self.hotGroups = nil;
}

@end
