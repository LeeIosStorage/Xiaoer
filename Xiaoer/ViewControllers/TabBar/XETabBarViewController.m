//
//  XETabBarViewController.m
//  Xiaoer
//
//  Created by KID on 14/12/30.
//
//

#import <objc/runtime.h>
#import <objc/message.h>
#import "XETabBarViewController.h"
#import "XETabBarItemView.h"

@interface XETabBarViewController ()<UINavigationControllerDelegate,XETabBarDelegate>

@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, assign) CGFloat tabBarHeight;
@property (nonatomic, assign) CGFloat tabTopGap;

@property (nonatomic, retain) NSMutableArray* badgeNums;
-(void) loadViewControllers;

@end

@implementation XETabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void) loadView {
    [super loadView];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //不让系统给边缘view添加偏移
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    // Do any additional setup after loading the view.
    self.tabBarHeight = 50;
    self.tabTopGap = 1;
    self.view.backgroundColor = [UIColor clearColor];
    
    //self.view = self.containerView;
    self.containerView = self.view;
    //self.containerView = [[UIView alloc] initWithFrame:self.view.frame] ;
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //    self.containerView.backgroundColor = [UIColor colorWithRed:236 green:236 blue:236 alpha:1.0];
    //self.containerView.clipsToBounds = YES;
    
    
    
    self.tabBar = [[XETabBarView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - self.tabBarHeight, CGRectGetWidth(self.view.bounds), self.tabBarHeight)];
    self.tabBar.initialIndex = self.initialIndex;
    self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    self.tabBar.delegate = self;
    
    [self.view addSubview:self.tabBar];
    
    
    [self loadViewControllers];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.selectedViewController viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.selectedViewController viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void) loadViewControllers {
    NSMutableArray *controllerTabs = [NSMutableArray arrayWithCapacity:[self.viewControllers count]];
    NSUInteger tagIndex = 0;
    for (UIViewController *controller in self.viewControllers) {
        if ([controller isKindOfClass:[UINavigationController class]]) {
            ((UINavigationController *)controller).delegate = self;
        }
        XETabBarItemView *tabItem = [[[NSBundle mainBundle] loadNibNamed:@"XETabBarItemView" owner:nil options:nil] objectAtIndex:0];
        
        if (tagIndex == 0) {
            tabItem.itemIconImageView.image = [UIImage imageNamed:@"main_tabbar_icon"];
            tabItem.itemIconImageView.highlightedImage = [UIImage imageNamed:@"main_tabbar_icon_hover"];
            tabItem.itemLabel.text = @"首页";
        }else if (tagIndex == 1){
            tabItem.itemIconImageView.image = [UIImage imageNamed:@"evaluations_tabbar_icon"];
            tabItem.itemIconImageView.highlightedImage = [UIImage imageNamed:@"evaluations_tabbar_icon_hover"];
            tabItem.itemLabel.text = @"评测";
        }else if (tagIndex == 2){
            tabItem.itemIconImageView.image = [UIImage imageNamed:@"chat_tabbar_icon"];
            tabItem.itemIconImageView.highlightedImage = [UIImage imageNamed:@"chat_tabbar_icon_hover"];
            tabItem.itemLabel.text = @"专家聊";
        }else if (tagIndex == 3){
            tabItem.itemIconImageView.image = [UIImage imageNamed:@"mine_tabbar_icon"];
            tabItem.itemIconImageView.highlightedImage = [UIImage imageNamed:@"mine_tabbar_icon_hover"];
            tabItem.itemLabel.text = @"我的";
        }
        
        
        [controllerTabs addObject:tabItem];
        controller.tabController = self;
        tagIndex++;
    }
    self.tabBar.items = controllerTabs;
    
    [self refreshBottomBadgeForConversation:nil];
    [self handleFriendTimelineUreadEvent];
    
}
- (void)refreshBottomBadgeForConversation:(id*)conversation {
//    if (conversation== nil) {
//        [self refreshBadge:TAB_INDEX_MSG];
//        [self refreshBadge:TAB_INDEX_MINE];
//        [self refreshBadge:TAB_INDEX_LIANMENG];
//        //[self refreshBadge:TAB_INDEX_DISC];
//    } eXEe if ([conversation.peerId isEqualToString:XE_NEW_MSG_FROM_FRIEND_REC] ) {
//        [self refreshBadge:TAB_INDEX_MINE];
//    } eXEe if ([conversation.peerId isEqualToString:XE_NEW_MSG_FROM_FEED]) {
//        [self refreshBadge:TAB_INDEX_LIANMENG];
//    } eXEe {
//        [self refreshBadge:TAB_INDEX_MSG];
//    }
}
- (void)handleFriendTimelineUreadEvent {
    
    XETabBarItemView* tabBarItemView = nil;
    if (self.tabBar.items.count > 0) {
        tabBarItemView = [self.tabBar.items objectAtIndex:TAB_INDEX_MAINPAGE];
    }
    if (tabBarItemView == nil) {
        return;
    }
    
    tabBarItemView.badgeNum = 0;
    
    //redIconView.hidden = !([XESettingConfig staticInstance].friendTimelineUnreadEvent || [XEGroupsManager shareInstance].groupFeedTimelineUnreadEvent);
    
}
//#pragma msg listen
//- (void)conversationUnreadedNumChange:(XEConversationInfo*)conversation{
//    [self refreshBottomBadgeForConversation:conversation];
//}
//
//-(void)msgsDeleted:(NSArray *)msgs conversation:(XEConversationInfo *)conversation{
//    [self refreshBottomBadgeForConversation:conversation];
//}
//- (void)conversationsClear{
//    [self refreshBottomBadgeForConversation:nil];
//}
#pragma mark - XEGroupsManagerListener
- (void)groupFeedTimelineUnreadEventChangeWithGid:(NSString *)gid{
    
    XETabBarItemView* tabBarItemView = nil;
    if (self.tabBar.items.count > 0) {
        tabBarItemView = [self.tabBar.items objectAtIndex:TAB_INDEX_MAINPAGE];
    }
    if (tabBarItemView == nil) {
        return;
    }
    
    tabBarItemView.badgeNum = 0;
}


