//
//  OrderInfomationCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/2.
//
//

#import <UIKit/UIKit.h>

@protocol orderInfocellTextFieldEndEditing <NSObject>
/**
 * 传递textfield 信息
 */
- (void)passOrderInfocellLeftLableText:(NSString *)leftStr
            textFieldtext:(NSString *)textFieldText
                          textFieldTag:(NSInteger )tag;
/**
 *  检查控制器中选择器的状态
 */
- (void)checkOrderInfomationPickerViewState;

@end


@interface OrderInfomationCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *leftLab;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;
- (void)configurcellwithIndexPath:(NSIndexPath *)indexPath
                          leftStr:(NSString *)leftStr
                         rightStr:(NSString *)rightStr;
@property (nonatomic,assign)id<orderInfocellTextFieldEndEditing>delegate;
@end
