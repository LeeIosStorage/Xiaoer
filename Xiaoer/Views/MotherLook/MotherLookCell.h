//
//  MotherLookCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/8.
//
//

#import <UIKit/UIKit.h>
#import "XEMotherLook.h"

@protocol MotherLookBtnDelegate <NSObject>

- (void)touchMotherLookCellBtn:(UIButton *)sender;


@end
@interface MotherLookCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *numBehindLab;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
- (void)configureCellWith:(NSIndexPath *)indexpath
               motherLook:(XEMotherLook *)motherLook;
@property (nonatomic,strong)id<MotherLookBtnDelegate> delegate;
@end
