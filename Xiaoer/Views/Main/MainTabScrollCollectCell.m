//
//  MainTabScrollCollectCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/4.
//
//

#import "MainTabScrollCollectCell.h"




@implementation MainTabScrollCollectCell

//- (UILabel *)titleLable{
//    if (!_titleLable) {
//        self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(20 ,self.imageView.frame.size.height + 5+ 5, self.imageView.frame.size.width, 30)];
//        _titleLable.font = [UIFont systemFontOfSize:12];
//        _titleLable.textAlignment = NSTextAlignmentLeft;
//        _titleLable.textColor = [UIColor redColor];
//        [self.contentView addSubview:_titleLable];
//    }
//    return _titleLable;
//}
//- (UIImageView *)imageView{
//    if (!_imageView) {
//        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, (self.contentView.frame.size.width - 20* 2), (self.contentView.frame.size.width - 20* 2))];
//        _imageView.backgroundColor = [UIColor purpleColor];
//        [self.contentView addSubview:_imageView];
//    }
//    return _imageView;
//}
//- (UILabel *)newPrices{
//    if (!_newPrices) {
//        self.newPrices = [[UILabel alloc]initWithFrame:CGRectMake(20,self.imageView.frame.size.height + 5+ 5 + 30, 40, 10)];
//        _newPrices.backgroundColor = [UIColor redColor];
//        [self.contentView addSubview:_newPrices];
//    }
//    return _newPrices;
//}
//- (UILabel *)oldPrices{
//    if (!_oldPrices) {
//        self.oldPrices = [[UILabel alloc]initWithFrame:CGRectMake(65, self.imageView.frame.size.height + 5+ 5 + 30, 60, 10)];
//        _oldPrices.backgroundColor = [UIColor redColor];
//        [self.contentView addSubview:_oldPrices];
//    }
//    return _oldPrices;
//}
//- (UILabel *)selled{
//    if (!_selled) {
//        self.selled = [[UILabel alloc]initWithFrame:CGRectMake(20, self.imageView.frame.size.height + 5+ 5 + 30 + 15, 60, 10)];
//        _selled.backgroundColor = [UIColor redColor];
//        [self.contentView addSubview:_selled];
//    }
//    return _selled;
//}


- (void)awakeFromNib {
    // Initialization code
}
- (void)configure:(NSString *)color{

    self.titlelable.text =  color;
}

@end
