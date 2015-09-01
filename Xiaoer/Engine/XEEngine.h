//
//  XEEngine.h
//  Xiaoer
//
//  Created by KID on 14/12/31.
//
//

#import <Foundation/Foundation.h>

#import "XEUserInfo.h"

#define XE_USERINFO_CHANGED_NOTIFICATION @"XE_USERINFO_CHANGED_NOTIFICATION"

//平台切换宏
typedef enum {
    TestPlatform    = 0,    //测试平台
    OnlinePlatform  = 1,    //线上平台
}ServerPlatform;

typedef void(^onAppServiceBlock)(NSInteger tag, NSDictionary* jsonRet, NSError* err);
typedef void(^onLSMsgFileProgressBlock)(NSUInteger receivedSize, long long expectedSize);

@interface XEEngine : NSObject

@property (nonatomic, strong) NSString* uid;
@property (nonatomic, strong) NSString* account;
@property (nonatomic, strong) NSString* userPassword;
@property (nonatomic, strong) XEUserInfo* userInfo;
@property (nonatomic, readonly) NSDictionary* globalDefaultConfig;
@property (nonatomic,assign) BOOL debugMode;

@property (nonatomic,readonly) NSString* baseUrl;
@property (nonatomic, readonly) BOOL isFirstLoginInThisDevice;
@property (assign, nonatomic) BOOL bVisitor;
@property (assign, nonatomic) BOOL firstLogin;

@property (nonatomic,assign) ServerPlatform serverPlatform;
@property (nonatomic,readonly) NSString* xeInstanceDocPath;

+ (XEEngine *)shareInstance;
+ (NSDictionary*)getReponseDicByContent:(NSData*)content err:(NSError*)err;
+ (NSString*)getErrorMsgWithReponseDic:(NSDictionary*)dic;
+ (NSString*)getErrorCodeWithReponseDic:(NSDictionary*)dic;
+ (NSString*)getSuccessMsgWithReponseDic:(NSDictionary*)dic;

- (void)saveAccount;
- (NSString*)getCurrentAccoutDocDirectory;

- (void)refreshUserInfo;
- (BOOL)hasAccoutLoggedin;
- (void)logout;
- (void)logout:(BOOL)removeAccout;

#pragma mark - Visitor
- (void)visitorLogin;
- (BOOL)needUserLogin:(NSString *)message;

//////////////////
- (int)getConnectTag;
- (void)addOnAppServiceBlock:(onAppServiceBlock)block tag:(int)tag;
- (void)removeOnAppServiceBlockForTag:(int)tag;
- (void)addGetCacheTag:(int)tag;
- (onAppServiceBlock)getonAppServiceBlockByTag:(int)tag;

//异步回调
- (void)getCacheReponseDicForTag:(int)tag complete:(void(^)(NSDictionary* jsonRet))complete;
- (void)getCacheReponseDicForUrl:(NSString*)url complete:(void(^)(NSDictionary* jsonRet))complete;

//保存cache
- (void)saveCacheWithString:(NSString*)str url:(NSString*)url;
- (void)clearAllCache;
- (unsigned long long)getUrlCacheSize;


#pragma mark -register and login
- (BOOL)registerWithPhone:(NSString*)phone password:(NSString*)password tag:(int)tag;
- (BOOL)registerWithEmail:(NSString*)email password:(NSString*)password tag:(int)tag;

- (BOOL)loginWithAccredit:(NSString*)loginType presentingController:(UIViewController *)presentingController tag:(int)tag error:(NSError **)errPtr;
- (BOOL)thirdLoginWithPlantform:(NSString*)plantform avatar:(NSString*)avatar openid:(NSString*)openid nickname:(NSString*)nickname gender:(NSString*)gender tag:(int)tag error:(NSError **)errPtr;

