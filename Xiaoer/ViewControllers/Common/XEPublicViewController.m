//
//  XEPublicViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/20.
//
//

#import "XEPublicViewController.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "QHQnetworkingTool.h"

@interface XEPublicViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *imgIds;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, assign) int maxTitleTextLength;
@property (nonatomic, assign) int maxDescriptionLength;
@property (strong, nonatomic) IBOutlet UIView *inputContainerView;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UILabel *placeHolderLabel;

@property (strong, nonatomic) IBOutlet UIView *toolbarContainerView;
@property (strong, nonatomic) IBOutlet UIButton *openStateButton;

-(IBAction)openStateAction:(id)sender;

@end

@implementation XEPublicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    _images = [[NSMutableArray alloc] init];
    _imgIds = [[NSMutableArray alloc] init];
    
    _maxTitleTextLength = 28;
    _maxDescriptionLength = 1000;
    CGRect frame = self.placeHolderLabel.frame;
    CGSize textSize = [XECommonUtils sizeWithText:self.placeHolderLabel.text font:self.placeHolderLabel.font width:SCREEN_WIDTH-15*2];
    frame.size.height = textSize.height;
    self.placeHolderLabel.frame = frame;
    
    self.openStateButton.selected = NO;
    
    [self refreshViewUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews
{
    //title
    [self setTitle:@"发话题"];
    if (_publicType == Public_Type_Expert) {
        [self setTitle:[NSString stringWithFormat:@"向%@提问",_doctorInfo.doctorName]];
    }
    [self setRightButtonWithTitle:@"发送" selector:@selector(sendAction:)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)publicAskExpert{
    
    [XEProgressHUD AlertLoading:@"发送中..."];
    NSString *overt = [NSString stringWithFormat:@"%d",self.openStateButton.selected];
//    __weak XEPublicViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] publishQuestionWithExpertId:_doctorInfo.doctorId uid:[XEEngine shareInstance].uid title:_titleTextField.text content:_descriptionTextView.text overt:overt imgs:nil tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        [XEProgressHUD AlertLoadDone];
        [self.pullRefreshView finishedLoading];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg];
            return;
        }
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
        
    }tag:tag];
    
    
}

-(void)updateBabyAvatar:(NSArray *)data{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSData *imgData in data) {
        QHQFormData* pData = [[QHQFormData alloc] init];
        pData.data = imgData;
        pData.name = @"img";
        pData.filename = @"img";
        pData.mimeType = @"image/png";
        [dataArray addObject:pData];
    }
    
    [XEProgressHUD AlertLoading:@"图片上传中..."];
    __weak XEPublicViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] updateExpertQuestionWithImgs:dataArray tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"上传失败";
            }
            return;
        }
        [XEProgressHUD AlertSuccess:@"上传成功."];
        weakSelf.imgIds = (NSMutableArray *)[jsonRet arrayObjectForKey:@"object"];
        
    }tag:tag];
}

#pragma mark - custom
-(void)refreshViewUI{
    
//    self.openStateButton.layer.cornerRadius = 12;
//    self.openStateButton.layer.masksToBounds = YES;
    if (self.openStateButton.selected) {
        [self.openStateButton setTitle:@"私密" forState:0];
    }else{
        [self.openStateButton setTitle:@"公开" forState:0];
    }
}

-(void)sendAction:(id)sender{
    
    if (_titleTextField.text.length == 0) {
        [XEProgressHUD lightAlert:@"请输入标题"];
        return;
    }
    if ([XECommonUtils getHanziTextNum:_titleTextField.text] < 4) {
        [XEProgressHUD lightAlert:@"标题太短了"];
        return;
    }
    if (_descriptionTextView.text.length == 0) {
        [XEProgressHUD lightAlert:@"请输入内容"];
        return;
    }
    if ([XECommonUtils getHanziTextNum:_descriptionTextView.text] < 10) {
        [XEProgressHUD lightAlert:@"内容太短了"];
        return;
    }
    
    [self publicAskExpert];
}

-(IBAction)openStateAction:(id)sender{
    self.openStateButton.selected = !self.openStateButton.selected;
    [self refreshViewUI];
}

- (void)updatePlaceHolderLabel{
    if (_descriptionTextView.text.length > 0) {
        _placeHolderLabel.hidden = YES;
    }else{
        _placeHolderLabel.hidden = NO;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        return NO;
    }
    if (!string.length && range.length > 0) {
        return YES;
    }
    NSString *oldString = [textField.text copy];
    NSString *newString = [oldString stringByReplacingCharactersInRange:range withString:string];
    
    int newLength = [XECommonUtils getHanziTextNum:newString];
    if(newLength >= _maxTitleTextLength && textField.markedTextRange == nil) {
        _titleTextField.text = [XECommonUtils getHanziTextWithText:newString maxLength:_maxTitleTextLength];
        return NO;
    }
    return YES;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [self updatePlaceHolderLabel];
    if (text.length == 0) {
        return YES;
    }
    int newLength = [XECommonUtils getHanziTextNum:[textView.text stringByAppendingString:text]];
    if(newLength >= _maxDescriptionLength && textView.markedTextRange == nil) {
        _descriptionTextView.text = [XECommonUtils getHanziTextWithText:[textView.text stringByReplacingCharactersInRange:range withString:text] maxLength:_maxDescriptionLength];
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
    
    if ([XECommonUtils getHanziTextNum:textView.text] > _maxDescriptionLength && textView.markedTextRange == nil) {
        textView.text = [XECommonUtils getHanziTextWithText:textView.text maxLength:_maxDescriptionLength];
    }
}


-(void) keyboardWillShow:(NSNotification *)note{
    
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    //    CGRect containerFrame = _toolbarContainerView.frame;
    //    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    CGRect toolbarFrame = _toolbarContainerView.frame;
    toolbarFrame.origin.y = self.view.bounds.size.height - keyboardBounds.size.height - toolbarFrame.size.height;
    _toolbarContainerView.frame = toolbarFrame;
    // commit animations
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    CGRect toolbarFrame = _toolbarContainerView.frame;
    toolbarFrame.origin.y = self.view.bounds.size.height - toolbarFrame.size.height;
    _toolbarContainerView.frame = toolbarFrame;
    
    // commit animations
    [UIView commitAnimations];
}

@end
