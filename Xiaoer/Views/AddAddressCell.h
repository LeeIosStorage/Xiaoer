//
//  AddAddressCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/6/21.
//
//

#import <UIKit/UIKit.h>
@protocol cellTextFieldEndEditing <NSObject>

- (void)passLeftLableText:(NSString *)string
            textFieldtext:(NSString *)string;

@end
@interface AddAddressCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *leftLable;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
- (void)configureCellWith:(NSIndexPath *)indexPath
                 AndString:(NSString *)string;
@property (nonatomic,assign)id<cellTextFieldEndEditing> delegate;
@property (nonatomic,strong)UILabel *Chooselable;

@end
