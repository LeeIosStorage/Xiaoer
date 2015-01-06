//
//  NewIntroView.h
//  Xiaoer
//
//  Created by KID on 15/1/6.
//
//

#import <UIKit/UIKit.h>

@interface NewIntroView : UIView<UIScrollViewDelegate>

@property (nonatomic, retain) UIImageView     *bgImageView;
@property (nonatomic, retain) UIScrollView    *scrollView;
@property (nonatomic, retain) NSArray         *introPages;

- (id)initWithFrame:(CGRect)frame andPages:(NSArray *)pagesArray;
@end
