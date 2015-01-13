//
//  XETitleNavBarView.h
//  Xiaoer
//
//  Created by KID on 14/12/31.
//
//

#import <UIKit/UIKit.h>

@interface XETitleNavBarView : UIView

//title
@property (nonatomic, readonly) NSString * title;
@property (weak, nonatomic) IBOutlet UIButton *toolBarLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *toolBarRightButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

-(id)init:(id)owner;
-(id) setTitle:(NSString *) title;
-(id) setTitle:(NSString *) title font:(UIFont *) font;

@end
