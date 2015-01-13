//
//  MineTabCell.h
//  Xiaoer
//
//  Created by KID on 15/1/8.
//
//

#import <UIKit/UIKit.h>

@interface MineTabCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *introLabel;

@property (nonatomic, strong) IBOutlet UIImageView *leftAvater;

@property (nonatomic, strong) IBOutlet UIImageView *topline;

@property (nonatomic, strong) IBOutlet UIImageView *sepline;

- (void) setbottomLineWithType:(int)type;

@end