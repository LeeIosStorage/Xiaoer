//
//  CardOfEastWebViewController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/5/19.
//
//

#import "XESuperViewController.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XECardInfo.h"

@interface CardOfEastWebViewController : XESuperViewController
@property (weak, nonatomic) IBOutlet UIImageView *cardImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *describe;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *activityBtn;
;

/**
 *  隐藏激活按钮
 */
@property (nonatomic,assign)BOOL hideCardInfo;
@property (weak, nonatomic) IBOutlet UILabel *cardNumber;
@property (weak, nonatomic) IBOutlet UILabel *password;

@property (nonatomic,assign)BOOL hideAllBtn;
@property (nonatomic,strong)NSString *kabaoid;
@property (nonatomic,strong)XECardInfo *cardinfo;
@end
