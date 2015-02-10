//
//  XERecipesInfo.h
//  Xiaoer
//
//  Created by KID on 15/1/16.
//
//

#import <Foundation/Foundation.h>

@interface XERecipesInfo : NSObject

@property(nonatomic, strong) NSString* rid;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, assign) int readNum;
@property(nonatomic, assign) int favNum;
@property(nonatomic, strong) NSString* recipesImageUrl;
@property(nonatomic, assign) BOOL isTop;

@property(nonatomic, readonly) NSString* recipesActionUrl;
@property(nonatomic, readonly) NSURL* smallRecipesImageUrl;
@property(nonatomic, readonly) NSURL* mediumRecipesImageUrl;
@property(nonatomic, readonly) NSURL* largeRecipesImageUrl;
@property(nonatomic, readonly) NSURL* originalRecipesImageUrl;

@property(nonatomic, strong) NSString* jsonString;
@property(nonatomic, strong) NSDictionary* recipesInfoByJsonDic;

- (void)setRecipesInfoByDic:(NSDictionary*)dic;

//+ (NSString*)getRecipesImageUrlWithUrl:(NSString*)url size:(int)size;

- (NSString*)getSmallRecipesImageUrl;
- (NSString*)getMediumRecipesImageUrl;
- (NSString*)getLargeRecipesImageUrl;


@end