- (BOOL)loginWithPhone:(NSString*)phone password:(NSString*)password tag:(int)tag error:(NSError **)errPtr;
- (BOOL)loginWithEmail:(NSString*)email password:(NSString*)password error:(NSError **)errPtr;

- (BOOL)loginWithUid:(NSString *)uid password:(NSString*)password tag:(int)tag error:(NSError **)errPtr;

- (BOOL)getUserInfoWithUid:(NSString*)uid tag:(int)tag error:(NSError **)errPtr;

//获取验证码
- (BOOL)getCodeWithPhone:(NSString*)phone type:(NSString*)type tag:(int)tag;
//校验验证码
- (BOOL)checkCodeWithPhone:(NSString*)phone code:(NSString*)msgcode codeType:(NSString*)type tag:(int)tag;

//重置密码
- (BOOL)resetPassword:(NSString*)password withPhone:(NSString*)phone tag:(int)tag;

//校验邮箱 uid可以为空
- (BOOL)checkEmailWithEmail:(NSString *)email uid:(NSString *)uid tag:(int)tag;
//重置邮箱密码
- (BOOL)preresetPasswordWithEmail:(NSString *)email tag:(int)tag;
//校验手机号 uid可以为空
- (BOOL)checkPhoneWithPhone:(NSString *)phone uid:(NSString *)uid tag:(int)tag;
- (BOOL)updateBgImgWithUid:(NSString *)uid avatar:(NSArray *)data tag:(int)tag;
//修改头像
- (BOOL)updateAvatarWithUid:(NSString *)uid avatar:(NSArray *)data tag:(int)tag;
//上传baby头像
- (BOOL)updateBabyAvatarWithBabyUid:(NSString *)bbUid avatar:(NSArray *)data tag:(int)tag;

//用户信息编辑
- (BOOL)editUserInfoWithUid:(NSString *)uid name:(NSString *)name nickname:(NSString *)nickname hasBaby:(NSString *)hasBaby desc:(NSString *)desc district:(NSString *)district address:(NSString *)address phone:(NSString *)phone bbId:(NSString *)bbId bbName:(NSString *)bbName bbGender:(NSString *)bbGender bbBirthday:(NSString *)bbBirthday bbAvatar:(NSString *)bbAvatar userAvatar:(NSString *)userAvatar dueDate:(NSString *)dueDate hospital:(NSString *)hospital tag:(int)tag;
//baby资料编辑
- (BOOL)editBabyInfoWithUserId:(NSString *)uid bbId:(NSString *)bbId bbName:(NSString *)bbName bbGender:(NSString *)bbGender bbBirthday:(NSString *)bbBirthday bbAvatar:(NSString *)bbAvatar acquiesce:(NSString *)acquiesce tag:(int)tag;

//获取地区-省
- (BOOL)getCommonAreaRoot:(int)tag;
//获取地区-市
- (BOOL)getCommonAreaNodeWithCode:(NSString *)code tag:(int)tag;
//获取服务器版本信息
- (BOOL)getAppNewVersionWithTag:(int)tag;

#pragma mark - home
//获取轮播信息
- (BOOL)getBannerWithTag:(int)tag;

//首页用户信息(获取商城地址+未读消息+外接设备(待讨论)+宝宝信息)
- (BOOL)getHomepageInfosWithUid:(NSString *)uid tag:(int)tag;
//六大项训练信息
- (BOOL)getTrainIngosWithUid:(NSString *)uid tag:(int)tag;

//获取资讯(食谱,养育,评测)标签页数据
- (BOOL)getInfoWithBabyId:(NSString *)bbId tag:(int)tag;

//获取资讯(食谱,养育,评测)列表数据
- (BOOL)getListInfoWithNum:(NSUInteger)pagenum stage:(NSUInteger)stage cat:(int)cat tag:(int)tag;
//资讯
- (BOOL)collectInfoWithInfoId:(NSString *)infoId uid:(NSString *)uid tag:(int)tag;
- (BOOL)unCollectInfoWithInfoId:(NSString *)infoId uid:(NSString *)uid tag:(int)tag;
//查询资讯是否被当前用户收藏
- (BOOL)getRecipesStatusWithUid:(NSString *)uid rid:(NSString *)rid tag:(int)tag;

