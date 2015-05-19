//
//  CardOfEastVerifyController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/5/19.
//
//

#import "XESuperViewController.h"

@interface CardOfEastVerifyController : XESuperViewController<UITableViewDataSource,UITableViewDelegate>
/**
 *   展示的tableview
 */
@property (weak, nonatomic) IBOutlet UITableView *verifyTableView;
/**
 *  cell左边的填写信息提示
 */
@property (nonatomic,strong)NSMutableArray *leftLableTextArr;
@end
