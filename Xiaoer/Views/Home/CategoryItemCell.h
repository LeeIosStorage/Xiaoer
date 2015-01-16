//
//  CategoryItemCell.h
//  Xiaoer
//
//  Created by KID on 15/1/16.
//
//

#import <UIKit/UIKit.h>

@interface CategoryItemCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *itemImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *collectLabel;
@property (strong, nonatomic) IBOutlet UILabel *readLabel;

@property (strong, nonatomic) IBOutlet UIImageView *topImageView;

@end
