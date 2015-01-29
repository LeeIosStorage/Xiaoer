//
//  XECustomerWindow.h
//  Xiaoer
//
//  Created by KID on 15/1/26.
//
//

#import <UIKit/UIKit.h>

@protocol XECustomerWindowDelg <NSObject>

@optional
-(void)customerWindowClickAt:(NSIndexPath *)indexPath action:(NSString *)action;

@end

@interface XECustomerWindow : UIWindow

@property (nonatomic, weak)id<XECustomerWindowDelg> sheetDelg;
@property (nonatomic, assign) BOOL deleteBtnHidden;
@property (nonatomic, assign) BOOL shareSectionHidden;

-(void)setCustomerSheet;
-(void)cancelActionSheet:(id)sender;

@end
