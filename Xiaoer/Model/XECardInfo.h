//
//  XECardInfo.h
//  Xiaoer
//
//  Created by KID on 15/2/3.
//
//

#import <Foundation/Foundation.h>

@interface XECardInfo : NSObject

@property(nonatomic, strong) NSString* cid;
@property(nonatomic, strong) NSString* img;
@property(nonatomic, strong) NSString* des;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, strong) NSString* price;
@property(nonatomic, assign) int leftNum;
@property(nonatomic, assign) int status;
@property(nonatomic, readonly) NSString* cardActionUrl;

@property(nonatomic, strong) NSString* jsonString;
@property(nonatomic, strong) NSDictionary* cardInfoByJsonDic;

@end