//专家列表
- (BOOL)getExpertListWithPage:(int)page tag:(int)tag;
- (BOOL)getExpertDetailWithUid:(NSString *)uid expertId:(NSString *)expertId tag:(int)tag;
- (BOOL)collectExpertWithExpertId:(NSString *)expertId uid:(NSString *)uid tag:(int)tag;
- (BOOL)unCollectExpertWithExpertId:(NSString *)expertId uid:(NSString *)uid tag:(int)tag;
- (BOOL)shareExpertWithExpertId:(NSString *)expertId uid:(NSString *)uid tag:(int)tag;

//育婴师
- (BOOL)getNurserListWithPage:(int)page uid:(NSString *)uid tag:(int)tag;
- (BOOL)bindNurserWithNurserId:(NSString *)nurserid uid:(NSString *)uid tag:(int)tag;

//报名活动列表 type=0报名活动 type=1抢票活动
- (BOOL)getApplyActivityListWithPage:(int)page uid:(NSString *)uid type:(int)type tag:(int)tag;
- (BOOL)getApplyActivityDetailWithActivityId:(NSString *)activityId uid:(NSString *)uid type:(int)type tag:(int)tag;
- (BOOL)applyActivityWithActivityId:(NSString *)activityId uid:(NSString *)uid type:(int)type tag:(int)tag;
- (BOOL)applyActivityAddInfoWithActivityId:(NSString *)activityId name:(NSString *)name  remark:(NSString *)remark tag:(int)tag;
- (BOOL)collectActivityWithActivityId:(NSString *)activityId uid:(NSString *)uid type:(int)type tag:(int)tag;
- (BOOL)unCollectActivityWithActivityId:(NSString *)activityId uid:(NSString *)uid type:(int)type tag:(int)tag;
- (BOOL)shareActivityWithActivityId:(NSString *)activityId uid:(NSString *)uid type:(int)type tag:(int)tag;

//历史活动
- (BOOL)getHistoryActivityListWithPage:(int)page tag:(int)tag;
//- (BOOL)getTopicListWithExpertId:(NSString *)expertId page:(int)page tag:(int)tag;

#pragma mark - expertChat
//获取热门话题list
- (BOOL)getHotTopicWithWithPagenum:(int)page tag:(int)tag
                               cat:(NSString *)cat
                             title:(NSString *)title;

//获取热门话题20条
- (BOOL)getHotTopicWithWithTag:(int)tag;
//获取专家问答list
- (BOOL)getQuestionListWithPagenum:(int)page tag:(int)tag
                             title:(NSString *)title;
//获取专家问答20条
- (BOOL)getHotQuestionWithTag:(int)tag;
//获取类别话题list
- (BOOL)getHotTopicListWithCat:(int)cat pagenum:(int)page tag:(int)tag;
//用户问答列表list
- (BOOL)getQuestionListWithUid:(NSString *)uid pagenum:(int)page tag:(int)tag;
//话题详情
- (BOOL)getTopicDetailsInfoWithTopicId:(NSString *)tid uid:(NSString *)uid tag:(int)tag;
- (BOOL)collectTopicWithTopicId:(NSString *)tid uid:(NSString *)uid tag:(int)tag;
- (BOOL)unCollectTopicWithTopicId:(NSString *)tid uid:(NSString *)uid tag:(int)tag;
- (BOOL)shareTopicWithTopicId:(NSString *)tid uid:(NSString *)uid tag:(int)tag;
- (BOOL)deleteTopicWithTopicId:(NSString *)tid uid:(NSString *)uid tag:(int)tag;
- (BOOL)commitCommentTopicWithTopicId:(NSString *)tid uid:(NSString *)uid content:(NSString *)content tag:(int)tag;
- (BOOL)deleteCommentTopicWithCommentId:(NSString *)cid uid:(NSString *)uid topicId:(NSString *)topicId tag:(int)tag;
//话题评论list
- (BOOL)getTopicCommentListWithWithTopicId:(NSString *)tid pagenum:(int)page tag:(int)tag;

