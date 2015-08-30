//
//  SearchListCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/22.
//
//

#import <UIKit/UIKit.h>
#import "XEShopListInfo.h"
@interface SearchListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLable;
- (void)configureCellWith:(XEShopListInfo *)info;
@end
