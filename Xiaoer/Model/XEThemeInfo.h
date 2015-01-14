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
@property(nonatomic, strong) NSString* url;
@property(nonatomic, strong) NSString* cat;

@property(nonatomic, strong) NSString* jsonString;
@property(nonatomic, strong) NSDictionary* themeInfoByJsonDic;

- (void)setThemeInfoByDic:(NSDictionary*)dic;

@end
