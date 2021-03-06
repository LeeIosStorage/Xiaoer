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
@property(nonatomic, strong) NSString* uId;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, strong) NSString* avatar;
@property(nonatomic, assign) int cat; //1教育2营养3入园4心理
@property(nonatomic, assign) int clicknum;
@property(nonatomic, assign) int favnum;
@property(nonatomic, assign) int commentnum;
@property(nonatomic, strong) NSString* uname;
@property(nonatomic, strong) NSString* utitle;
@property(nonatomic, assign) BOOL isTop;
@property(nonatomic, strong) NSDate* time;
@property(nonatomic, assign) int imgnum;//话题包含图片的数量
@property(nonatomic, assign) BOOL isRec;//热门
@property(nonatomic, strong) NSString *thumbnail;//热门话题图片

@property(nonatomic, strong) NSString* content;
@property(nonatomic, strong) NSString* userName;
@property(nonatomic, readonly) NSURL* smallAvatarUrl;
@property(nonatomic, readonly) NSURL* thumbnailUrl;

@property(nonatomic, assign) int faved;
@property(nonatomic, strong) NSMutableArray *picIds;
@property(nonatomic, readonly) NSArray* picURLs;
@property(nonatomic, readonly) NSArray* originalPicURLs;

@property(nonatomic, strong) NSString* jsonString;
@property(nonatomic, strong) NSDictionary* topicInfoByJsonDic;

@end
