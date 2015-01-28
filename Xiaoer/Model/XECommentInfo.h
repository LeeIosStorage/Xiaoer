//
//  XECommentInfo.h
//  Xiaoer
//
//  Created by KID on 15/1/27.
//
//

#import <Foundation/Foundation.h>

@interface XECommentInfo : NSObject

@property(nonatomic, strong) NSString* cId;
@property(nonatomic, strong) NSString* uId;
@property(nonatomic, strong) NSString* content;
@property(nonatomic, strong) NSString* userName;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, strong) NSString* avatar;
@property(nonatomic, strong) NSDate* time;
@property(nonatomic, readonly) NSURL* smallAvatarUrl;

@property(nonatomic, strong) NSString* jsonString;
@property(nonatomic, strong) NSDictionary* commentInfoByJsonDic;

@end
