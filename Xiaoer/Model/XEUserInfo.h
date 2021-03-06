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
@property(nonatomic, strong) NSString* regionName;
@property(nonatomic, strong) NSString* address;//
@property(nonatomic, strong) NSString* phone;//
@property(nonatomic, strong) NSString* bgImgId;
@property(nonatomic, readonly) NSURL* bgImgUrl;
@property(nonatomic, strong) NSString* avatar;
@property(nonatomic, strong) NSString* password;

@property(nonatomic, strong) NSString* account;
@property(nonatomic, strong) NSString* district;
@property(nonatomic, strong) NSString* email;
@property(nonatomic, assign) int fansNum;
@property(nonatomic, assign) int isExpert;
@property(nonatomic, strong) NSDate* modifyTime;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSString* desc;
@property(nonatomic, strong) NSDate* registerTime;
@property(nonatomic, strong) NSString* title;//身份
@property(nonatomic, strong) NSString* hasbaby;//n表示怀孕中,y表示已有宝宝
@property(nonatomic, strong) NSDate* dueDate;//预产期
@property(nonatomic, strong) NSString* dueDateString;//预产期
@property(nonatomic, strong) NSString* hospital;//产检医院
@property(nonatomic, assign) int topicNum;
@property(nonatomic, assign) int profileStatus;

@property(nonatomic, strong) NSMutableArray *babys;
//baby
@property(nonatomic, strong) NSString* babyId;
@property(nonatomic, strong) NSString* babyNick;
@property(nonatomic, strong) NSString* babyAvatarId;
//@property(nonatomic, strong) NSString* babyAvatar;
@property(nonatomic, readonly) NSURL* babySmallAvatarUrl;
@property(nonatomic, strong) NSString* babyGender;
@property(nonatomic, assign) int babyMonth;
@property(nonatomic, assign) int stage;
@property(nonatomic, assign) int acquiesce;//0是默认宝宝
@property(nonatomic, strong) NSDate* birthdayDate;
@property(nonatomic, strong) NSString* birthdayString;

//@property(nonatomic, strong) NSDictionary* userAndBabyInfoByJsonDic;

@property(nonatomic, readonly) NSURL* smallAvatarUrl;
@property(nonatomic, readonly) NSURL* mediumAvatarUrl;
@property(nonatomic, readonly) NSURL* largeAvatarUrl;
@property(nonatomic, readonly) NSURL* originalAvatarUrl;
@property(nonatomic, readonly) NSURL* backgroudImageUrl;
@property (nonatomic,strong)NSString *bphone;

@property(nonatomic, strong) NSDictionary* userInfoByJsonDic;
@property(nonatomic, strong) NSString* jsonString;

@property (nonatomic,strong)NSString *lovePoint;

#pragma mark

+ (NSString*)getBirthdayByDate:(NSDate*)date;

+ (NSString*)getAvatarUrlWithAvatar:(NSString*)avatar size:(int)size;

- (NSString*)getSmallAvatarUrl;
- (NSString*)getMediumAvatarUrl;
- (NSString*)getlargeAvatarUrl;

@end
