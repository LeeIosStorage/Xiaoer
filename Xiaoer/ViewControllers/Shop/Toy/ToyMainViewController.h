//
//  ToyMainViewController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/18.
//
//

#import "XESuperViewController.h"

@interface ToyMainViewController : XESuperViewController
/**
 *  商品类型
 */
//商品类型(玩具, 2卡券, 3祈福)
@property (nonatomic,strong)NSString *shopType;
/**
 *  商品子类型
 */
//商品子类型(玩具[1评测玩具,2训练玩具,3另购玩具], 卡券[1活动卡券,2家政服务卡券], 祈福[1祈福])
@property (nonatomic,strong)NSString *shopSubType;

@end
