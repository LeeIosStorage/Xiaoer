//
//  CycleView.h
//  太阳宝
//
//  Created by Dream lee on 15/6/17.
//  Copyright (c) 2015年 Dream lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol lunboDelegate <NSObject>

- (void)lunboTouchIndexOfImage:(NSInteger )index;

@end

@interface CycleView : UIView

- (void)configureHeaderWith:(NSMutableArray *)array;
@property (nonatomic,assign)NSInteger type;

@property (nonatomic,assign)id<lunboDelegate>delegate;
@end
