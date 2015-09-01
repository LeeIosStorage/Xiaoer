//
//  ExpextPublicController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/9/1.
//
//
typedef enum PublicTy{
    publicTopic = 0,  //发话题
    publicExpert,     //问专家
}PublicTy;
#define MAX_IMAGES_NUM 9
#import "XESuperViewController.h"
#import "XEDoctorInfo.h"
@interface ExpextPublicController : XESuperViewController
@property (nonatomic,assign)PublicTy publicType;
@property (nonatomic, strong) XEDoctorInfo *doctorInfo;
@end
