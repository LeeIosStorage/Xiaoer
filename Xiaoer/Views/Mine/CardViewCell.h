//
//  CardViewCell.h
//  Xiaoer
//
//  Created by KID on 15/2/3.
//
//

#import <UIKit/UIKit.h>
#import "XECardInfo.h"

@interface CardViewCell : UITableViewCell

@property (strong, nonatomic) XECardInfo *cardInfo;

@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIButton *statusBtn;
@property (strong, nonatomic) IBOutlet UILabel *cardTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardDes;
@property (strong, nonatomic) IBOutlet UIImageView *cardImageView;

@end
