//
//  AppOfficeAppointmentCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/9/8.
//
//

#import "AppOfficeAppointmentCell.h"
#import "XEUIUtils.h"
#import "MyAttributedStringBuilder.h"

@interface AppOfficeAppointmentCell  ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *restNum;

@property (weak, nonatomic) IBOutlet UILabel *desLab;
@end


@implementation AppOfficeAppointmentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWith:(XEAppOfficeAppointmentInfo *)info{
    self.appBtn.layer.cornerRadius = 5;
    self.appBtn.layer.masksToBounds = YES;
    
    if ([info.total isEqualToString:@"0"]) {
        [self.appBtn setTitle:@"已满" forState:UIControlStateNormal];
        [self.appBtn setBackgroundColor:UIColorRGB(211, 211, 211)];
        self.appBtn.userInteractionEnabled = NO;
        self.restNum.hidden = YES;
        self.restNum.text = @"";
        self.restNum.frame = CGRectZero;
        self.appBtn.frame = CGRectMake(SCREEN_WIDTH - 25 -100, (self.contentView.frame.size.height - 30)/2, 80, 30);


    }
    else
    {
        self.restNum.text = [NSString stringWithFormat:@"还剩%@个名额",info.total];
        self.restNum.hidden = NO;

        [self.appBtn setBackgroundColor:UIColorRGB(0, 172, 38)];
        self.appBtn.userInteractionEnabled = YES;
        [self.appBtn setTitle:@"预约" forState:UIControlStateNormal];
        
        /**
         第三方 使用字符串判断里面是否存在所要的字符串 使之变为红色
         */
        MyAttributedStringBuilder *builder = [[MyAttributedStringBuilder alloc] initWithString:self.restNum.text];
        [builder includeString:info.total all:YES].textColor = [UIColor redColor];
        self.restNum.attributedText = builder.commit;
        
        self.appBtn.frame = CGRectMake(SCREEN_WIDTH - 25 -100, 22, 60, 30);
        self.restNum.frame = CGRectMake(SCREEN_WIDTH - 5 - 100, 57, 100, 20);

    }


    double price  = [info.xrprice doubleValue]*0.01;
    
    self.desLab.text = [NSString stringWithFormat:@"%@ 晓儿价 %.2f元",info.dname,price];
    
    /**
     第三方 使用字符串判断里面是否存在所要的字符串 使之变为红色
     */
    MyAttributedStringBuilder *builder = [[MyAttributedStringBuilder alloc] initWithString:self.desLab.text];
    [builder includeString:[NSString stringWithFormat:@"%.2f",price] all:YES].textColor = [UIColor redColor];
    NSRange rang = [self.desLab.text  rangeOfString:[self notRounding:price afterPoint:0]];
    [builder range:rang].font = [UIFont systemFontOfSize:17];
    self.desLab.attributedText = builder.commit;

    self.titleLab.text = [XEUIUtils dateDiscriptionAndWeekFromDate:info.resultBeginTime];
    

}

-(NSString *)notRounding:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}
- (void)addAppOfficeAppointmentCellTarget:(id)target action:(SEL)action{
    [self.appBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
