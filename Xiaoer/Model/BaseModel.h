//
//  BaseModel.h
//  Xiaoer
//
//  Created by 王鹏 on 15/5/21.
//
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (id)modelWithDictioanry:(NSDictionary *)dictionary;
@end
