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
@property(nonatomic, strong) NSString* address;
@property(nonatomic, strong) NSString* phone;
@property(nonatomic, strong) NSString* avatarId;

//baby
@property(nonatomic, strong) NSString* babyNick;
@property(nonatomic, strong) NSString* babyAvatarId;
@property(nonatomic, strong) NSString* babyGender;
@property(nonatomic, strong) NSDate* birthdayDate;
@property(nonatomic, strong) NSString* birthdayString;


@property(nonatomic, strong) NSDictionary* userInfoByJsonDic;
@property(nonatomic, strong) NSString* jsonString;

@end
