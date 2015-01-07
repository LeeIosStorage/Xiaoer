//
//  RetrievePwdViewController.h
//  Xiaoer
//
//  Created by KID on 15/1/6.
//
//

#import "XESuperViewController.h"

typedef enum RETRIEVE_TYPE_
{
    TYPE_PHONE = 0,
    TYPE_EMAIL = 1,
}RETRIEVE_TYPE;

@interface RetrievePwdViewController : XESuperViewController

@property (nonatomic, assign) RETRIEVE_TYPE reType;

@end
