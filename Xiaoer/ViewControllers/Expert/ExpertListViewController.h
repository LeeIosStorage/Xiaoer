//
//  ExpertListViewController.h
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import "XESuperViewController.h"

typedef enum ExpertVcType_{
    VcType_Expert = 0,  //专家
    VcType_Nurser       //育婴师
}ExpertVcType;

@interface ExpertListViewController : XESuperViewController

@property (nonatomic, assign) ExpertVcType vcType;
@property (nonatomic, assign) BOOL isNeedSelect;

@end
