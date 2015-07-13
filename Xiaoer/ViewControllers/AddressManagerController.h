//
//  AddressManagerController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/23.
//
//

#import "XESuperViewController.h"

@interface AddressManagerController : XESuperViewController
@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property (nonatomic,assign)BOOL ifCanDelete;
@end
