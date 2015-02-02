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
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XEAlertView.h"

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
    if (_selectShareType != XEShareType_Topic) {
        _csheet.deleteBtnHidden = YES;
    }
    _csheet.shareSectionHidden = YES;
    if (_selectShareType == XEShareType_Topic) {
        if ([self topicIsCollect])
            _csheet.collectBtnTitle = @"取消收藏";
        else
            _csheet.collectBtnTitle = @"收藏";
        if (!_topicInfo.uId || (_topicInfo.uId && ![_topicInfo.uId isEqualToString:[XEEngine shareInstance].uid])) {
            _csheet.deleteBtnHidden = YES;
        }
    }else if (_selectShareType == XEShareType_Expert){
        
    }else if (_selectShareType == XEShareType_Activity){
        
    }else if (_selectShareType == XEShareType_Qusetion){
        _csheet.deleteBtnHidden = NO;
        _csheet.collectBtnHidden = YES;
    }else{
        _csheet.collectBtnTitle = @"收藏";
    }
    _csheet.sheetDelg = self;
    [_csheet setCustomerSheet];
}

-(BOOL)topicIsCollect{
    if (_topicInfo.faved != 0) {
        return YES;
    }
    return NO;
}

#pragma mark -- LSCustomerSheetDelg
-(void)customerWindowClickAt:(NSIndexPath *)indexPath action:(NSString *)action{
    int row = (int)indexPath.row;
    if (indexPath.section == 2) {
        if (action) {
//            SEL opAction = NSSelectorFromString(action);
//            if ([self respondsToSelector:opAction]) {
//                objc_msgSend(self, opAction);
//                return;
//            }
            if (row == 0) {
                [self collectButtonAction];
            }else if (row == 1){
                [self deleteButtonAction];
            }
        }
    }
}

-(void)collectButtonAction{
    if (_selectShareType == XEShareType_Topic) {
        [self topicCollectAction];
    }
}
-(void)deleteButtonAction{
    __weak XEShareActionSheet *weakSelf = self;
    if (_selectShareType == XEShareType_Topic) {
        
        XEAlertView *alertView = [[XEAlertView alloc] initWithTitle:nil message:@"您确定要删除此话题吗？" cancelButtonTitle:@"取消" cancelBlock:^{
        } okButtonTitle:@"删除" okBlock:^{
            [weakSelf topicDeleteAction];
        }];
        [alertView show];
    }else if (_selectShareType == XEShareType_Qusetion){
        XEAlertView *alertView = [[XEAlertView alloc] initWithTitle:nil message:@"您确定要删除此问题吗？" cancelButtonTitle:@"取消" cancelBlock:^{
        } okButtonTitle:@"删除" okBlock:^{
            [weakSelf questionDeleteAction];
        }];
        [alertView show];
    }
}

#pragma mark -topic custom
-(void)topicCollectAction{
    
    if ([[XEEngine shareInstance] needUserLogin:nil]) {
        return;
    }
    __weak XEShareActionSheet *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    if ([weakSelf topicIsCollect]) {
        [[XEEngine shareInstance] unCollectTopicWithTopicId:_topicInfo.tId uid:[XEEngine shareInstance].uid tag:tag];
    }else{
        [[XEEngine shareInstance] collectTopicWithTopicId:_topicInfo.tId uid:[XEEngine shareInstance].uid tag:tag];
    }
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg];
            return;
        }
        if ([weakSelf topicIsCollect]) {
            weakSelf.topicInfo.faved = 0;
        }else{
            weakSelf.topicInfo.faved = 1;
        }
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
        
    }tag:tag];
    
}

-(void)topicDeleteAction{
    
    if ([[XEEngine shareInstance] needUserLogin:nil]) {
        return;
    }
    __weak XEShareActionSheet *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] deleteTopicWithTopicId:_topicInfo.tId uid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg];
            return;
        }
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
        if ([weakSelf.owner respondsToSelector:@selector(deleteTopicAction:)]) {
            [weakSelf.owner deleteTopicAction:weakSelf.topicInfo];
        }
    }tag:tag];
}

#pragma mark -question custom
-(void)questionDeleteAction{
    if ([[XEEngine shareInstance] needUserLogin:nil]) {
        return;
    }
    __weak XEShareActionSheet *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] deleteQuestionWithQuestionId:_questionInfo.sId uid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg];
            return;
        }
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
        if ([weakSelf.owner respondsToSelector:@selector(deleteTopicAction:)]) {
            [weakSelf.owner deleteTopicAction:weakSelf.questionInfo];
        }
    }tag:tag];
}

#pragma mark -expert custom

#pragma mark -acvitity custom

@end
