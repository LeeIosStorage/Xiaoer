//
//  ShopCarViewController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/22.
//
//

#import "XESuperViewController.h"

@interface ShopCarViewController : XESuperViewController
@property (weak, nonatomic) IBOutlet UITableView *shopCarTab;
@property (strong, nonatomic) IBOutlet UIView *tabFooterView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;



@end
