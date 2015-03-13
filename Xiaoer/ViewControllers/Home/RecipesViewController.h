//
//  RecipesViewController.h
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import "XESuperViewController.h"

typedef enum INFO_TYPE
{
    TYPE_RECIPES = 1,     //食谱
    TYPE_NOURISH = 2,     //养育
    TYPE_EVALUATION = 3,  //测评
    TYPE_ACTIVITY = 4,    //活动
    TYPE_ATTENTION,       //注意力
    TYPE_HABIT,           //好习惯
}INFO_TYPE;

@interface RecipesViewController : XESuperViewController

@property (nonatomic, assign) INFO_TYPE infoType;
@property (nonatomic, assign) int stage;
@property (nonatomic, assign) BOOL bSpecific;

@end
