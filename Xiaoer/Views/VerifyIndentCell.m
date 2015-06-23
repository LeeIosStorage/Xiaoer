//
//  VerifyIndentCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/23.
//
//

#import "VerifyIndentCell.h"

@implementation VerifyIndentCell


//- (UIImageView *)imageView{
//    if (!_imageVie) {
//        self.imageVie = [[UIImageView alloc]init];
//        _imageVie.backgroundColor = [UIColor redColor];
//        _imageVie.frame = CGRectMake(15, 10, 80, 80);
//    }
//    return _imageVie;
//}
- (UILabel *)describe{
    if (!_describe) {
        self.describe = [[UILabel alloc]initWithFrame:CGRectMake(110, 15, 220, 20)];
        _describe.backgroundColor = [UIColor redColor];
    }
    return _describe;
}
- (void)awakeFromNib {
    // Initialization code
}
- (void)configureCellWith:(UIView *)view andIndesPath:(NSIndexPath *)indexPath {
    self.imageVie.hidden = NO;
    self.titleLab.hidden = NO;
    self.priceLab.hidden = NO;
    if (!view) {

        //不存在的时候让xib写的东西隐藏
        for (UIView *obj in self.subviews) {
            if (obj.tag > 99 && obj.tag < 104) {
                NSLog(@"找到");
                obj.hidden = YES;
            }else{
                
            }
        }

        
    }else{
        
        //存在的时候不让xib写的东西隐藏
        if (view.tag > 99 && view.tag < 104) {
            view.hidden = NO;
        }
        self.imageVie.hidden = YES;
        self.titleLab.hidden = YES;
        self.priceLab.hidden = YES;

        [self addSubview:view];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
