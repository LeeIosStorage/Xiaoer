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

@property(nonatomic, strong) NSString* jsonString;
@property(nonatomic, strong) NSDictionary* topicInfoByJsonDic;

@end