//
//  XETrainInfo.h
//  xiaoer
//
//  Created by KID on 15/3/13.
//
//

#import <Foundation/Foundation.h>

@interface XETrainInfo : NSObject

@property (strong, nonatomic) NSString *cat;
@property (strong, nonatomic) NSString *catType;
@property (strong, nonatomic) NSString *babyId;
@property (strong, nonatomic) NSString *score;
@property (strong, nonatomic) NSString *scoreTitle;
@property (strong, nonatomic) NSString *stage;

@property (strong, nonatomic) NSMutableArray *resultsInfo;

@property(nonatomic, strong) NSDictionary* trainInfoByJsonDic;

@end
