//
//  OneWeakCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/8.
//
//

#import <UIKit/UIKit.h>

@interface OneWeakCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *belowTitle;
- (void)configureCellWith;
@end
