//
//  XEShareActionSheet.h
//  Xiaoer
//
//  Created by KID on 15/1/26.
//
//

#import <Foundation/Foundation.h>
#import "XETopicInfo.h"
#import "XEQuestionInfo.h"
#import "XEDoctorInfo.h"
#import "XEActivityInfo.h"

typedef enum XEUrlShareType_{
    XEShareType_Expert,
    XEShareType_Activity,
    XEShareType_Topic,
    XEShareType_Qusetion,
    XEShareType_Web,
}XEShareType;

@protocol XEShareActionSheetDelegate <NSObject>

@optional
-(void) deleteTopicAction:(id)info;
@end

@interface XEShareActionSheet : NSObject

@property (nonatomic, assign) XEShareType selectShareType;
@property (nonatomic, weak) UIViewController<XEShareActionSheetDelegate> *owner;

@property (strong, nonatomic) XEDoctorInfo *doctorInfo;

@property (nonatomic, strong) XEActivityInfo *activityInfo;

@property (nonatomic, strong) XETopicInfo *topicInfo;

@property (nonatomic, strong) XEQuestionInfo *questionInfo;

@property (nonatomic, assign) BOOL bCollect;

@property (nonatomic, strong) NSString *recipesId;

-(void) showShareAction;

@end
