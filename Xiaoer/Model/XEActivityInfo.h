//
//  XEActivityInfo.h
//  Xiaoer
//
//  Created by KID on 15/1/16.
//
//

#import <Foundation/Foundation.h>

@interface XEActivityInfo : NSObject

@property(nonatomic, strong) NSString* aId;
@property(nonatomic, strong) NSString* title;//标题
@property(nonatomic, strong) NSString* address;
@property(nonatomic, strong) NSDate* begintime;
@property(nonatomic, strong) NSDate* endtime;
@property(nonatomic, assign) int totalnum;
@property(nonatomic, assign) int status;
@property(nonatomic, assign) BOOL istop;

@property(nonatomic, strong) NSString* jsonString;
@property(nonatomic, strong) NSDictionary* activityInfoByJsonDic;

@end
