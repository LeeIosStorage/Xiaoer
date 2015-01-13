//
//  XEUserInfo.h
//  Xiaoer
//
//  Created by KID on 14/12/31.
//
//

#import <Foundation/Foundation.h>

@interface XEUserInfo : NSObject

@property(nonatomic, strong) NSString* uid;

@property(nonatomic, strong) NSString* nickName;
@property(nonatomic, strong) NSString* gender;
@property(nonatomic, strong) NSString* region;
@property(nonatomic, strong) NSString* address;//
@property(nonatomic, strong) NSString* phone;//
@property(nonatomic, strong) NSString* avatarId;
//暂时用下
@property(nonatomic, strong) NSString* avatar;
@property(nonatomic, strong) NSString* password;

@property(nonatomic, strong) NSString* account;
@property(nonatomic, strong) NSString* district;
@property(nonatomic, strong) NSString* email;
@property(nonatomic, assign) int fansNum;
@property(nonatomic, assign) int isExpert;
@property(nonatomic, strong) NSDate* modifyTime;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSDate* registerTime;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, assign) int topicNum;

//baby
@property(nonatomic, strong) NSString* babyNick;
@property(nonatomic, strong) NSString* babyAvatarId;
@property(nonatomic, strong) NSString* babyGender;
@property(nonatomic, strong) NSDate* birthdayDate;
@property(nonatomic, strong) NSString* birthdayString;

@property(nonatomic, readonly) NSURL* smallAvatarUrl;
@property(nonatomic, readonly) NSURL* mediumAvatarUrl;
@property(nonatomic, readonly) NSURL* largeAvatarUrl;
@property(nonatomic, readonly) NSURL* originalAvatarUrl;
@property(nonatomic, readonly) NSURL* backgroudImageUrl;

@property(nonatomic, strong) NSDictionary* userInfoByJsonDic;
@property(nonatomic, strong) NSString* jsonString;

+ (NSString*)getBirthdayByDate:(NSDate*)date;

@end
