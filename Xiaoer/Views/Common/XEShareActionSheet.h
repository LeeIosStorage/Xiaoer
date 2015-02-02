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

typedef enum XEUrlShareType_{
    XEShareType_Expert,
    XEShareType_Activity,
    XEShareType_Topic,
    XEShareType_Qusetion
}XEShareType;

@protocol XEShareActionSheetDelegate <NSObject>
-(void) deleteTopicAction:(id)info;
@end

@interface XEShareActionSheet : NSObject

@property (nonatomic, assign) XEShareType selectShareType;
@property (nonatomic, weak) UIViewController<XEShareActionSheetDelegate> *owner;

@property (nonatomic, strong) XETopicInfo *topicInfo;

@property (nonatomic, strong) XEQuestionInfo *questionInfo;

-(void) showShareAction;

@end
