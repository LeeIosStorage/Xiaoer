//
//  TopicListViewController.h
//  Xiaoer
//
//  Created by KID on 15/1/27.
//
//

#import "XESuperViewController.h"

typedef enum TopicType_{
    TopicType_Normal = 0,  //ALL
    TopicType_Nourish,     //养育
    TopicType_Nutri,       //营养
    TopicType_Kinder,      //入园
    TopicType_Mind,        //心理
}TopicType;

@interface TopicListViewController : XESuperViewController

@property (nonatomic, assign) TopicType topicType;
@property (nonatomic, assign) BOOL bQuestion;

@end
