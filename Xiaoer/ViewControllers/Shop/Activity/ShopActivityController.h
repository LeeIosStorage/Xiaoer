//
//  ShopActivityController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/25.
//
//

#import "XESuperViewController.h"
#import "XEShopSerieInfo.h"
@interface ShopActivityController : XESuperViewController
@property (weak, nonatomic) IBOutlet UITableView *tabView;
/**
 *  商品类型(1玩具, 2卡券, 3祈福
 */
@property (nonatomic,strong)NSString *type;
/**
 *  商品子类型(玩具[1评测玩具,2训练玩具,3另购玩具], 卡券[ 1活动卡券,2家政服务卡券], 祈福[1祈福])
 */
@property (nonatomic,strong)NSString *category;

@property (nonatomic,strong)XEShopSerieInfo *serieInfo;

/**
 *  商品名称
 */
@property (nonatomic,strong)NSString *name;
/**
 *  商品系列Id
 */
@property (nonatomic,strong)NSString *serieid;


@property (nonatomic,strong)NSString *leftDay;
@end
