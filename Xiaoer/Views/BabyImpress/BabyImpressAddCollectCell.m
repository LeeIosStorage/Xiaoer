//
//  BabyImpressAddCollectCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/27.
//
//

#import "BabyImpressAddCollectCell.h"

@implementation BabyImpressAddCollectCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)addBtnTouched:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(babyImpressAddbtnTouched)]) {
        [self.delegate babyImpressAddbtnTouched];
    }
}

@end
