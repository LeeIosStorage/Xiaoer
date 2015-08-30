//
//  OrderWillPassCell.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/18.
//
//

#import "OrderWillPassCell.h"

@implementation OrderWillPassCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWith:(XEOrderWillPassInfo *)info{
    self.remain.layer.cornerRadius = 5;
    self.remain.layer.masksToBounds = YES;
    self.cardNum.text = info.cardNo;
    self.buyTime.text = info.buyTime;
    self.content.text = info.sercontent;
    self.remain.text = [NSString stringWithFormat:@"剩余%@次",info.remain];
    
    self.willPassTime.text = [self calculateWillPassTimeWith:info];
    
    
}
- (NSString *)calculateWillPassTimeWith:(XEOrderWillPassInfo *)info{
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *buyTime=[dateFormatter dateFromString:info.buyTime];
    NSDate *endTime=[dateFormatter dateFromString:info.endTime];
    NSTimeInterval interVal = [endTime timeIntervalSinceDate:buyTime];
    if (interVal > [info.len floatValue]*24*60*60) {
     //   NSLog(@"在卡券截至日期之前失效");
        NSDate *resultDate = [NSDate dateWithTimeInterval:[info.len floatValue]*24*60*60 sinceDate:buyTime];
        NSString *resultStr = [dateFormatter stringFromDate:resultDate];
        return resultStr;
    }else{
      //  NSLog(@"截至日就是不能使用时间");
        return info.endTime;
    }
    
    
}
@end
