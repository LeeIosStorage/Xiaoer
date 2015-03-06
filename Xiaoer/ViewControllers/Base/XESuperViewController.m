//
//  XESuperViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/4.
//
//

#import "XESuperViewController.h"
#import "XENavigationController.h"

@interface XESuperViewController ()

@property (nonatomic, strong) UIPanGestureRecognizer *popRecognizer;

@end

@implementation XESuperViewController

-(void)setDisablePan:(BOOL)disablePan{
    
    _popRecognizer.enabled = !disablePan;
    _disablePan = disablePan;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //默认都有返回
    [self setLeftButtonWithSelector:@selector(backAction:)];
    
    //ios7以前的就用自定义的手势
    if (!self.navigationController || ![self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        UISwipeGestureRecognizer* rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)] ;
        rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:rightSwipeGestureRecognizer];
    }else{
        if (!_disablePan) {
#ifdef USE_SYS_PAN_GESTURE
#else
            _popRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
            _popRecognizer.delegate = self;
            _popRecognizer.cancelsTouchesInView = YES;
            [self.view addGestureRecognizer:_popRecognizer];
#endif
        }else{
            
        }
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

#pragma mark UIGestureRecognizer handlers

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint pv = [pan velocityInView:pan.view];
        if (pv.x < 0) {
            return NO;
        }
    }
    return YES;
}

- (void)handlePopRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer {
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));
    CGPoint velocity = [recognizer velocityInView:self.view];
    //    NSLog(@"progress:%.1f, recognizer.state:%d", progress, recognizer.state);
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (velocity.x <= 0) {
            return;
        }
        // Create a interactive transition and pop the view controller
        self.interactivePopTransition = [[XECommonVcTransition alloc] init];
        if ([self.navigationController respondsToSelector:@selector(XEpopViewControllerAnimated:)]) {
            [self.navigationController performSelector:@selector(XEpopViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES]];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // Update the interactive transition's progress
        [self.interactivePopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        // Finish or cancel the interactive transition
        if (progress > 0.5 || (velocity.x > 500 && velocity.x>ABS(velocity.y))) {
            self.interactivePopTransition.completionSpeed = .8;
            [self.interactivePopTransition finishInteractiveTransition];
        }
        else {
            self.interactivePopTransition.completionSpeed = .8;
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        
        self.interactivePopTransition = nil;
    }
    
}

- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer
{
    [self backAction:nil];
}

- (IBAction)backAction:(id)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (BOOL)shouldAutorotate{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
