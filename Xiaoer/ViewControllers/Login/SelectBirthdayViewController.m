//
//  SelectBirthdayViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/12.
//
//

#import "SelectBirthdayViewController.h"

@interface SelectBirthdayViewController ()
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)datePickerValueChanged:(id)sender;

@end

@implementation SelectBirthdayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.oldDate) {
        [_datePicker setDate:self.oldDate];
    }else{
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:1];
        [comps setMonth:1];
        [comps setYear:2000];
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *date = [gregorian dateFromComponents:comps];
        
        
        [_datePicker setDate:date];
    }
    _datePicker.maximumDate = [NSDate date];
    
    NSCalendar * calender = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *compsNow = [calender components:unitFlags fromDate:[NSDate date]];
    compsNow.year -= 30;
    _datePicker.minimumDate = [calender dateFromComponents:compsNow];
    if (_maximumDateAddYear > 0) {
        compsNow.year += 30 + _maximumDateAddYear;
        _datePicker.maximumDate = [calender dateFromComponents:compsNow];
    }
    [self setValueByDate:_datePicker.date];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews
{
    [self setTitle:@"选择日期"];
    [self setRightButtonWithTitle:@"完成" selector:@selector(saveAction:)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewDidUnload {
    [self setDatePicker:nil];
    [super viewDidUnload];
}
- (void)saveAction:(id)sender{
    //    [super backAction:nil];
    [self backAction:nil];
    if (self.delegate) {
        [self.delegate SelectBirthdayWithDate:_datePicker.date];
    }
}
- (IBAction)datePickerValueChanged:(id)sender {
    NSLog(@"%@", _datePicker.date.description);
    [self setValueByDate:_datePicker.date];
}
- (BOOL)setValueByDate:(NSDate*)date{
//    NSDate* nowDate = [NSDate date];
//    NSCalendar * calender = [NSCalendar currentCalendar];
//    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit |
//    NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
//    NSDateComponents *comps = [calender components:unitFlags fromDate:date];
//    NSDateComponents *compsNow = [calender components:unitFlags fromDate:nowDate];
    
    return YES;
}

@end