//话题发布
- (BOOL)publishTopicWithUserId:(NSString *)uid title:(NSString *)title content:(NSString *)content cat:(int)cat imgs:(NSString *)imgs tag:(int)tag;
- (BOOL)updateTopicWithImgs:(NSArray *)imgs index:(int)index tag:(int)tag;

//问专家
- (BOOL)publishQuestionWithExpertId:(NSString *)expertId uid:(NSString *)uid title:(NSString *)title content:(NSString *)content overt:(NSString *)overt imgs:(NSString *)imgs tag:(int)tag;
- (BOOL)updateExpertQuestionWithImgs:(NSArray *)imgs index:(int)index tag:(int)tag;
//问题详情
- (BOOL)getQuestionDetailsWithQuestionId:(NSString *)questionId uid:(NSString *)uid  tag:(int)tag;
- (BOOL)deleteQuestionWithQuestionId:(NSString *)questionId uid:(NSString *)uid tag:(int)tag;

#pragma mark - mine
//我的卡包list
- (BOOL)getCardListWithUid:(NSString *)uid pagenum:(int)page tag:(int)tag;
//卡包详情
- (BOOL)getCardDetailInfoWithUid:(NSString *)uid cid:(NSString *)cid tag:(int)tag;
//领取卡包
- (BOOL)receiveCardWithUid:(NSString *)uid cid:(NSString *)cid tag:(int)tag;
- (BOOL)receiveCardAddInfoWithInfoId:(NSString *)infoId name:(NSString *)name remark:(NSString *)remark tag:(int)tag;
//我的活动
- (BOOL)getMyApplyActivityListWithUid:(NSString *)uid page:(int)page tag:(int)tag;
- (BOOL)getMyCollectActivityListWithUid:(NSString *)uid page:(int)page tag:(int)tag;
//我的话题
- (BOOL)getMyPublishTopicListWithUid:(NSString *)uid page:(int)page tag:(int)tag;
- (BOOL)getMyCollectTopicListWithUid:(NSString *)uid page:(int)page tag:(int)tag;
//我收藏的资讯专家
- (BOOL)getMyCollectInfoListWithUid:(NSString *)uid page:(int)page tag:(int)tag;
- (BOOL)getMyCollectExpertListWithUid:(NSString *)uid page:(int)page tag:(int)tag;
//公告,问答
- (BOOL)getNoticeMessagesListWithUid:(NSString *)uid page:(int)page tag:(int)tag;
- (BOOL)getQuestionMessagesListWithUid:(NSString *)uid page:(int)page tag:(int)tag;

#pragma mark - evaluation
//评测页默认宝宝的信息
- (BOOL)getEvaInfoWithUid:(NSString *)uid tag:(int)tag;
//关键期道具信息和购买链接信息
- (BOOL)getEvaToolWithStage:(int)stage tag:(int)tag;
//全部历史评测
- (BOOL)getAllEvaHistoryWithBabyId:(NSString *)babyId uid:(NSString *)uid tag:(int)tag;
//某关键期历史评测
- (BOOL)getStageEvaHistoryWithBabyId:(NSString *)babyId uid:(NSString *)uid stage:(NSString *)stage tag:(int)tag;
#pragma mark- 激活东方有线卡
- (BOOL)activityEastCardWithKabaoid:(NSString*)kabaoid userid:(NSString *)userid eno:(NSString *)eno ekey:(NSString *)ekey tag:(int)tag;
/**
 *  获取东方有线卡信息
 */
