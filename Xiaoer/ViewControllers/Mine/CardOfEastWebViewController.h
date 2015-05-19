//
//  CardOfEastWebViewController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/5/19.
//
//

#import "XESuperViewController.h"

@interface CardOfEastWebViewController : XESuperViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *activityBtn;
;

/**
 *  隐藏激活按钮
 */
@property (nonatomic,assign)BOOL hideCardInfo;
@property (weak, nonatomic) IBOutlet UILabel *cardNumber;
@property (weak, nonatomic) IBOutlet UILabel *password;


@end
