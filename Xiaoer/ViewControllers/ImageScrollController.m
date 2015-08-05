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
    self.scrollView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];

    if (self.ifHaveDelete == YES) {
        [self setRightButtonWithTitle:@"删除" selector:@selector(deleteBtnTouched)];
    }else{
        
    }
    self.ifDeleteBtnTouched = NO;
    
    [self configureScrollViewWith:self.array];


    // Do any additional setup after loading the view from its nib.
}


- (void)deleteBtnTouched{
    self.ifDeleteBtnTouched = YES;
    NSInteger index = self.scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    if (self.array.count > 0) {
        [self.array removeObjectAtIndex:index];
        if (self.array.count == 0) {
        
        }
        [self configureScrollViewWith:self.array];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteResultWith:)]) {
            [self.delegate deleteResultWith:index];
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
//    NSLog(@"%f %f",SCREEN_WIDTH,SCREEN_HEIGHT);
    
    self.scrollView.contentSize = CGSizeMake(array.count * [UIScreen mainScreen].bounds.size.width,0);
    self.pageControll.numberOfPages = array.count;
    for (int i = 0; i < array.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
        UIImage *image = array[i];
        imageView.tag = i;
        imageView.image = image;
        
        
        CGFloat Swidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat Sheight = [UIScreen mainScreen].bounds.size.height - 64;
        NSLog(@"%f  %f  %f %f",imageView.image.size.width,imageView.image.size.height,Swidth,Sheight);
        if (imageView.image.size.width > Swidth && imageView.image.size.height < Sheight) {
            
            imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width,(Sheight - (imageView.image.size.height * Swidth/imageView.image.size.width))/2 , Swidth, imageView.image.size.height * Swidth/imageView.image.size.width);
        }
        
        else if (imageView.image.size.width > Swidth && imageView.image.size.height > Sheight) {
            if (imageView.image.size.width > imageView.image.size.height) {
                imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width, (Sheight - (imageView.image.size.height * Swidth/imageView.image.size.width))/2, Swidth, imageView.image.size.height * Swidth/imageView.image.size.width);
            } else {
                NSLog(@"=====  %f",(Swidth - (Swidth*imageView.image.size.height/Sheight))/2);
                if ((Swidth - (Swidth*imageView.image.size.height/Sheight))/2 < 0) {
                    imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width, 0,SCREEN_WIDTH, Sheight);
                }else{
                    imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width + (Swidth - (Sheight*imageView.image.size.width/imageView.image.size.height))/2, 0, Sheight*imageView.image.size.width/imageView.image.size.height, Sheight);
                }
            }
        }
        else  if (imageView.image.size.width < Swidth && imageView.image.size.height > Sheight) {
            imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width +(Swidth - (Sheight*imageView.image.size.width/imageView.image.size.height))/2 , 64,Sheight*imageView.image.size.width/imageView.image.size.height, Sheight);
        }
        else   if (imageView.image.size.width < Swidth && imageView.image.size.height < Sheight) {
            imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width +(Swidth - (Sheight*imageView.image.size.width/imageView.image.size.height))/2 , (SCREEN_HEIGHT -64 - imageView.image.size.height)/2, imageView.image.size.width, imageView.image.size.height);
        }
//        CGFloat wide = imageView.image.size.width /[UIScreen mainScreen].bounds.size.width > 1 ? [UIScreen mainScreen].bounds.size.width : image.size.width;
//        CGFloat height = imageView.image.size.height /(SCREEN_HEIGHT - 64)> 1 ? SCREEN_HEIGHT-64 : image.size.height;
//        imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width + ([UIScreen mainScreen].bounds.size.width - wide)/2,(SCREEN_HEIGHT -64 - height)/2, wide, height);
        [self.scrollView addSubview:imageView];
        if (self.ifDeleteBtnTouched == NO && self.moveIndex && self.moveIndex == i) {
            //此处不理解  －64
            [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*self.moveIndex,- 64)];
//            NSLog(@"%f",SCREEN_WIDTH*self.moveIndex);
            self.pageControll.currentPage = self.moveIndex;
            
        }
    }

    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
    self.pageControll.currentPage = index;

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
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

@end
