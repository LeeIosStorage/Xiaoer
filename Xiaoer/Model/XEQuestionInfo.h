//
//  XEQuestionInfo.h
//  Xiaoer
//
//  Created by KID on 15/1/26.
//
//

#import <Foundation/Foundation.h>

@interface XEQuestionInfo : NSObject

@property(nonatomic, strong) NSString* sId;
@property(nonatomic, strong) NSString* uId;
@property(nonatomic, strong) NSString* userName;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, assign) int clicknum;
@property(nonatomic, assign) int favnum;
@property(nonatomic, assign) int status;//1:未回答2:已回答3:被驳回
@property(nonatomic, strong) NSString* avatar;
@property(nonatomic, strong) NSString* utitle;

@property(nonatomic, strong) NSString* expertName;
@property(nonatomic, strong) NSString* content;
@property(nonatomic, strong) NSDate* beginTime;
@property(nonatomic, assign) int faved;
@property(nonatomic, strong) NSMutableArray *picIds;
@property(nonatomic, readonly) NSArray* picURLs;
@property(nonatomic, readonly) NSArray* originalPicURLs;
@property(nonatomic, readonly) NSURL* smallAvatarUrl;

@property(nonatomic, strong) NSString* jsonString;
@property(nonatomic, strong) NSDictionary* questionInfoByJsonDic;

@end