- (BOOL)getEastCardInfomaitonWithuserid:(NSString *)userid kabaoid:(NSString *)kabaoid tag:(int)tag;
/**
 *  首页妈妈必看
 */
- (BOOL)getMotherLookListWithTag:(int)tag;

/**
 *  每周一练界面信息
 */
- (BOOL)getOneWeekListWith:(int)cweek Tag:(int)tag;
/**
 *  首页每周一练的周数信息
 */
- (BOOL)getOneWeekScrollviewInfomationWith:(NSString *)userID tag:(int)tag;


#pragma mark 商品系列借口
//获取商品主页信息 （只有今日上新）
- (BOOL)getShopMainListInfomationWith:(int)tag
                                types:(NSString *)types
                              pageNum:(NSString *)pageNum;
//获取商品主页的信息 （选择性输入types）
- (BOOL)getShopMainListInfomationWith:(int)tag
                                types:(NSString *)types;



/**
 *  商品系列列表
 *
 */
- (BOOL)getShopSeriousInfomationWithType:(NSString *)type
                                     tag:(int)tag
                                category:(NSString *)category
                                 pagenum:(NSString *)pagenum;
/**
 *  获取商品列表
 */
- (BOOL)getShopListInfoMationWith:(int)tag
                               category:(NSString *)category
                                pagenum:(NSString *)pagenum
                             type:(NSString *)typeStr
                             name:(NSString *)name
                          serieid:(NSString *)serieid;


//获取收获地址列表
- (BOOL)getAddressListWithTag:(int)tag
                       userId:(NSString *)userid;

//保存修改地址
- (BOOL)saveEditorAddressWith:(int)tag
                       userid:(NSString *)userid
                   provinceid:(NSString *)provinceid
                       cityid:(NSString *)cityid
                   districtid:(NSString *)districtid
                         name:(NSString *)name
                        phone:(NSString *)phone
                      address:(NSString *)address
                          tel:(NSString *)tel
                          def:(NSString *)def
                          del:(NSString *)del
                           idnum:(NSString *)idnum;

/**
 *  获取商品详情页列表
 */
- (BOOL)getShopDetailInfomationWithTag:(int)tag
                                shopId:(NSString *)shopId
                                userId:(NSString *)userId;

/**
 *   添加更新删除购物车商品 del是否删除 1是 其它为否
 */
- (BOOL)refreshShopCarWithTag:(int)tag
                          del:(NSString *)del
                        idNum:(NSString *)idNum
                          num:(NSString *)num
                       userid:(NSString *)userid
                      goodsid:(NSString *)goodsid
                     standard:(NSString *)standard;
/**
 *  获取购物车列表
 */
- (BOOL)getShopCarListInfomationWith:(int)tag
                              userid:(NSString *)userid
                           onlygoods:(NSString *)onlygoods
                             pagenum:(NSString *)pagenum;

/**
 *  获取优惠券列表
 */
- (BOOL)getCouponListInfomationWith:(int)tag
                             userid:(NSString *)userid
                            pagenum:(NSString *)pagenum
                           goodsids:(NSString *)goodsids;


/**
 *  获取折扣信息
 */
- (BOOL)getDiscountInfomationWith:(int)tag
                           userid:(NSString *)userid;
/**
 *  下单
 */
- (BOOL)getOrderToPlaceAnOrderWith:(int)tag
                            userid:(NSString *)userid
                         orderjson:(NSString *)orderjson
                     useraddressid:(NSString *)useraddressid;
/**
 *  获取订单列表
 */
- (BOOL)getOrderListInfomationWith:(int)tag
                       etickettype:(NSString *)etickettype
                           pagenum:(NSString *)pagenum
                          statuses:(NSString *)statuses
                            userid:(NSString *)userid;
/**
 *  获取订单详情
 */
- (BOOL)getOrderDetailInfomationWith:(int)tag
                     orderproviderid:(NSString *)orderproviderid;


