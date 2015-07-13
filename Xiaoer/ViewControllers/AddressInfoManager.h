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
- (void)addDictionaryWith:(XEAddressListInfo *)info;
+(id)manager;
-(XEAddressListInfo *)getTheDictionary;
-(XEAddressListInfo *)getTheDictionaryWithBenDi;
- (NSString *)filePath;

-(void)save;

- (void)deleteTheDictionary;
- (void)deleteFile;

@end
