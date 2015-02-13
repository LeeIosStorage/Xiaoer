//
//  XEMsgInfo.h
//  Xiaoer
//
//  Created by KID on 15/2/4.
//
//

#import <Foundation/Foundation.h>

@interface XEMsgInfo : NSObject

@property(nonatomic, strong) NSString* msgId;
@property(nonatomic, strong) NSString* userName;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, strong) NSDate* time;
@property(nonatomic, assign) BOOL isTop;  //是否置顶
@property(nonatomic, assign) BOOL readStatus; //读取状态

@property(nonatomic, readonly) NSString* detailsActionUrl;

@property(nonatomic, strong) NSString* jsonString;
@property(nonatomic, strong) NSDictionary* msgInfoByJsonDic;

@end
