//
//  GoToPayCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/21.
//
//

#import "GoToPayCell.h"

@implementation GoToPayCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWith:(NSIndexPath *)indexpath{
    switch (indexpath.row) {
        case 0:
            self.leftImg.image = [UIImage imageNamed:@"Alipay"];
            self.rightTitle.text = @"支付宝收银台";
            self.rightDescribe.text= @"快捷支付,推荐支付宝注册用户使用";
            break;
        case 1:
            self.leftImg.image = [UIImage imageNamed:@"weixin"];
            self.rightTitle.text = @"微信支付";
            self.rightDescribe.text= @"微信支付";
//            self.leftImg.image = [UIImage imageNamed:@"Alipay"];
//            self.rightTitle.text = @"支付宝手机网页支付";
//            self.rightDescribe.text= @"快捷支付,推荐支付宝注册用户使用";
            break;
        case 2:

            break;
            
        default:
            break;
    }
}
@end