-(void)refreshBadge:(int)index{
    XETabBarItemView* tabBarItemView = nil;
    if (self.tabBar.items.count > 0) {
        tabBarItemView = [self.tabBar.items objectAtIndex:index];
    }
    if (tabBarItemView == nil) {
        return;
    }
    if (index == 2) {
        
    }
    
    int unreadCount = 0;
    
    tabBarItemView.badgeNum = unreadCount;
    
}
- (void)setBadge:(int)badgeNum forIndex:(NSUInteger)index {
    if (self.badgeNums == nil || self.viewControllers.count != self.badgeNums.count) {
        self.badgeNums = [[NSMutableArray alloc] init];
        for (int i=0; i < self.viewControllers.count; ++i) {
            [self.badgeNums  addObject:[NSNumber numberWithInt:0]];
        }
    }
    if ([[self.badgeNums objectAtIndex:index] integerValue] != badgeNum) {
        [self.badgeNums replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:badgeNum]];
    }
}
#pragma mark - <XETabBarDelegate>

- (void)tabBar:(XETabBarView *)aTabBar didSelectTabAtIndex:(NSUInteger)anIndex{
    UIViewController *vc = [self.viewControllers objectAtIndex:anIndex];
    
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
    }else {
        [self.selectedViewController.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (self.selectedViewController == vc) {
        if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
        } else {
            [self.selectedViewController.navigationController popToRootViewControllerAnimated:YES];
        }
        if (!aTabBar.simulateSelected) {
            id<XETabBarControllerSubVcProtocol> protocol = (id<XETabBarControllerSubVcProtocol>)self.selectedViewController;
            if ([protocol respondsToSelector:@selector(tabBarController:reSelectVc:)]) {
                [protocol tabBarController:self reSelectVc:self.selectedViewController];
            }
        }
    }
    else {
        [self.selectedViewController.view removeFromSuperview];
        self.selectedViewController = vc;
        //[self.selectedViewController viewWillAppear:NO];
        
        self.containerView = self.selectedViewController.view;
        self.selectedViewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                                             UIViewAutoresizingFlexibleHeight |
                                                             UIViewAutoresizingFlexibleBottomMargin);
        CGFloat containerViewHeight = CGRectGetHeight(self.view.bounds);
        containerViewHeight -= CGRectGetHeight(self.tabBar.bounds) - self.tabTopGap;
        self.selectedViewController.view.frame = CGRectMake(CGRectGetMinX(self.view.bounds),
                                                            CGRectGetMinY(self.view.bounds),
                                                            CGRectGetWidth(self.view.bounds),
                                                            containerViewHeight);
        [self.view addSubview:self.selectedViewController.view];
        [self.view sendSubviewToBack:self.selectedViewController.view];
        //[self.containerView setNeedsLayout];
        //[self.selectedViewController viewDidAppear:NO];
        self.selectedIndex = anIndex;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        [self.delegate tabBarController:self
                didSelectViewController:self.selectedViewController];
    }
}


