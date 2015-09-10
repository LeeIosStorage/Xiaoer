//
//  AppOrderInfomationCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/9/8.
//
//

#import "AppOrderInfomationCell.h"
#import "XEUIUtils.h"
@interface AppOrderInfomationCell  ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *leftLable;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation AppOrderInfomationCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWith:(NSIndexPath *)indexpath{
    self.textField.delegate = self;
    switch (indexpath.row) {
        case 0:
            self.leftLable.text = @"就诊人";
            break;
        case 1:
            self.leftLable.text = @"身份账号";
            
            break;
        case 2:
            self.leftLable.text = @"联系手机";
            self.textField.keyboardType = UIKeyboardTypeNumberPad;

            break;
        default:
            break;
    }
}

#pragma mark textField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.delegate || [self.delegate respondsToSelector:@selector(passLeftLabTextWith:textFieldText:)]) {
        [self.delegate passLeftLabTextWith:self.leftLable.text textFieldText:textField.text];
    }
    
}
- (void)configureVerifyCellWith:(NSIndexPath *)indexpath dic:(NSDictionary *)dic
{
    self.textField.userInteractionEnabled = NO;
    self.leftLable.textColor = [UIColor darkTextColor];
    self.textField.textColor = [UIColor darkTextColor];
    switch (indexpath.section) {
        case 0:
            if (indexpath.row == 0)
            {
                if (dic[@"orderMsg"][@"hospitalName"])
                {
                    self.textField.text = dic[@"orderMsg"][@"hospitalName"];
                }
                self.leftLable.text = @"预约医院:";
            }
            if (indexpath.row == 1)
            {
                if (dic[@"orderMsg"][@"hospitalDepartmentName"])
                {
                    self.textField.text = dic[@"orderMsg"][@"hospitalDepartmentName"];
                }
                self.leftLable.text = @"挂号科室:";

            }
            if (indexpath.row == 2)
            {
                if (dic[@"orderMsg"][@"beginTime"])
                {
                    NSString *dateStr = dic[@"orderMsg"][@"beginTime"];
                        NSDateFormatter *dateFormatter = [XEUIUtils dateFormatterOFUS];
                        NSDate *date =  [dateFormatter dateFromString:dateStr];
                    self.textField.text = [XEUIUtils dateDiscriptionAndWeekFromDate:date];
                }
                self.leftLable.text = @"预约时间:";

            }
            break;
        case 1:
            if (indexpath.row == 0)
            {
                if (dic[@"orderNo"])
                {
                    self.textField.text = dic[@"orderNo"];
                }
                self.leftLable.text = @"订单编号:";

            }
            if (indexpath.row == 1)
            {
                if (dic[@"money"])
                {
                    CGFloat money = [dic[@"money"] floatValue];
                    self.textField.text = [NSString stringWithFormat:@"%.2f",money*0.01];
                }
                self.leftLable.text = @"订单金额:";

            }
            if (indexpath.row == 2)
            {
                self.leftLable.text = @"支付方式:";
                self.textField.text = @"在线支付";

            }
            break;
            
        default:
            break;
    }
}
@end
