//
//  BaseModel.m
//  Xiaoer
//
//  Created by 王鹏 on 15/5/21.
//
//

#import "BaseModel.h"

@implementation BaseModel
- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        
    }
    return self;
}
//便利构造器方法，子类继承的时候使用这个便来构造器可以构造子类的对象，再这里需要使用的是动态创建，否则子类再使用的时候创建的父类额对对象，不是则子类本身。
+ (id)modelWithDictioanry:(NSDictionary *)dictionary {
    return [[[self class]alloc]initWithDictionary:dictionary];
}
@end
