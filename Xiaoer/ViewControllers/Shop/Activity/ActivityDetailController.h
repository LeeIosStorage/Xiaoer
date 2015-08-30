//
//  ActivityDetailController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/25.
//
//

#import "XESuperViewController.h"

@interface ActivityDetailController : XESuperViewController
@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property (strong, nonatomic) IBOutlet UIView *naviLable;
@property (strong, nonatomic) IBOutlet UIView *tabeHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *shopBackLab;

@end
