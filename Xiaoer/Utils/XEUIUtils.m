//
//  XEUIUtils.m
//  Xiaoer
//
//  Created by KID on 14/12/31.
//
//

#import "XEUIUtils.h"
#import "XEAlertView.h"

@implementation XEUIUtils

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark -- adapter ios 7
+(BOOL)updateFrameWithView:(UIView *)view superView:(UIView *)superView isAddHeight:(BOOL)isAddHeight
{
    return [self updateFrameWithView:view superView:superView isAddHeight:isAddHeight delHeight:STAUTTAR_DEFAULT_HEIGHT];
}

+(BOOL)updateFrameWithView:(UIView *)view superView:(UIView *)superView isAddHeight:(BOOL)isAddHeight delHeight:(CGFloat)height
{
    CGRect viewFrame = view.frame;
    if (isAddHeight) {
        viewFrame.size.height += height;
    }else{
        //view是相对super和底部的就不改位置
        UIViewAutoresizing resizeMask = view.autoresizingMask;
        if (resizeMask & UIViewAutoresizingFlexibleTopMargin) {
            return YES;
        }
        
        //如果tableview的大小与parent大小是一样的话就不移
        if (view.frame.size.height >= superView.frame.size.height) {
            return NO;
        }
        
        //如果view是跟scrollview并从parent的顶开始的也不移
        if (view.frame.origin.y <= 0 && [view isKindOfClass:[UIScrollView class]]) {
            return NO;
        }
        
        viewFrame.origin.y += height;
        //随父view的大小变而改变的都变大小
        if ((resizeMask & UIViewAutoresizingFlexibleHeight)) {
            viewFrame.size.height -= height;
        }
    }
    view.frame = viewFrame;
    
    return YES;
}

+(void)showAlertWithMsg:(NSString *)msg
{
    [self showAlertWithMsg:msg title:nil];
}

+(void)showAlertWithMsg:(NSString *)msg title:(NSString *) title
{
    XEAlertView *alert = [[XEAlertView alloc] initWithTitle:title message:msg cancelButtonTitle:@"确定"];
    [alert show];
}

+ (int)getAgeByDate:(NSDate*)date{
    NSDate* nowDate = [NSDate date];
    NSCalendar * calender = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *comps = [calender components:unitFlags fromDate:date];
    NSDateComponents *compsNow = [calender components:unitFlags fromDate:nowDate];
    return (int)compsNow.year - (int)comps.year;
}

+(NSDateFormatter *) dateFormatterOFUS {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    return dateFormatter;
}

