//
//  ToyDetailViewController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/19.
//
//

#import "XESuperViewController.h"

@interface ToyDetailViewController : XESuperViewController
@property (nonatomic,strong)NSString *shopId;


@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
