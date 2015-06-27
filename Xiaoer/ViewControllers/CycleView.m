//
//  CycleView.m
//  太阳宝
//
//  Created by Dream lee on 15/6/17.
//  Copyright (c) 2015年 Dream lee. All rights reserved.
//

#import "CycleView.h"
#import "CycleScrollView.h"

@interface CycleView ()
@property (nonatomic, strong) CycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *imageURLArray;
@property (nonatomic, strong) NSMutableArray *PassIDs;
@property (nonatomic, assign) NSInteger index;
@end


@implementation CycleView
- (NSMutableArray *)imageURLArray {
    if (!_imageURLArray) {
        self.imageURLArray = [NSMutableArray array];
    }
    return _imageURLArray;
}

- (NSMutableArray *)PassIDs {
    if (!_PassIDs) {
        self.PassIDs = [NSMutableArray array];
    }
    return _PassIDs;
}

- (CycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        self.cycleScrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height) animationDuration:4];
        
        [self addSubview:_cycleScrollView];
    }
    return _cycleScrollView;
}



- (void)configureHeaderWith:(NSInteger)type{
    self.type = type;
  
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 1; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        NSString *str = [NSString stringWithFormat:@"%d.png",i];
        imageView.image = [UIImage imageNamed:str];
        [imageArray addObject:imageView];
    }
    self.cycleScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return imageArray[pageIndex];
    };
    self.cycleScrollView.totalPagesCount = ^NSInteger(void){
        return imageArray.count;
    };
    
    self.cycleScrollView.TapActionBlock = ^(NSInteger pageIndex){
        NSLog(@"点击了第%ld个",(long)pageIndex);
    };
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.frame.size.width;
    CGFloat heigh = 0;

    if (self.type == 0) {
        heigh = 150;
    }else{
        heigh = 250;
    }
    self.cycleScrollView.frame = CGRectMake(0, 0, width, heigh);
}

@end