/**
 *  获取用户预约券预约记录
 */
- (BOOL)getOrderHistoryInfomationWith:(int)tag
                      orderproviderid:(NSString *)orderproviderid
                               userid:(NSString *)userid
                              goodsid:(NSString *)goodsid;
/**
 *  用户预约券预约
 */

- (BOOL)getApplyOrderInfomationWith:(int)tag
                             userid:(NSString *)userid
                          eticketid:(NSString *)eticketid
                           linkname:(NSString *)linkname
                          linkphone:(NSString *)linkphone
                        linkaddress:(NSString *)linkaddress
                        appointtime:(NSString *)appointtime
                         sercontent:(NSString *)sercontent;
/**
 *  删除订单
 */
- (BOOL)deleteOrderWith:(int)tag
        orderproviderid:(NSString *)orderproviderid;

/**
 *  申请退款
 */
- (BOOL)applyForRefundWith:(int)tag
                    userid:(NSString *)userid
           orderproviderid:(NSString *)orderproviderid
             refundservice:(NSString *)refundservice
              refundreason:(NSString *)refundreason
               refundprice:(NSString *)refundprice
               refundintro:(NSString *)refundintro;
/**
 *  取消订单
 */
- (BOOL)cancleOrderWith:(int)tag
        orderproviderid:(NSString *)orderproviderid;

/**
 *  获取用户即将过期预约券列表
 */
- (BOOL)getOrderWillpassOrderWith:(int)tag
                             type:(NSString *)type
                           userid:(NSString *)userid;

#pragma mark  七牛
/**
 * 获取用户上传剩余数量
 */
- (BOOL)qiNiuGetRestCanPostImageWith:(int)tag
                               userid:(NSString *)userid;
/**
 *  获取七牛上传token值
 */
- (BOOL)qiNiuGetTokenWith:(int)tag;
/**
 *   获取我的照片列表
 */
- (BOOL)qiniuCheckPosedPhotoWith:(int)tag
                          userid:(NSString *)userid;
/**
 *  获取某月照片列表
 */
- (BOOL)qiNiuGetMolthListInfoWith:(int)tag
                              cat:(NSString *)cat
                            objid:(NSString *)objid
                             year:(NSString *)year
                            month:(NSString *)month;
/**
 *   保存用户图片
 */
- (BOOL)qiNiuSavePhotoWith:(int)tag
                       cat:(NSString *)cat
                       url:(NSString *)url
                     objid:(NSString *)objid;
/**
 *  删除用户图片
 */
- (BOOL)qiNiuDeleteImageDataWith:(int)tag
                              id:(NSString *)id;
/**
 *  获取宝宝印象运费
 */
- (BOOL)qiNiuGetCarriageMoneyWith:(int)tag
                       provinceid:(NSString *)provinceid
                           userid:(NSString *)userid;
/**
 *  用户下印刷单
 */
- (BOOL)qiNiuOrderWith:(int)tag
                userid:(NSString *)userid
         useraddressid:(NSString *)useraddressid
                  mark:(NSString *)mark
                   tip:(NSString *)tip;

#pragma mark 宝宝印象－爱心
/**
 *  是否可以下单
 */
- (BOOL)loveIfCanOrderWith:(int)tag
                    userid:(NSString *)userid;
/**
 *  下单
 */
- (BOOL)lovePlaceAnOrderWith:(int)tag
                      userid:(NSString *)userid;
/**
 *  绑定手机号码
 */
- (BOOL)loveBoundPhoneWith:(int)tag
                    userid:(NSString *)userid
                     phone:(NSString *)phone;
/**
 *  用户爱心分赠送
 */
- (BOOL)loveFreeGiveLovePointsWith:(int)tag
                            userid:(NSString *)userid
                             phone:(NSString *)phone
                        lovepoints:(NSString *)lovepoints;
@end
