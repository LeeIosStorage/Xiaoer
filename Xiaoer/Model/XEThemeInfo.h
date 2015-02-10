//
//  XEThemeInfo.h
//  Xiaoer
//
//  Created by KID on 15/1/14.
//
//

#import <Foundation/Foundation.h>

@interface XEThemeInfo : NSObject

@property(nonatomic, strong) NSString* tid;
@property(nonatomic, strong) NSString* themeImageUrl;
@property(nonatomic, strong) NSString* cat;

@property(nonatomic, strong) NSString* jsonString;
@property(nonatomic, strong) NSDictionary* themeInfoByJsonDic;

@property(nonatomic, strong) NSString* themeActionUrl;

@property(nonatomic, readonly) NSString* smallThemeImageUrl;
@property(nonatomic, readonly) NSString* mediumThemeImageUrl;
@property(nonatomic, readonly) NSString* largeThemeImageUrl;
@property(nonatomic, readonly) NSString* originalThemeImageUrl;

- (void)setThemeInfoByDic:(NSDictionary*)dic;

+ (NSString*)getThemeImageUrlWithUrl:(NSString*)url size:(int)size;

- (NSString*)getSmallThemeImageUrl;
- (NSString*)getMediumThemeImageUrl;
- (NSString*)getLargeThemeImageUrl;

@end
