//
//  XEInputViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/9.
//
//

#import "XEInputViewController.h"
#import "XEAlertView.h"

@interface XEInputViewController ()<UITextViewDelegate>{
    int  _remainTextNum;
}
@property (strong, nonatomic) IBOutlet UITextView *inputTextView;
@property (strong, nonatomic) IBOutlet UIView *inputView;
@property (strong, nonatomic) IBOutlet UIImageView *inputBgImageView;
@property (strong, nonatomic) IBOutlet UILabel *remainNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeHolderLabel;

@end

@implementation XEInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _inputTextView.keyboardType = _keyboardType;
    
    self.view.backgroundColor = UIColorRGB(240, 240, 240);
//    _inputBgImageView.image = [[UIImage imageNamed:@"verify_commit_bg"] stretchableImageWithLeftCapWidth:124 topCapHeight:20];
    
    if (_titleText != nil) {
        [self setTitle:_titleText];
        self.placeHolderLabel.text = [NSString stringWithFormat:@"请输入%@",_titleText];
    }
    
    if ([_toolRightType isEqualToString:@"Finish"]) {
        [self.titleNavBarRightBtn setTitle:@"保存" forState:0];
    }else{
        [self.titleNavBarRightBtn setTitle:@"完成" forState:0];
    }
    
    if (_maxTextLength == 0) {
        _maxTextLength = 40;
    }
    
    _remainTextNum = _maxTextLength;
    if (_oldText) {
        _inputTextView.text = _oldText;
    }
    if (!_maxTextViewHight) {
        _maxTextViewHight = 150;
    }
    
    CGRect viewRect = _inputView.frame;
    viewRect.size.height = _maxTextViewHight;
    _inputView.frame = viewRect;
    
    CGRect textViewRect = _inputTextView.frame;
    textViewRect.size.height = _maxTextViewHight-10;
    _inputTextView.frame = textViewRect;
    
    [self updateRemainNumLabel];
    [self updatePlaceHolderLabel];
    
    [self.inputTextView becomeFirstResponder];
}

-(void)initNormalTitleNavBarSubviews
{
    //title
    [self setRightButtonWithTitle:@"保存" selector:@selector(confirmAction:)];
}

- (void)viewDidUnload {
    [self setInputTextView:nil];
    [self setRemainNumLabel:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)updatePlaceHolderLabel{
    if (_inputTextView.text.length > 0) {
        _placeHolderLabel.hidden = YES;
    }else{
        _placeHolderLabel.hidden = NO;
    }
}

- (void)updateRemainNumLabel{
    int existTextNum = [XECommonUtils getHanziTextNum:_inputTextView.text];
    _remainTextNum = _maxTextLength - existTextNum;
    _remainNumLabel.text = [[NSNumber numberWithInt:_remainTextNum] description];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [self updatePlaceHolderLabel];
    if (text.length == 0) {
        return YES;
    }
    int newLength = [XECommonUtils getHanziTextNum:[textView.text stringByAppendingString:text]];
    if(newLength >= _maxTextLength && textView.markedTextRange == nil) {
        _remainTextNum = 0;
        _inputTextView.text = [XECommonUtils getHanziTextWithText:[textView.text stringByReplacingCharactersInRange:range withString:text] maxLength:_maxTextLength];
        [self updateRemainNumLabel];
        return NO;
    }
    
    //bug fix输入表情后，连续输入回车后，光标在textview下边，输入文字后，光标也未上升一行，导致输入文字看不到
    [textView scrollRangeToVisible:range];
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
    [self updatePlaceHolderLabel];
    if (textView.markedTextRange != nil) {
        return;
    }
    
    if ([XECommonUtils getHanziTextNum:textView.text] > _maxTextLength && textView.markedTextRange == nil) {
        textView.text = [XECommonUtils getHanziTextWithText:textView.text maxLength:_maxTextLength];
    }
    [self updateRemainNumLabel];
}

- (void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    [self setTitle:titleText];
}
- (void)confirmAction:(id)sender {
    int existTextNum = [XECommonUtils getHanziTextNum:_inputTextView.text];
    if (existTextNum < _minTextLength) {
        XEAlertView *alertView = [[XEAlertView alloc] initWithTitle:@"温馨提示！" message:[NSString stringWithFormat:@"不能少于%d个字",_minTextLength] cancelButtonTitle:@"知道了"];
        
        [alertView show];
        return;
    }
    
    _inputTextView.text = [[_inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (self.delegate) {
        [self.delegate inputViewControllerWithText:_inputTextView.text];
    }
    [self backAction:nil];
}

@end
