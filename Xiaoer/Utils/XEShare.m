//
//  XEShare.m
//  Xiaoer
//
//  Created by KID on 15/2/27.
//
//

#import "XEShare.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "XEProgressHUD.h"

@implementation XEShare

#pragma mark -
#pragma mark 友盟分享
+ (void) UmengShare:(id)VC URL:(NSString *)URL IMG:(UIImage *)IMG Info:(NSString *)Info File:(NSString *)File Type:(PSShareType)Type
{
    if  (Type == PSShareMusic)
    {
        [UMSocialData defaultData].extConfig.qqData.qqMessageType             = UMSocialQQMessageTypeDefault;
        [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType  = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatFavoriteData.wxMessageType = UMSocialWXMessageTypeWeb;
        [[UMSocialData defaultData].extConfig.wechatSessionData.urlResource  setResourceType:UMSocialUrlResourceTypeMusic url:File];
        [[UMSocialData defaultData].extConfig.wechatTimelineData.urlResource setResourceType:UMSocialUrlResourceTypeMusic url:File];
        [[UMSocialData defaultData].extConfig.wechatFavoriteData.urlResource setResourceType:UMSocialUrlResourceTypeMusic url:File];
    }
    else if (Type == PSShareVideo)
    {
        [UMSocialData defaultData].extConfig.qqData.qqMessageType             = UMSocialQQMessageTypeDefault;
        [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType  = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatFavoriteData.wxMessageType = UMSocialWXMessageTypeWeb;
        [[UMSocialData defaultData].extConfig.wechatSessionData.urlResource  setResourceType:UMSocialUrlResourceTypeVideo url:File];
        [[UMSocialData defaultData].extConfig.wechatTimelineData.urlResource setResourceType:UMSocialUrlResourceTypeVideo url:File];
        [[UMSocialData defaultData].extConfig.wechatFavoriteData.urlResource setResourceType:UMSocialUrlResourceTypeVideo url:File];
    }
    else if (Type == PSShareInvite)
    {
        [UMSocialData defaultData].extConfig.qqData.qqMessageType             = UMSocialQQMessageTypeDefault;
        [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType  = UMSocialWXMessageTypeApp;
        [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeApp;
        [UMSocialData defaultData].extConfig.wechatFavoriteData.wxMessageType = UMSocialWXMessageTypeApp;
        [[UMSocialData defaultData].extConfig.wechatSessionData.urlResource  setResourceType:UMSocialUrlResourceTypeDefault url:File];
        [[UMSocialData defaultData].extConfig.wechatTimelineData.urlResource setResourceType:UMSocialUrlResourceTypeDefault url:File];
        [[UMSocialData defaultData].extConfig.wechatFavoriteData.urlResource setResourceType:UMSocialUrlResourceTypeDefault url:File];
    }
    else
    {
        [UMSocialData defaultData].extConfig.qqData.qqMessageType             = UMSocialQQMessageTypeDefault;
        [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType  = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatFavoriteData.wxMessageType = UMSocialWXMessageTypeWeb;
        [[UMSocialData defaultData].extConfig.wechatSessionData.urlResource  setResourceType:UMSocialUrlResourceTypeDefault url:File];
        [[UMSocialData defaultData].extConfig.wechatTimelineData.urlResource setResourceType:UMSocialUrlResourceTypeDefault url:File];
        [[UMSocialData defaultData].extConfig.wechatFavoriteData.urlResource setResourceType:UMSocialUrlResourceTypeDefault url:File];
    }
    [UMSocialQQHandler setQQWithAppId:UMS_QQ_ID appKey:UMS_QQ_Key    url:URL];
    [UMSocialWechatHandler setWXAppId:UMS_WX_ID appSecret:UMS_WX_Key url:URL];
    [UMSocialSnsService presentSnsIconSheetView: VC  appKey:UMS_APP
                                      shareText: Info
                                     shareImage: IMG
                                shareToSnsNames: nil
                                       delegate: VC];
}

#pragma mark - 直接分享底层接口
+ (BOOL) socialShare:(id)VC shareType:(NSString *)shareType URL:(NSString *)URL IMG:(UIImage *)IMG Info:(NSString *)Info{
    
//    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] init];
//    urlResource.resourceType = UMSocialUrlResourceTypeDefault;
//    urlResource.url = URL;
    if ([shareType isEqualToString:UMShareToSina]) {
        Info = [NSString stringWithFormat:@"%@ 链接地址:%@",Info,URL];
    }
    [UMSocialQQHandler setQQWithAppId:UMS_QQ_ID appKey:UMS_QQ_Key    url:URL];
    [UMSocialWechatHandler setWXAppId:UMS_WX_ID appSecret:UMS_WX_Key url:URL];
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[shareType] content:Info image:IMG location:nil urlResource:nil presentedController:VC completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [XEProgressHUD AlertSuccess:@"分享成功"];
        }
    }];
    return YES;
}

@end
