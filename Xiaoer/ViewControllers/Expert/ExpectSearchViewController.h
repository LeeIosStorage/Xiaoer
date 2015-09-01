//
//  ExpectSearchViewController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/8/29.
//
//

#import "XESuperViewController.h"

//平台切换宏
typedef enum {
    SearchTopic   = 0,    //话题
    SearchEcpect  = 1,    //专家
}SearchType;

@interface ExpectSearchViewController : XESuperViewController
@property (nonatomic,assign)SearchType searchType;
@end
