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
@property(nonatomic, strong) NSString* title;
@property(nonatomic, assign) int clicknum;
@property(nonatomic, assign) int favnum;
@property(nonatomic, assign) int status;

@property(nonatomic, strong) NSString* jsonString;
@property(nonatomic, strong) NSDictionary* questionInfoByJsonDic;

@end
