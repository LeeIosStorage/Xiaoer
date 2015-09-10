//
//  XEAppSubHospital.h
//
//  Created by 王鹏 on 15/9/7.
//
//

#import <Foundation/Foundation.h>

@interface XEAppSubHospital : NSObject
@property (nonatomic,strong)NSString *imgUrl;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *hospitalId;
@property (nonatomic,strong)NSString *des;
@property (nonatomic,strong)NSString *intro;
@property (nonatomic,strong)NSString *name;

@property (nonatomic,strong)NSURL *totalImageUrl;
@end
