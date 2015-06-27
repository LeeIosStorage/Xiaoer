//
//  ToyLunBoView.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/25.
//
//

#import <UIKit/UIKit.h>


@interface ToyLunBoView : UIView

//type 是0 的时候让高度为150，其他的话代表商品详情界面高度为250；
- (void)configureHeaderWith:(NSInteger )type;
@property (nonatomic,assign)NSInteger type;
@end