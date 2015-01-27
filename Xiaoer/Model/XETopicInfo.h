//
//  XETopicInfo.h
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import <Foundation/Foundation.h>

@interface XETopicInfo : NSObject

@property(nonatomic, strong) NSString* tId;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, strong) NSString* avatar;
@property(nonatomic, assign) int clicknum;
@property(nonatomic, assign) int favnum;
@property(nonatomic, assign) int commentnum;
@property(nonatomic, strong) NSString* uname;
@property(nonatomic, strong) NSString* utitle;
@property(nonatomic, assign) BOOL isTop;
@property(nonatomic, strong) NSString* dateString;

@property(nonatomic, strong) NSString* jsonString;
@property(nonatomic, strong) NSDictionary* topicInfoByJsonDic;

@end
