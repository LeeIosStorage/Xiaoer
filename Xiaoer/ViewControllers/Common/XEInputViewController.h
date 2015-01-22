//
//  XEInputViewController.h
//  Xiaoer
//
//  Created by KID on 15/1/9.
//
//

#import "XESuperViewController.h"

@protocol XEInputViewControllerDelegate;

@interface XEInputViewController : XESuperViewController

@property(nonatomic, assign)id<XEInputViewControllerDelegate> delegate;
@property(nonatomic, strong) NSString* oldText;
@property(nonatomic, strong) NSString* titleText;
@property(nonatomic, assign) int maxTextLength;
@property(nonatomic, assign) int minTextLength;
@property(nonatomic, assign) float maxTextViewHight;
@property(nonatomic, strong) NSString* toolRightType;
@property(nonatomic, assign) UIKeyboardType keyboardType;
@end
@protocol XEInputViewControllerDelegate <NSObject>

@optional
- (void)inputViewControllerWithText:(NSString*)text;

@end
