//
//  XEPublicViewController.h
//  Xiaoer
//
//  Created by KID on 15/1/20.
//
//

#import "XESuperViewController.h"
#import "XEDoctorInfo.h"

typedef enum PublicType_{
    Public_Type_Topic = 0,  //发话题
    Public_Type_Expert,     //问专家
}PublicType;

@interface XEPublicViewController : XESuperViewController

@property (nonatomic, assign) PublicType publicType;
@property (nonatomic, strong) XEDoctorInfo *doctorInfo;
@property (nonatomic, strong) NSString *topicTypeCat;

@end
