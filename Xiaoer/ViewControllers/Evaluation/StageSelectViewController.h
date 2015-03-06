//
//  StageSelectViewController.h
//  Xiaoer
//
//  Created by KID on 15/2/28.
//
//

#import "XESuperViewController.h"

typedef enum VcType_{
    VcType_ALL = 0,    //全部历史评测
    VcType_ONE_KEY,    //某一关键期历史评测
}VcType;

@interface StageSelectViewController : XESuperViewController

@property (nonatomic, assign) VcType vcType;
@property (nonatomic, strong) NSString *keyString;
@property (nonatomic, strong) NSString *stage;

@end
