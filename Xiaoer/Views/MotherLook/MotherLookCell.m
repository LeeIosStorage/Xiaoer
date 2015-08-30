//
//  MotherLookCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/8.
//
//

#import "MotherLookCell.h"
#import "UIImageView+WebCache.h"
@implementation MotherLookCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configureCellWith:(NSIndexPath *)indexpath motherLook:(XEMotherLook *)motherLook{


    self.btn.layer.cornerRadius = 10;
    self.btn.layer.borderWidth = 1;
    self.btn.layer.borderColor = [UIColor colorWithRed:43/255.0 green:186/255.0 blue:230/255.0 alpha:1].CGColor;
    self.btn.tintColor = [UIColor colorWithRed:43/255.0 green:186/255.0 blue:230/255.0 alpha:1];
    self.btn.titleLabel.textColor = [UIColor colorWithRed:43/255.0 green:186/255.0 blue:230/255.0 alpha:1];
    if ([motherLook.type isEqualToString:@"1"]) {
        self.numLab.text = motherLook.totalNum;
        self.numBehindLab.text = @"个名额";
        [self.btn setTitle:@"去抢票" forState:UIControlStateNormal];
        [self.btn setTitle:@"去抢票" forState:UIControlStateHighlighted];
    }
    if ([motherLook.type isEqualToString:@"2"]) {
        self.numLab.hidden = YES;
        self.numBehindLab.hidden = YES;
        self.titleLab.frame = CGRectMake(20, 20, 150, 50);
        [self.btn setTitle:@"去看看" forState:UIControlStateNormal];
        [self.btn setTitle:@"去看看" forState:UIControlStateHighlighted];
    }
    if ([motherLook.type isEqualToString:@"3"]) {
        self.numLab.hidden = YES;
        self.numBehindLab.hidden = YES;
        self.titleLab.frame = CGRectMake(20, 20, 150, 50);
        [self.btn setTitle:@"去逛逛" forState:UIControlStateNormal];
        [self.btn setTitle:@"去逛逛" forState:UIControlStateHighlighted];
    }
    if ([motherLook.type isEqualToString:@"4"]) {
        self.numLab.hidden = YES;
        self.numBehindLab.hidden = YES;
        self.titleLab.frame = CGRectMake(20, 20, 150, 50);
        [self.btn setTitle:@"去瞧瞧" forState:UIControlStateNormal];
        [self.btn setTitle:@"去瞧瞧" forState:UIControlStateHighlighted];
        
    }
    
    self.titleLab.text = motherLook.title;
    self.rightImageView.layer.cornerRadius = 10;
    self.rightImageView.layer.masksToBounds = YES;
    [self.rightImageView sd_setImageWithURL:motherLook.totalImageUrl placeholderImage:[UIImage imageNamed:@"shopCellHolder"]];
    
}
- (IBAction)cellBtn:(id)sender {
    UIButton *btn = sender;
    NSString *string = btn.titleLabel.text;
    NSLog(@"%@ %ld ",btn.superview.superview,(long)btn.superview.superview.tag);
    UITableViewCell *cell = (UITableViewCell *)btn.superview.superview;
    btn.tag = cell.tag;
    if (string && self.delegate && [self.delegate respondsToSelector:@selector(touchMotherLookCellBtn:)]) {
        [self.delegate touchMotherLookCellBtn:btn];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
