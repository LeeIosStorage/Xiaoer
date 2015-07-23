//
//  ImageScrollController.h
//  ImageScrollCanDelete
//
//  Created by 王鹏 on 15/7/22.
//  Copyright (c) 2015年 王鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol deleteDelegate <NSObject>

- (void)deleteResultWith:(NSMutableArray *)array;

@end


@interface ImageScrollController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic,assign)BOOL ifHaveDelete;
@property (nonatomic,assign)id<deleteDelegate>delegate;
@end
