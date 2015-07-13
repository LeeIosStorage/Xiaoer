//
//  ToyDetailCollectionFooterView.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/9.
//
//

#import "ToyDetailCollectionFooterView.h"

@implementation ToyDetailCollectionFooterView
- (UILabel *)desLab{
    if (!_desLab) {
        self.desLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 80, 20)];
        _desLab.text = @"购买数量";
    }
    return _desLab;
}
- (UIImageView *)line{
    if (!_line) {
        self.line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"s_n_set_line"]];
        _line.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    }
    return _line;
}
- (UIImageView *)backImageView{
    if (!_backImageView) {
        self.backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiajianback"]];
        _backImageView.frame = CGRectMake((SCREEN_WIDTH - 110)/2, 35, 110, 30);
        [self addSubview:_backImageView];
//        [_backImageView addSubview:self.addBtn];
//        [_backImageView addSubview:self.deleBtn];
    }
    return _backImageView;
}
- (UIButton *)addBtn{
    if (!_addBtn) {
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"jian-6p"] forState:UIControlStateNormal];
        _addBtn.frame = CGRectMake(0, 0, 30, 30);
        [_addBtn addTarget:self action:@selector(addBtnTouched) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _addBtn;
}
- (UIButton *)deleBtn{
    if (!_deleBtn) {
        self.deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleBtn setBackgroundImage:[UIImage imageNamed:@"jian"] forState:UIControlStateNormal];
        _deleBtn.frame = CGRectMake(110 - 30, 14, 30, 2);
        [_deleBtn addTarget:self action:@selector(deleteBtnTouched) forControlEvents:UIControlEventTouchUpInside];

    }
    return _deleBtn;
}
- (void)configureFooterView{
    [self backImageView];
    [self addSubview:self.line];
    [self addSubview:self.desLab];


}
- (void)addBtnTouched{
    NSLog(@"加");
    
}
- (void)deleteBtnTouched{
    NSLog(@"减");
}
@end