#pragma mark - <UINavigationControllerDelegate>

-(void) navigationController:(UINavigationController *)nvc wilXEhowViewController:(UIViewController *)vc animated:(BOOL)animated {
    
    if (nvc.viewControllers.count > 2) {
        return;
    }
    
    [vc setTabController:nvc.tabController];
    if (vc.hidesBottomBarWhenPushed == YES && self.tabBar.hidden == NO) {
        self.containerView.frame = self.view.bounds;
        // One *might* be inclined to think UINavigationControllerHideShowBarDuration would work best here. Sadly not so.
        [UIView animateWithDuration:0.275
                              delay:0
                            options:(UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseIn)
                         animations:^{
                             CGRect tabBarBounds = self.tabBar.frame;
                             tabBarBounds.origin.x -= CGRectGetMaxX(self.containerView.frame);
                             self.tabBar.frame = tabBarBounds;
                         }
                         completion:^(BOOL finished){
                             self.tabBar.hidden = YES;
                         }];
        return;
    }
    else if (vc.hidesBottomBarWhenPushed == NO && self.tabBar.hidden == YES) {
        self.tabBar.hidden = NO;
        [UIView animateWithDuration:0.275
                              delay:0
                            options:(UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseIn)
                         animations:^{
                             CGRect tabBarBounds = self.tabBar.frame;
                             tabBarBounds.origin.x = CGRectGetMinX(self.view.bounds);
                             self.tabBar.frame = tabBarBounds;
                         }
                         completion:^(BOOL finished){
                             self.containerView.frame = CGRectMake(CGRectGetMinX(self.view.bounds),
                                                                   CGRectGetMinY(self.view.bounds),
                                                                   CGRectGetWidth(self.view.bounds),
                                                                   (CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.tabBar.bounds) + self.tabTopGap));
                         }];
        return;
    }
}



#pragma mark - UIInterfaceOrientation
- (NSUInteger)supportedInterfaceOrientations{
    if (self.selectedViewController)
        return [self.selectedViewController supportedInterfaceOrientations];
    
    return [super supportedInterfaceOrientations];
}
-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)anOrientation {
    BOOL shouldRotate = YES;
    if (self.selectedViewController && [self.selectedViewController respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)])
    {
        shouldRotate = [self.selectedViewController shouldAutorotateToInterfaceOrientation:anOrientation];
    }
    return shouldRotate;
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)anOrientation duration:(NSTimeInterval)aDuration {
    
    [self.selectedViewController willRotateToInterfaceOrientation:anOrientation duration:aDuration];
}

-(void) willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)anOrientation duration:(NSTimeInterval)aDuration {
    [self.selectedViewController willAnimateFirstHalfOfRotationToInterfaceOrientation:anOrientation duration:aDuration];
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)anOrientation duration:(NSTimeInterval)aDuration {
    [self.selectedViewController willAnimateRotationToInterfaceOrientation:anOrientation duration:aDuration];
}

-(void) willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)anOrientation duration:(NSTimeInterval)aDuration {
    [self.selectedViewController willAnimateSecondHalfOfRotationFromInterfaceOrientation:anOrientation duration:aDuration];
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)anOrientation {
    //[self.tabBar.selectedTabBarItem setSelected:YES];
    [self.selectedViewController didRotateFromInterfaceOrientation:anOrientation];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

@implementation UIViewController (XETabBarControllerItem)

//@dynamic tabController;

static const char* XETabControllerKey = "XETabControllerKey";

-(XETabBarViewController *)tabController{
    return objc_getAssociatedObject(self, XETabControllerKey);
}
-(void)setTabController:(XETabBarViewController *)tabController{
    objc_setAssociatedObject(self, XETabControllerKey, tabController, OBJC_ASSOCIATION_ASSIGN);
}

@end
