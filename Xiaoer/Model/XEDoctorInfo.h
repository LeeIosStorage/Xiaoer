//
//  XEDoctorInfo.h
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import <Foundation/Foundation.h>

@interface XEDoctorInfo : NSObject

@property(nonatomic, strong) NSString* doctorId;
@property(nonatomic, strong) NSString* doctorName;

@property(nonatomic, strong) NSString* jsonString;
@property(nonatomic, strong) NSDictionary* doctorInfoByJsonDic;

@end
