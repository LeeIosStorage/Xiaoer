//
//  XEShareActionSheet.h
//  Xiaoer
//
//  Created by KID on 15/1/26.
//
//

#import <Foundation/Foundation.h>

typedef enum XEUrlShareType_{
    XEShareType_Expert,
    XEFeedShareType_Activity,
    XEFeedShareType_Topic
}XEShareType;

@protocol XEShareActionSheetDelegate <NSObject>

@end

@interface XEShareActionSheet : NSObject

@property (nonatomic, assign) XEShareType selectShareType;
@property (nonatomic, weak) UIViewController<XEShareActionSheetDelegate> *owner;

-(void) showShareAction;

@end
