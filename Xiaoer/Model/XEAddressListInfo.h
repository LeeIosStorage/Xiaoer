//
//  XEAddressListInfo.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/7.
//
//

#import <Foundation/Foundation.h>

@interface XEAddressListInfo : NSObject<NSCoding>
//区域中省的id
@property (nonatomic,strong)NSString *provinceId;
//收货人手机号码
@property (nonatomic,strong)NSString *phone;
//区域中市的id
@property (nonatomic,strong)NSString *cityId;
//电话号码
@property (nonatomic,strong)NSString *tel;
//城市名字
@property (nonatomic,strong)NSString *cityName;
//省名字
@property (nonatomic,strong)NSString *provinceName;

@property (nonatomic,strong)NSString *id;
//区名
@property (nonatomic,strong)NSString *districtName;
//区的ID
@property (nonatomic,strong)NSString *districtId;
//是否设为默认收货地址 1 是
@property (nonatomic,strong)NSString *def;
//收货人地址
@property (nonatomic,strong)NSString *address;

@property (nonatomic,strong)NSString *userId;
//收货人姓名
@property (nonatomic,strong)NSString *name;

@end
