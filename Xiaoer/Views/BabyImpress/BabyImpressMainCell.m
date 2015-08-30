//
//  BabyImpressMainCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/8/7.
//
//

#import "BabyImpressMainCell.h"


@interface BabyImpressMainCell  ()

@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UIImageView *imageVie;
@end

@implementation BabyImpressMainCell
- (UILabel *)title{
    if (!_title) {
        self.title = [[UILabel alloc]init];
        _title.numberOfLines = 0;
        _title.font = [UIFont systemFontOfSize:17];
    }
    return _title;
}
- (UIImageView *)imageVie{
    if (!_imageVie) {
        self.imageVie = [[UIImageView alloc]init];
    }
    return _imageVie;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWithDesStr:(NSString *)desStr imageStr:(NSString *)imageStr{
    self.titleLab.hidden = YES;
    self.mainImage.hidden = YES;
//    self.titleLab.text = desStr;
//    self.mainImage.image = [UIImage imageNamed:imageStr];
//    
//    CGRect titleFrame = self.titleLab.frame;
//    titleFrame.size.height = [self titleLabHeightWith:desStr];
////    self.titleLab.frame = titleFrame;
//    self.titleLab.frame = CGRectMake(20, 20, SCREEN_WIDTH - 40, [self titleLabHeightWith:desStr]);
//    
//    CGRect maimImageFrame = self.mainImage.frame;
//    maimImageFrame.origin.y = 20 + titleFrame.size.height + 40;
//    self.mainImage.frame = maimImageFrame;
//    self.mainImage.frame = CGRectMake(20, 20 + titleFrame.size.height + 40, SCREEN_WIDTH - 40, 200);
    self.title.text = desStr;
    self.imageVie.image = [UIImage imageNamed:imageStr];
    
    self.title.frame = CGRectMake(20, 20, SCREEN_WIDTH - 40, [self titleLabHeightWith:desStr]);
    
    self.imageVie.frame = CGRectMake(0, 20 + self.title.frame.size.height + 40, SCREEN_WIDTH , 200);
    [self addSubview:self.title];
    [self addSubview:self.imageVie];

}
- (CGFloat)titleLabHeightWith:(NSString *)str{
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName, nil];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(self.contentView.frame.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    NSLog(@"计算的height %f",rect.size.height);
    return rect.size.height ;
}
+ (CGFloat)contentHeightWith:(NSString *)desStr{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName, nil];
    CGRect rect = [desStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height + 260;
}
@end
