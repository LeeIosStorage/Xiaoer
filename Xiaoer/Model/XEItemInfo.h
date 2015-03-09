//
//  XEItemInfo.h
//  xiaoer
//
//  Created by KID on 15/3/9.
//
//

#import <Foundation/Foundation.h>

@interface XEItemInfo : NSObject

@property(nonatomic, strong) NSString* imgurl;
@property(nonatomic, strong) NSString* mallurl;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, assign) BOOL purchase;
@property(nonatomic, readonly) NSURL* imageUrl;

@property(nonatomic, strong) NSDictionary* itemInfoByJsonDic;

@end
