//
//  XEAppHospital.h
//  Xiaoer
//
//  Created by 王鹏 on 15/9/7.
//
//

#import <Foundation/Foundation.h>
@interface XEAppHospital : NSObject
/**
 *  医院id
 */
@property (nonatomic,strong)NSString *id;
/**
 *  子科室
 */
@property (nonatomic,strong)NSArray *hospitalDepartments;
/**
 *  医院简介
 */
@property (nonatomic,strong)NSString *intro;
/**
 *  医院名称
 */
@property (nonatomic,strong)NSString *name;


@property (nonatomic,strong)NSArray *subHospital;

@end
