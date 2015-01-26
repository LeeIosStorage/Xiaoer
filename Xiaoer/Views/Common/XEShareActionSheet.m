//
//  XEShareActionSheet.m
//  Xiaoer
//
//  Created by KID on 15/1/26.
//
//

#import "XEShareActionSheet.h"
#import "XECustomerWindow.h"
#import <objc/message.h>

@interface XEShareActionSheet() <XECustomerWindowDelg>
{
    NSMutableDictionary* _actionSheetIndexSelDic;
    XECustomerWindow *_csheet;
}

@end

@implementation XEShareActionSheet
-(void)dealloc
{
    _owner = nil;
    _csheet = nil;
}

-(void) showShareAction
{
    _csheet = [[[NSBundle mainBundle] loadNibNamed:@"XECustomerWindow" owner:nil options:nil] objectAtIndex:0];
    _csheet.sheetDelg = self;
    [_csheet setCustomerSheet];
}

#pragma mark -- LSCustomerSheetDelg
-(void)customerWindowClickAt:(NSIndexPath *)indexPath action:(NSString *)action{
//    int row = (int)indexPath.row;
//    if (indexPath.section == 2) {
//        if (action) {
//            SEL opAction = NSSelectorFromString(action);
//            if ([self respondsToSelector:opAction]) {
//                objc_msgSend(self, opAction);
//                return;
//            }
//        }
//    }
}
@end
