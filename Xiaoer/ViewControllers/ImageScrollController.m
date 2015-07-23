//
//  ImageScrollController.m
//  ImageScrollCanDelete
//
//  Created by 王鹏 on 15/7/22.
//  Copyright (c) 2015年 王鹏. All rights reserved.
//

#import "ImageScrollController.h"

@interface ImageScrollController ()<UIScrollViewDelegate>

@end

@implementation ImageScrollController

- (void)viewDidLoad {
    [super viewDidLoad];
    //给scrollView设置代理
    self.scrollView.delegate = self;
    //frame坐标原点相对于内容区域原点的偏移量
    //关闭或打开滚动
    self.scrollView.scrollEnabled = YES;
    //方向滚动,只能水平滑动,不能斜华
    self.scrollView.directionalLockEnabled = YES;
    //按上方的状态栏返回最顶部,默认YES
    self.scrollView.scrollsToTop = NO;
    //边界弹跳
    self.scrollView.bounces = NO;
    //允许水平拖动
    self.scrollView.alwaysBounceHorizontal = YES;
    //滚动条的样式
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    //是否显示某个方向的滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //整页翻动,和scrollView的高度相关
    self.scrollView.pagingEnabled = YES;
    
    if (self.ifHaveDelete == YES) {
        self.deleteBtn.hidden = NO;
    }else{
        self.deleteBtn.hidden = YES;
    }
    
    [self configureScrollViewWith:self.array];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)deleteBtnTouched:(id)sender {

        NSInteger index = self.scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    if (self.array.count > 0) {
        [self.array removeObjectAtIndex:index];
        if (self.array.count == 0) {
            [self.deleteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        NSLog(@"self.array.count === %ld",self.array.count);
        [self configureScrollViewWith:self.array];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteResultWith:)]) {
            [self.delegate deleteResultWith:self.array];
        }

    }


}
- (void)configureScrollViewWith:(NSMutableArray *)array{
    self.array = array;
    [self setScrollviewWith:array];


}

- (void)setScrollviewWith:(NSMutableArray *)array{
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    self.scrollView.contentSize = CGSizeMake(array.count * [UIScreen mainScreen].bounds.size.width,0);
    self.pageControll.numberOfPages = array.count;
    for (int i = 0; i < array.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
        UIImage *image = [UIImage imageNamed:array[i]];
        imageView.tag = i;
        imageView.image = image;
        CGFloat wide = imageView.image.size.width /[UIScreen mainScreen].bounds.size.width > 1 ? [UIScreen mainScreen].bounds.size.width : image.size.width;
        CGFloat height = imageView.image.size.height /[UIScreen mainScreen].bounds.size.
        height> 1 ? [UIScreen mainScreen].bounds.size.height : image.size.height;
        imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width + ([UIScreen mainScreen].bounds.size.width - wide)/2, ([UIScreen mainScreen].bounds.size.height - height)/2, wide, height);
        [self.scrollView addSubview:imageView];
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
    self.pageControll.currentPage = index;

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
