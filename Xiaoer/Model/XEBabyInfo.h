//
//  XEBabyInfo.h
//  xiaoer
//
//  Created by KID on 15/3/6.
//
//

#import <Foundation/Foundation.h>

@interface XEBabyInfo : NSObject

@property(nonatomic, strong) NSString* babyId;      //宝宝Id
@property(nonatomic, strong) NSString* babyName;    //宝宝名称
@property(nonatomic, strong) NSString* img;         //当前关键期的介绍图片
@property(nonatomic, strong) NSString* preimg;      //前一个关键期的介绍图片
@property(nonatomic, strong) NSString* afterimg;    //下一个关键期的介绍图片
@property(nonatomic, strong) NSString* month;       //宝宝的月龄
@property(nonatomic, strong) NSString* avatar;      //宝宝的头像
@property(nonatomic, strong) NSString* content;     //当前关键期的文字介绍
@property(nonatomic, strong) NSString* precontent;  //前一个关键期的文字介绍
@property(nonatomic, strong) NSString* aftercontent;//下一个关键期的文字介绍
@property(nonatomic, assign) int stage;             //宝宝当前的关键期
@property(nonatomic, assign) int preday;            //超过上个关键期天数
@property(nonatomic, assign) int afterday;          //距离下个关键期的天数

@property(nonatomic, readonly) NSURL* smallAvatarUrl;
@property(nonatomic, readonly) NSURL* originalAvatarUrl;
@property(nonatomic, readonly) NSURL* mediumAvatarUrl;
@property(nonatomic, readonly) NSURL* largeAvatarUrl;
@property(nonatomic, readonly) NSURL* imgUrl;
@property(nonatomic, readonly) NSURL* preimgUrl;
@property(nonatomic, readonly) NSURL* afterimgUrl;

@property(nonatomic, strong) NSDictionary* babyInfoByJsonDic;

@end
