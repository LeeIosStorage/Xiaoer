//
//  XESettingConfig.h
//  Xiaoer
//
//  Created by KID on 15/1/8.
//
//

#import <Foundation/Foundation.h>

@interface XESettingConfig : NSObject<NSCoding>

//系统相机闪光灯状态
@property (nonatomic, assign) int systemCameraFlashStatus;

+(XESettingConfig *)staticInstance;

+ (void)logout;
- (void)login;

-(void)saveSettingCfg;
-(void)setUserCfg:(NSDictionary*)dict;

+(void)saveEnterVersion;
+(BOOL)isFirstEnterVersion;

+(void)saveEnterUsr;

@end
