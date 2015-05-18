//
//  CardOfEastVerifyController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/5/18.
//
//

#import "XESuperViewController.h"

@interface CardOfEastVerifyController : XESuperViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *infomationTab;
/**
 *  确认激活按钮
 */
@property (nonatomic,strong)UIButton *verifyBtn;

@end
