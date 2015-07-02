//
//  OrderInfomationCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/2.
//
//

#import <UIKit/UIKit.h>

@protocol orderInfocellTextFieldEndEditing <NSObject>

- (void)passOrderInfocellLeftLableText:(NSString *)leftStr
            textFieldtext:(NSString *)textFieldText;

@end


@interface OrderInfomationCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *leftLab;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;
- (void)configurcellwithIndexPath:(NSIndexPath *)indexPath
                          leftStr:(NSString *)leftStr;
@property (nonatomic,assign)id<orderInfocellTextFieldEndEditing>delegate;
@end
