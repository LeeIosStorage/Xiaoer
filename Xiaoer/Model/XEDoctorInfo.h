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
@property(nonatomic, strong) NSString* hospital;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, strong) NSString* professional;//擅长领域
@property(nonatomic, strong) NSString* des;
@property(nonatomic, strong) NSString* avatar;
@property(nonatomic, assign) int age;
@property(nonatomic, assign) int topicnum;
@property(nonatomic, assign) int favnum;
@property(nonatomic, assign) int popularscore;//人气值
@property(nonatomic, assign) int faved;//0未收藏 1已收藏

@property(nonatomic, readonly) NSURL* smallAvatarUrl;
@property(nonatomic, readonly) NSURL* mediumAvatarUrl;
@property(nonatomic, readonly) NSURL* largeAvatarUrl;

@property(nonatomic, strong) NSString* jsonString;
@property(nonatomic, strong) NSDictionary* doctorInfoByJsonDic;

@end
