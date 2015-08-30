//
//  AddressManagerController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/23.
//
//

#import "XESuperViewController.h"
#import "XEAddressListInfo.h"

@protocol refreshAddtessInfoDelegate <NSObject>

- (void)refreshAddressInfoWith:(XEAddressListInfo *)info;

@end

@interface AddressManagerController : XESuperViewController
@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property (nonatomic,assign)BOOL ifCanDelete;
@property (nonatomic,assign)id<refreshAddtessInfoDelegate>delegate;
@property (nonatomic,strong)XEAddressListInfo *fromVerifyInfo;
@end
