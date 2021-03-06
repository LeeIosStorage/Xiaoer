//
//  XETitleNavBarView.h
//  Xiaoer
//
//  Created by KID on 14/12/31.
//
//

#import <UIKit/UIKit.h>

//@protocol backColorDelegate <NSObject>
//
//<#methods#>
//
//@end

@interface XETitleNavBarView : UIView

//title
@property (nonatomic, readonly) NSString * title;
@property (weak, nonatomic) IBOutlet UIButton *toolBarLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *toolBarLeftButton2;
@property (weak, nonatomic) IBOutlet UIButton *toolBarRightButton;
@property (weak, nonatomic) IBOutlet UIButton *toolBarRightButton2;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIImageView *navImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

-(id)init:(id)owner;
-(id) setTitle:(NSString *) title;
-(id) setTitle:(NSString *) title font:(UIFont *) font;
-(void)setbackImageColor:(UIColor *)color;

@end
