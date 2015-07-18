//
//  OrderApplyReimburseController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/3.
//
//

#import "XESuperViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UzysAssetsPickerController.h"

#import "XEOrderInfo.h"

#import "XEOrderDetailInfo.h"


@protocol refreshDataDelegate <NSObject>

- (void)sucessRefreshData;

@end

@interface OrderApplyReimburseController : XESuperViewController<UIPickerViewDelegate,UIPickerViewDataSource,UzysAssetsPickerControllerDelegate>
@property (nonatomic,assign)id<refreshDataDelegate>delegate;

@property (nonatomic,strong)XEOrderInfo *order;

@property (nonatomic,strong)XEOrderDetailInfo *detailInfo;
@end
