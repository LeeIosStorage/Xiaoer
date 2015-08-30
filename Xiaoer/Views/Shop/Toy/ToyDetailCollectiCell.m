//
//  ToyDetailCollectiCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/9.
//
//

#import "ToyDetailCollectiCell.h"

@implementation ToyDetailCollectiCell

- (void)awakeFromNib {
    
    // Initialization code
}
- (void)configureCellWithStr:(NSString *)str indexPath:(NSIndexPath *)indexPath ifChangeBackColorToSkc:(BOOL)change{
    
    
    self.btn.layer.cornerRadius = 5;
    self.btn.layer.masksToBounds = YES;
    self.btn.tag = indexPath.section;
    self.btn.layer.borderWidth = 1;
    self.btn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.btn setTitle:str forState:UIControlStateNormal];
    
    if (change == YES) {
        self.btn.backgroundColor = SKIN_COLOR;
        self.btn.layer.borderColor = SKIN_COLOR.CGColor;
    }else{
        self.btn.backgroundColor = [UIColor whiteColor];
        self.btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
}

- (IBAction)btnTouched:(id)sender {
    NSLog(@"1");
    
    UIButton *button = (UIButton *)sender;
    NSLog(@"%@",button.backgroundColor);
    NSLog(@"%ld %ld ",button.superview.superview.tag,button.tag);

    if (button.backgroundColor == [UIColor whiteColor]) {
        NSLog(@"2");

        button.backgroundColor = SKIN_COLOR;
    }else {
        NSLog(@"3");
        button.backgroundColor = [UIColor whiteColor];
    }
    NSString *title = button.titleLabel.text;
    NSLog(@"title == %@",title);
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchBtnwith:btnTag:)] ) {
        [self.delegate touchBtnwith:title btnTag:button.tag];
    }
}


@end
