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
@property(nonatomic, strong) NSString* readNum;
@property(nonatomic, strong) NSString* favNum;
@property(nonatomic, strong) NSString* recipesImageUrl;
@property(nonatomic, strong) NSString* isTop;

@property(nonatomic, strong) NSString* jsonString;
@property(nonatomic, strong) NSDictionary* recipesInfoByJsonDic;

- (void)setRecipesInfoByDic:(NSDictionary*)dic;


@end
