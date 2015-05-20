//
//  CardInfoVerifyCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/5/18.
//
//

#import <UIKit/UIKit.h>

@protocol cellTextFieldEndEditing <NSObject>

- (void)passLeftLableText:(NSString *)string
            textFieldtext:(NSString *)string;

@end

@interface CardInfoVerifyCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *leftLable;
@property (weak, nonatomic) IBOutlet UITextField *infoField;
@property (nonatomic,assign)id<cellTextFieldEndEditing> delegate;
- (void)configureCellWith:(NSArray *)array;
@end
