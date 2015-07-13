//
//  XEAddressListInfo.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/7.
//
//

#import "XEAddressListInfo.h"

@implementation XEAddressListInfo
//先写编码，后写解码
//编码协议
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.provinceId forKey:@"provinceId"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.cityId forKey:@"cityId"];
    [aCoder encodeObject:self.tel forKey:@"tel"];
    [aCoder encodeObject:self.cityName forKey:@"cityName"];
    [aCoder encodeObject:self.provinceName forKey:@"provinceName"];
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.districtName forKey:@"districtName"];
    [aCoder encodeObject:self.districtId forKey:@"districtId"];
    [aCoder encodeObject:self.def forKey:@"def"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.name forKey:@"name"];


    
}
//解码协议
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self) {
        self.provinceId = [aDecoder decodeObjectForKey:@"provinceId"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.cityId = [aDecoder decodeObjectForKey:@"cityId"];
        self.tel = [aDecoder decodeObjectForKey:@"tel"];
        self.cityName = [aDecoder decodeObjectForKey:@"cityName"];
        self.provinceName = [aDecoder decodeObjectForKey:@"provinceName"];
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.districtName = [aDecoder decodeObjectForKey:@"districtName"];
        self.districtId = [aDecoder decodeObjectForKey:@"districtId"];
        self.def = [aDecoder decodeObjectForKey:@"def"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.name = [aDecoder decodeObjectForKey:@"name"];

    }
    return self;
    
}
@end
