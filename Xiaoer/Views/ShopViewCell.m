//
//  ShopViewCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/24.
//
//

#import "ShopViewCell.h"
#define jianju 2
@implementation ShopViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

}
- (IBAction)btnATouched:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self passTagWith:button];

}

- (IBAction)btnBTouched:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self passTagWith:button];
}
- (IBAction)btnCTouched:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self passTagWith:button];
}
- (void)passTagWith:(UIButton *)button{
    NSLog(@"%ld",button.superview.superview.tag);
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchCellWithCellTag:btnTag:)]) {
        [self.delegate touchCellWithCellTag:button.superview.superview.tag btnTag:button.tag];
    }
    
}
- (void)configureCellWith:(NSIndexPath *)indexPath andNumberOfItemsInCell:(NSInteger)number{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = self.contentView.frame.size.height;
    CGFloat halfWidth = width/2;
    CGFloat halfHeight = height/2;
    if (indexPath.section == 0) {
        switch (number) {
            case 1:
            {
                self.btnA.frame  = CGRectMake(0, 0, width , height - jianju);
                self.btnB.frame = CGRectMake(0, 0, 0, 0);
                self.btnC.frame = CGRectMake(0, 0, 0, 0);
            }

                
                break;
            case 2:
                self.btnA.frame  = CGRectMake(0, 0, halfWidth - jianju , height - jianju);
                self.btnB.frame = CGRectMake(halfWidth, 0,halfWidth, height - jianju);
                self.btnC.frame = CGRectMake(0, 0, 0, 0);
                break;
            case 3:
            {
                
                self.btnA.frame  = CGRectMake(0, 0, halfWidth - jianju, height - jianju);
                self.btnB.frame = CGRectMake(halfWidth, 0, halfWidth, halfHeight - jianju);
                self.btnC.frame = CGRectMake(halfWidth, halfHeight, halfWidth, halfHeight - jianju);

                
            }

                break;
            default:
                break;
        }
        
    }else if (indexPath.section == 1){
        switch (number) {
            case 1:
                
                self.btnA.frame  = CGRectMake(0, 0, width , height - jianju);
                self.btnB.frame = CGRectMake(0, 0, 0, 0);
                self.btnC.frame = CGRectMake(0, 0, 0, 0);
                
                break;
            case 2:
                self.btnA.frame  = CGRectMake(0, 0, halfWidth - jianju , height - jianju);
                self.btnB.frame = CGRectMake(halfWidth , 0,halfWidth, height - jianju);
                self.btnC.frame = CGRectMake(0, 0, 0, 0);
                break;
            case 3:
                self.btnA.frame  = CGRectMake(0, 0, halfWidth + 50 - jianju, height - jianju);
                self.btnB.frame = CGRectMake(halfWidth+ 50, 0, halfWidth - 50, halfHeight - jianju);
                self.btnC.frame = CGRectMake(halfWidth + 50, halfHeight, halfWidth - 50, halfHeight - jianju);
                break;
            default:
                break;
        }
        
    }
}




@end
