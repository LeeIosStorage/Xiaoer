//
//  XEActivityInfo.h
//  Xiaoer
//
//  Created by KID on 15/1/16.
//
//

#import <Foundation/Foundation.h>

@interface XEActivityInfo : NSObject

@property(nonatomic, strong) NSString* aId;
@property(nonatomic, strong) NSString* title;//标题
@property(nonatomic, strong) NSString* address;
@property(nonatomic, assign) float latitude;
@property(nonatomic, assign) float longitude;
@property(nonatomic, strong) NSString* des;//描述
@property(nonatomic, strong) NSString* contact;//联系人
@property(nonatomic, strong) NSString* phone;//联系人电话
@property(nonatomic, strong) NSURL* picUrl;
@property(nonatomic, strong) NSMutableArray *picIds;
@property(nonatomic, readonly) NSArray* picURLs;
@property(nonatomic, strong) NSDate* begintime;
@property(nonatomic, strong) NSDate* endtime;
@property(nonatomic, assign) int totalnum;//活动总人数
@property(nonatomic, assign) int regnum;//已参加人数
@property(nonatomic, assign) int minnum;//最少报名人数
@property(nonatomic, assign) int status;//活动状态 0未发布 1报名未开始 2可报名 3已报名 4已报满  5已截止 6已结束
@property(nonatomic, assign) BOOL istop;//是否置顶
@property(nonatomic, assign) int faved;//0为收藏 1已收藏
@property(nonatomic, assign) int aType;//0报名活动 1抢票活动(status//0未发布 1报名未开始 2可抢 3已抢 4抢满  5抢票截止)
@property(nonatomic, strong) NSString* regcode;//抢票码
@property(nonatomic, assign) int startsecond;//报名倒计时
@property(nonatomic, assign) int endsecond;//结束倒计时

@property(nonatomic, strong) NSString* jsonString;
@property(nonatomic, strong) NSDictionary* activityInfoByJsonDic;

@end
