//
//  AddressInfoManager.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/8.
//
//

#import "AddressInfoManager.h"

@interface AddressInfoManager  ()
//@property (nonatomic,strong)XEAddressListInfo *info;

@property (nonatomic,strong)NSMutableArray *infoArray;

@end

@implementation AddressInfoManager

//- (XEAddressListInfo *)info{
//    if (!_info) {
//        if ([[NSFileManager defaultManager] fileExistsAtPath:[self filePath]]) {
//            //反归档
//            //通过解档类解档对应路径的文件
//            self.infoArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
//        }else{
//            self.infoArray =[NSMutableArray array];
//        }
//    }
//    return _info;
//}
- (NSMutableArray *)infoArray{
    if (!_infoArray) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self filePath]]) {
            //反归档
            //通过解档类解档对应路径的文件
            self.infoArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
        }else{
            self.infoArray =[NSMutableArray array];
        }
    
    }
    return _infoArray;
}
//创建单例

+(id)manager{
    static  AddressInfoManager *manager=nil;
    if (manager==nil) {
        manager=[[AddressInfoManager alloc]init];
    }
    return manager;
}


- (NSMutableArray *)getTheInfoArray{
    return self.infoArray;
}
- (XEAddressListInfo *)getTheAddressInfoWith:(NSString *)userID{
    for (NSDictionary *dic in  self.infoArray) {
        if (dic[userID]) {
            return dic[userID];
        }
    }
    return nil;
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
- (void)addDictionaryWith:(XEAddressListInfo *)info With:(NSString *)userID{
    [self ifIncludeInfo:info andKey:userID];
    
}
- (void)ifIncludeInfo:(XEAddressListInfo *)info andKey:(NSString *)userID{
    if (self.infoArray) {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:info forKey:userID];
    [self.infoArray addObject:dic];
    [[AddressInfoManager manager]save];
    }
}

- (NSString *)filePath{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSLog(@"默认地址 ： %@",[documentPath  stringByAppendingPathComponent:@"AddressManagers.arc"]);
    return  [documentPath  stringByAppendingPathComponent:@"AddressManagers.arc"];//返回归档文件的存储有路径的方法
}
- (void)save{
    //1.使用归档类中的方法，直接将对象归档到指定路径
    [NSKeyedArchiver archiveRootObject:self.infoArray toFile:[self filePath]];
}

- (void)deleteTheDictionaryWith:(NSString *)userId{
    if (self.infoArray) {
        for (NSDictionary *dic in self.infoArray) {
            if (dic[userId]) {
                [self.infoArray removeObject:dic];
            }
        }
    }

    
    [[AddressInfoManager manager]save];

}

- (void)deleteFile{
    //删除归档文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:self.filePath]) {
        [defaultManager removeItemAtPath:self.filePath error:nil];
    }
}

@end
