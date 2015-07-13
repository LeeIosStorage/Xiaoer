//
//  AddAddressViewController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/21.
//
//
#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2
#import "XESuperViewController.h"
#import "XEAddressListInfo.h"
@interface AddAddressViewController : XESuperViewController<UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIButton *button;
    NSArray *city;
    NSArray *district;
    NSString *selectedProvince;
}

@property (weak, nonatomic) IBOutlet UITableView *addAddressTab;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIPickerView *dataPicker;

@property (weak, nonatomic) IBOutlet UIView *chooseDataView;
@property (nonatomic,strong)NSString *chooseedAddRess;

@property (weak, nonatomic) IBOutlet UIButton *setCommonAddress;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (nonatomic,strong)XEAddressListInfo *info;
//是否可以删除默认的地址
@property (nonatomic,assign)BOOL ifCanDelete;
@end
