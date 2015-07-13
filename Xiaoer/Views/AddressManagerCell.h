//
//  AddressManagerCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/23.
//
//

#import <UIKit/UIKit.h>
#import "XEAddressListInfo.h"
@protocol AddressManagerCellDelegate <NSObject>

-(void)touchedIndexOfCell:(NSInteger)index;

@end


@interface AddressManagerCell : UITableViewCell
/**
 *  收货人
 */
@property (weak, nonatomic) IBOutlet UITextField *consignee;
/**
 *  手机号码
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
/**
 *  收货地址
 */
@property (weak, nonatomic) IBOutlet UITextField *addRess;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;


@property (nonatomic,assign)id<AddressManagerCellDelegate>delegate;

- (void)configureCellWith:(NSIndexPath *)indexPath
                     info:(XEAddressListInfo *)info;
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)UITableViewCell *cell;

@end
