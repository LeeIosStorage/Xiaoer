//
//  BabyListViewCell.h
//  Xiaoer
//
//  Created by KID on 15/3/9.
//
//

#import <UIKit/UIKit.h>

@interface BabyListViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UILabel *defaultBabyLabel;

@end
