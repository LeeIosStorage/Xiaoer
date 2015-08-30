//
//  PaySuccessViewController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/27.
//
//

#import "XESuperViewController.h"

@interface PaySuccessViewController : XESuperViewController
@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property (strong, nonatomic) IBOutlet UIView *sucImgView;
@property (strong, nonatomic) IBOutlet UIView *addressView;
@property (strong, nonatomic) IBOutlet UIView *priceView;
@property (strong, nonatomic) IBOutlet UIView *detailAToMainView;
@property (strong, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *alertTextLab;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIButton *backToMainBtn;

@end
