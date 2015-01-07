//
//  LoginViewController.h
//  Xiaoer
//
//  Created by KID on 15/1/5.
//
//

#import "XESuperViewController.h"

typedef enum VcType_{
    VcType_Login = 0,  //登陆
    VcType_Register,   //注册
}VcType;

@interface LoginViewController : XESuperViewController

@property (nonatomic, assign) VcType vcType;

@end
