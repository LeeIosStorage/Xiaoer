//
//  CardOfEastSucceedController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/5/19.
//
//

#import "XESuperViewController.h"
#import "XECardInfo.h"
@interface CardOfEastSucceedController : XESuperViewController
@property (weak, nonatomic) IBOutlet UILabel *cardNum;
@property (weak, nonatomic) IBOutlet UILabel *cardPassWord;
@property (nonatomic,strong)NSString *eno;
@property (nonatomic,strong)NSString *ekey;
@property (nonatomic,strong)NSString *kabaoid;
@property (nonatomic,strong)XECardInfo *cardinfo;
@end
