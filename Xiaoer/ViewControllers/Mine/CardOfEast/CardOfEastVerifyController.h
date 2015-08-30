//
//  CardOfEastVerifyController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/5/19.
//
//

#import "XESuperViewController.h"
#import "CardInfoVerifyCell.h"
#import "XEUserInfo.h"
#import "XECardInfo.h"
@interface CardOfEastVerifyController : XESuperViewController<UITableViewDataSource,UITableViewDelegate,cellTextFieldEndEditing>
/**
 *   展示的tableview
 */
@property (weak, nonatomic) IBOutlet UITableView *verifyTableView;
/**
 *  cell左边的填写信息提示
 */
@property (nonatomic,strong)NSMutableArray *leftLableTextArr;

@property (nonatomic,strong)XEUserInfo *userIn;
/**
 *  卡号
 */
@property (nonatomic,strong)NSString *cardNum;
/**
 *  密码
 */
@property(nonatomic,strong)NSString *passWord;
/**
 *   网络获取到的券号
 */
@property (nonatomic,strong)NSString *getCardNu;
/**
 *  网络获取到的密码
 */
@property (nonatomic,strong)NSString *getPassWor;

@property (nonatomic,strong)NSString *kabaoid;
@property (nonatomic,strong)XECardInfo *cardinfo;
@end
