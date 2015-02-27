//
//  XEShare.h
//  Xiaoer
//
//  Created by KID on 15/2/27.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, PSShareType)
{
    PSShareNone,
    PSShareApp,       //应用
    PSShareWeb,       //网页
    PSShareText,      //文本
    PSShareImage,     //图片
    PSShareMusic,     //音乐
    PSShareVideo,     //视频
    PSShareOther,     //其他
    PSShareInvite     //邀请
};

@interface XEShare : NSObject

+ (void) UmengShare:(id)VC URL:(NSString *)URL IMG:(UIImage *)IMG Info:(NSString *)Info File:(NSString *)File Type:(PSShareType)Type;

+ (BOOL) socialShare:(id)VC shareType:(NSString *)shareType URL:(NSString *)URL IMG:(UIImage *)IMG Info:(NSString *)Info;

@end