static NSDateFormatter * s_dateFormatterOFUS = nil;
static bool dateFormatterOFUSInvalid ;
+ (NSDate*)dateFromUSDateString:(NSString*)string{
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    @synchronized(self) {
        if (s_dateFormatterOFUS == nil || dateFormatterOFUSInvalid) {
            s_dateFormatterOFUS = [[NSDateFormatter alloc] init];
            [s_dateFormatterOFUS setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//EEE MMM d HH:mm:ss zzzz yyyy
            NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [s_dateFormatterOFUS setLocale:usLocale];
            dateFormatterOFUSInvalid = NO;
        }
    }
    
    NSDateFormatter* dateFormatter = s_dateFormatterOFUS;
    NSDate* date = nil;
    @synchronized(dateFormatter){
        @try {
            date = [dateFormatter dateFromString:string];
        }
        @catch (NSException *exception) {
            //异常了以后处理有些问题,有可能会crash
            dateFormatterOFUSInvalid = YES;
        }
    }
    return date;
}

+(NSDateComponents *) dateComponentsFromDate:(NSDate *) date{
    if (!date) {
        return nil;
    }
    NSCalendar * calender = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit ;
    return [calender components:unitFlags fromDate:date];
}

+ (NSString*)dateDiscriptionFromDate:(NSDate*)date{
    NSString *_timestamp = nil;
    NSDate* nowDate = [NSDate date];
    if (date == nil) {
        return @"";
    }
    NSCalendar * calender = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents *comps = [calender components:unitFlags fromDate:date];
    NSDateComponents *compsNow = [calender components:unitFlags fromDate:nowDate];
    
    if (comps.year == compsNow.year){
        _timestamp = [NSString stringWithFormat:@"%ld月%ld日 %02ld:%02ld", comps.month, comps.day, comps.hour, comps.minute];
    } else {
        _timestamp = [NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%02ld", comps.year, comps.month, comps.day, comps.hour, comps.minute];
    }
    
    return _timestamp;
}

+ (NSString*)dateDiscriptionFromNowBk:(NSDate*)date{
    NSString *_timestamp = nil;
    NSDate* nowDate = [NSDate date];
    if (date == nil) {
        return @"";
    }
    int distance = [nowDate timeIntervalSinceDate:date];
    if (distance < 0) distance = 0;
    NSCalendar * calender = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents *comps = [calender components:unitFlags fromDate:date];
    NSDateComponents *compsNow = [calender components:unitFlags fromDate:nowDate];
    
    if (distance < 0) {
        distance = 0;
    }
    if (distance < 60) {
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, @"刚刚"];
    } else if (distance < 60*60) {
        _timestamp = [NSString stringWithFormat:@"%d%@", distance/60, @"分钟前"];
    }else if (distance < 60*60*24) {
        if (comps.day == compsNow.day)
        {
            _timestamp = [NSString stringWithFormat:@"今天 %02ld:%02ld", comps.hour,comps.minute];
        }
        else
            _timestamp = [NSString stringWithFormat:@"昨天 %02ld:%02ld", comps.hour,comps.minute];
    }else if (distance < 60*60*24*2) {
        _timestamp = [NSString stringWithFormat:@"昨天 %02ld:%02ld", comps.hour,comps.minute];
    }else if (distance < 60*60*24*3) {
        _timestamp = [NSString stringWithFormat:@"前天 %02ld:%02ld", comps.hour,comps.minute];
    }else {
        if (comps.year == compsNow.year){
            _timestamp = [NSString stringWithFormat:@"%ld月%ld日 %02ld:%02ld", comps.month, comps.day, comps.hour, comps.minute];
        } else {
            _timestamp = [NSString stringWithFormat:@"%04ld年%02ld月%02ld日 %02ld:%02ld", comps.year, comps.month, comps.day, comps.hour, comps.minute];
        }
    }
    
    return _timestamp;
}

+ (NSString*)dateDiscription1FromNowBk:(NSDate*)date{
    NSString *_timestamp = nil;
    NSDate* nowDate = [NSDate date];
    if (date == nil) {
        return @"";
    }
    int distance = [nowDate timeIntervalSinceDate:date];
    if (distance < 0) distance = 0;
//    NSCalendar * calender = [NSCalendar currentCalendar];
//    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit |
//    NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit | NSWeekdayCalendarUnit;
//    NSDateComponents *comps = [calender components:unitFlags fromDate:date];
//    NSDateComponents *compsNow = [calender components:unitFlags fromDate:nowDate];
    
    if (distance < 0) {
        distance = 0;
    }
    if (distance < 60*60*24*30) {
        _timestamp = [NSString stringWithFormat:@"%d%@", distance/60/60/24, @"天"];
    } else if (distance < 60*60*24*365) {
        _timestamp = [NSString stringWithFormat:@"%d%@%d%@",distance/60/60/24/30,@"个月",distance/60/60/24%30,@"天"];
    } else if (distance < 60*60*24*365*6){
        _timestamp = [NSString stringWithFormat:@"%d%@%d%@",distance/60/60/24/365,@"岁",distance/60/60/24%365/30,@"个月"];
    } else {
        _timestamp = [NSString stringWithFormat:@"%d%@",distance/60/60/24/365,@"岁"];
    }
    
//    if (distance < 60) {
//        _timestamp = [NSString stringWithFormat:@"%d%@", distance, @"秒前"];
//    } else if (distance < 60*60) {
//        _timestamp = [NSString stringWithFormat:@"%d%@", distance/60, @"分钟前"];
//    }else if (distance < 60*60*24) {
//        _timestamp = [NSString stringWithFormat:@"%d%@", distance/60/60, @"小时前"];
//    }else if (distance < 60*60*24*7) {
//        _timestamp = [NSString stringWithFormat:@"%d%@", distance/60/60/24, @"天前"];
//    }else {
//        if (comps.year == compsNow.year){
//            _timestamp = [NSString stringWithFormat:@"%02d-%02d", comps.month,comps.day];
//        } else {
//            _timestamp = [NSString stringWithFormat:@"%04d-%02d-%02d", comps.year,comps.month,comps.day];
//        }
//    }
    
    return _timestamp;
}

+ (NSString*)documentOfCameraDenied
{
    return @"请检查设备是否有相机功能";
}
+ (NSString*)documentOfAVCaptureDenied
{
    return @"无法访问你的相机。\n请到手机系统的[设置]->[隐私]->[相机]允许微米使用相机";
}

+ (NSString*)documentOfLocationDenied {
    return @"无法获取你的位置信息。\n请到手机系统的[设置]->[隐私]->[定位服务]中打开定位服务，并允许微米使用定位服务";
}
@end
