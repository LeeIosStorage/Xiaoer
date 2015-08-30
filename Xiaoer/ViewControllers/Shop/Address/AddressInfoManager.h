//
//  AddressInfoManager.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/8.
//
//

#import <Foundation/Foundation.h>
#import "XEAddressListInfo.h"

@interface AddressInfoManager : NSObject
//单例方法
- (void)deleteTheInfo;
- (NSInteger)returnTheCountOfInfo;
- (void)addDictionaryWith:(XEAddressListInfo *)info
                     With:(NSString *)userID;
+(id)manager;
- (NSString *)filePath;
- (XEAddressListInfo *)getTheAddressInfoWith:(NSString *)userID;
-(void)save;

- (void)deleteTheDictionaryWith:(NSString *)userId;
- (void)deleteFile;

@end
