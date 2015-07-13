//
//  AddressInfoManager.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/8.
//
//

#import "AddressInfoManager.h"

@interface AddressInfoManager  ()
@property (nonatomic,strong)XEAddressListInfo *info;

@end

@implementation AddressInfoManager

- (XEAddressListInfo *)info{
    if (!_info) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self filePath]]) {
            //反归档
            //通过解档类解档对应路径的文件
            self.info = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
        }else{
            self.info =[[XEAddressListInfo alloc]init];
        }
    }
    return _info;
}

//创建单例

+(id)manager{
    static  AddressInfoManager *manager=nil;
    if (manager==nil) {
        manager=[[AddressInfoManager alloc]init];
    }
    return manager;
}

-(XEAddressListInfo *)getTheDictionary{
    return self.info;
}

-(XEAddressListInfo *)getTheDictionaryWithBenDi{
    
    //根据文件路径，读取data
    NSData *data = [NSData dataWithContentsOfFile:[self filePath]];
    //将NSData通过反归档，转化成Model对象
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    //通过反归档得到复杂对象
    XEAddressListInfo  *info = [unarchiver decodeObjectForKey:@"name"];
    [unarchiver finishDecoding];
    return info;
}
- (void)addDictionaryWith:(XEAddressListInfo *)info{
    [self ifIncludeInfo:info];
    
}

- (void)ifIncludeInfo:(XEAddressListInfo *)info{
    if (self.info) {
        if ([self.info isEqual:info]) {
            
        }else{
            self.info = info;
        }
    }
    [[AddressInfoManager manager]save];

}
- (NSString *)filePath{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSLog(@"默认地址 ： %@",[documentPath  stringByAppendingPathComponent:@"AddressManager.arc"]);
    return  [documentPath  stringByAppendingPathComponent:@"AddressManager.arc"];//返回归档文件的存储有路径的方法
}
- (void)save{
    //1.使用归档类中的方法，直接将对象归档到指定路径
    [NSKeyedArchiver archiveRootObject:self.info toFile:[self filePath]];
}
- (void)deleteTheDictionary{
    self.info = nil;
    [self deleteFile];
}
- (void)deleteFile{
    //删除归档文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:self.filePath]) {
        [defaultManager removeItemAtPath:self.filePath error:nil];
    }
}

@end
