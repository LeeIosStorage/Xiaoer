//
//  XELocationServiceUtil.h
//  Xiaoer
//
//  Created by KID on 15/1/20.
//
//

#import <Foundation/Foundation.h>
@class CLLocation;
typedef void(^LocationBlock)(NSString *errorString);
typedef void(^LocationSucessBlock)(CLLocation *location);

@interface XELocationServiceUtil : NSObject

+(XELocationServiceUtil *) shareInstance;

//简单判断定位服务是否开启
+(BOOL) isLocationServiceOpen;

//获取用户地址
-(void) getUserCurrentLocation:(LocationBlock) block location:(LocationSucessBlock) locationSucess;

@end
