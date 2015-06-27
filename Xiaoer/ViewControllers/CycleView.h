//
//  CycleView.h
//  太阳宝
//
//  Created by Dream lee on 15/6/17.
//  Copyright (c) 2015年 Dream lee. All rights reserved.
//

#import <UIKit/UIKit.h>
//enum LunBoType {
//    shopMain = 0,
//    toyDetail,
//    activityDetail,
//}Luntype;
@interface CycleView : UIView

//type 是0 的时候让高度为150，其他的话代表商品详情界面高度为250；
- (void)configureHeaderWith:(NSInteger )type;
@property (nonatomic,assign)NSInteger type;
@end
