//
//  SearchListCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/22.
//
//

#import "SearchListCell.h"

@implementation SearchListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWith:(XEShopListInfo *)info{
    self.leftLable.text = info.des;
}
@end
