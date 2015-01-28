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
#import "XEActionSheet.h"
#import "AVCamUtilities.h"
#import "XEImagePickerController.h"
//#import "WSAssetPickerController.h"
#import "WSAssetPicker.h"
#import "UIImage+ProportionalFill.h"
#import "GMGridViewLayoutStrategies.h"
#import "GMGridViewCell+Extended.h"

#define MAX_IMAGES_NUM 9
#define ONE_IMAGE_HEIGHT  44
#define item_spacing  4

@interface XEPublicViewController ()<UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,WSAssetPickerControllerDelegate,GMGridViewDataSource, GMGridViewActionDelegate>

@property (nonatomic, strong) NSMutableArray *imgIds;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, assign) int maxTitleTextLength;
@property (nonatomic, assign) int maxDescriptionLength;

@property (nonatomic, assign) int topicType;
@property (strong, nonatomic) IBOutlet UIView *topicTypeSelectContainerView;
@property (strong, nonatomic) IBOutlet UIView *topicTypeContainerView;
@property (strong, nonatomic) IBOutlet UIButton *topicTypeBtn;
@property (strong, nonatomic) IBOutlet UIView *inputContainerView;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UILabel *placeHolderLabel;

@property (strong, nonatomic) IBOutlet UIView *toolbarContainerView;
@property (strong, nonatomic) IBOutlet UIButton *openStateButton;
@property (strong, nonatomic) IBOutlet GMGridView *imageGridView;

-(IBAction)topicTypeAction:(id)sender;
-(IBAction)openStateAction:(id)sender;
-(IBAction)photoAction:(id)sender;
-(IBAction)expressionAction:(id)sender;

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
    
    NSInteger spacing = item_spacing;
    _imageGridView.style = GMGridViewStyleSwap;
    _imageGridView.itemSpacing = spacing;
    _imageGridView.minEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _imageGridView.centerGrid = NO;
    _imageGridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontal];
    _imageGridView.actionDelegate = self;
    _imageGridView.showsHorizontalScrollIndicator = NO;
    _imageGridView.showsVerticalScrollIndicator = NO;
    _imageGridView.dataSource = self;
    _imageGridView.scrollsToTop = NO;
    _imageGridView.delegate = self;
    
    _maxTitleTextLength = 28;
    _maxDescriptionLength = 1000;
    CGRect frame = self.placeHolderLabel.frame;
    CGSize textSize = [XECommonUtils sizeWithText:self.placeHolderLabel.text font:self.placeHolderLabel.font width:SCREEN_WIDTH-15*2];
    frame.size.height = textSize.height;
    self.placeHolderLabel.frame = frame;
    
    _topicType = 0;
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
    [self setRightButtonWithTitle:@"发布" selector:@selector(sendAction:)];
    if (_publicType == Public_Type_Expert) {
        [self setTitle:[NSString stringWithFormat:@"向%@提问",_doctorInfo.doctorName]];
        [self setRightButtonWithTitle:@"发送"];
    }
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
    
    NSString *imgs = nil;
    if (self.imgIds.count > 0) {
        imgs = [XECommonUtils stringSplitWithCommaForIds:self.imgIds];
    }
    [XEProgressHUD AlertLoading:@"发送中..."];
    NSString *overt = [NSString stringWithFormat:@"%d",self.openStateButton.selected];
    __weak XEPublicViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] publishQuestionWithExpertId:_doctorInfo.doctorId uid:[XEEngine shareInstance].uid title:_titleTextField.text content:_descriptionTextView.text overt:overt imgs:imgs tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg];
            return;
        }
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    }tag:tag];
}

- (void)publicTopic{
    
    NSString *imgs = nil;
    if (self.imgIds.count > 0) {
        imgs = [XECommonUtils stringSplitWithCommaForIds:self.imgIds];
    }
    [XEProgressHUD AlertLoading:@"发送中..."];
        __weak XEPublicViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] publishTopicWithUserId:[XEEngine shareInstance].uid title:_titleTextField.text content:_descriptionTextView.text cat:1 imgs:imgs tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg];
            return;
        }
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    }tag:tag];
}

-(void)updateImage:(NSArray *)data{
    
    if (data.count == 0) {
        return;
    }
    NSMutableArray *tmpDataArray = [NSMutableArray array];
    for (UIImage *image in data) {
        NSData* imageData = UIImageJPEGRepresentation(image, XE_IMAGE_COMPRESSION_QUALITY);
        [tmpDataArray addObject:imageData];
    }
    
    NSMutableDictionary *imgIdDics = [NSMutableDictionary dictionaryWithCapacity:tmpDataArray.count];
    
    [XEProgressHUD AlertLoading:@"图片上传中..."];
    __weak XEPublicViewController *weakSelf = self;
    int index = 0;
    for (NSData *imgData in tmpDataArray) {
        XELog(@"imageData.length=%ld",imgData.length);
        QHQFormData* pData = [[QHQFormData alloc] init];
        pData.data = imgData;
        pData.name = @"img";
        pData.filename = @"img";
        pData.mimeType = @"image/png";
        
        NSMutableArray *dataArray = [NSMutableArray array];
        [dataArray addObject:pData];
        int tag = [[XEEngine shareInstance] getConnectTag];
        if (_publicType == Public_Type_Topic) {
            [[XEEngine shareInstance] updateTopicWithImgs:dataArray index:index tag:tag];
        }else if (_publicType == Public_Type_Expert){
            [[XEEngine shareInstance] updateExpertQuestionWithImgs:dataArray index:index tag:tag];
        }
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
            [imgIdDics setObject:[jsonRet stringObjectForKey:@"object"] forKey:[NSNumber numberWithInt:index]];
            if (imgIdDics.count == tmpDataArray.count) {
                NSMutableArray* picIds = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < tmpDataArray.count; ++i) {
                    NSString* picId = [imgIdDics objectForKey:[NSNumber numberWithInt:i]];
                    if (picId.length > 0) {
                        [picIds addObject:picId];
                    }
                }
                weakSelf.imgIds = picIds;
                if (_publicType == Public_Type_Topic) {
                    [weakSelf publicTopic];
                }else if (_publicType == Public_Type_Expert){
                    [weakSelf publicAskExpert];
                }
                
            }
            
        }tag:tag];
        
        index ++;
    }
}

#pragma mark - custom
-(void)refreshViewUI{
    
    if (_publicType == Public_Type_Expert) {
        self.openStateButton.hidden = NO;
        if (self.openStateButton.selected) {
            [self.openStateButton setTitle:@"私密" forState:0];
        }else{
            [self.openStateButton setTitle:@"公开" forState:0];
        }
        self.topicTypeContainerView.hidden = YES;
        self.titleTextField.placeholder = @"请输入标题（必填）";
        self.placeHolderLabel.text = @"请尽可能详细描述宝宝的状态，以便得到最好的解答";
    }else if (_publicType == Public_Type_Topic){
        self.openStateButton.hidden = YES;
        self.topicTypeContainerView.hidden = NO;
        CGRect frame = self.inputContainerView.frame;
        frame.origin.y = self.topicTypeContainerView.frame.origin.y + self.topicTypeContainerView.frame.size.height;
        self.inputContainerView.frame = frame;
        self.titleTextField.placeholder = @"请输入标题（必填）";
        self.placeHolderLabel.text = @"请输入您要发布的内容";
    }
    
    [self.imageGridView reloadData];
}

-(void)sendAction:(id)sender{
    
    if (_publicType == Public_Type_Topic) {
        if (_topicType == 0) {
            [XEProgressHUD lightAlert:@"请选择话题分类"];
            return;
        }
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
        
        if (_images.count > 0) {
            [self updateImage:_images];
        }else{
            [self publicTopic];
        }
        
    }else if (_publicType == Public_Type_Expert){
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
        
        if (_images.count > 0) {
            [self updateImage:_images];
        }else{
            [self publicAskExpert];
        }
    }
}

-(IBAction)topicTypeAction:(id)sender{
    
}

-(IBAction)openStateAction:(id)sender{
    self.openStateButton.selected = !self.openStateButton.selected;
    [self refreshViewUI];
}

-(IBAction)photoAction:(id)sender{
    __weak XEPublicViewController *weakSelf = self;
    XEActionSheet *sheet = [[XEActionSheet alloc] initWithTitle:nil actionBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 2) {
            return;
        }
        if (buttonIndex == 0) {
            //检查设备是否有相机功能
            if (![AVCamUtilities userCameraIsUsable]) {
                [XEUIUtils showAlertWithMsg:[XEUIUtils documentOfCameraDenied]];
                return;
            }
            //判断ios7用户相机是否打开
            if (![AVCamUtilities userCaptureIsAuthorization]) {
                [XEUIUtils showAlertWithMsg:[XEUIUtils documentOfAVCaptureDenied]];
                return;
            }
            XEImagePickerController *picker = [[XEImagePickerController alloc] init];
            picker.delegate = weakSelf;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [weakSelf.navigationController presentViewController:picker animated:YES completion:^{
                
            }];
        } else {
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            WSAssetPickerController *assetPickerController = [[WSAssetPickerController alloc] initWithAssetsLibrary:library];
            assetPickerController.delegate = weakSelf;
            assetPickerController.selectionLimit = MAX_IMAGES_NUM - weakSelf.images.count;
            [weakSelf presentViewController:assetPickerController animated:YES completion:NULL];
        }
    }];
    [sheet addButtonWithTitle:@"拍照"];
    [sheet addButtonWithTitle:@"从手机相册选择"];
    [sheet addButtonWithTitle:@"取消"];
    sheet.cancelButtonIndex = sheet.numberOfButtons -1;
    
    
    [sheet showInView:self.view];
}
-(IBAction)expressionAction:(id)sender{
    
}
- (void)updatePlaceHolderLabel{
    if (_descriptionTextView.text.length > 0) {
        _placeHolderLabel.hidden = YES;
    }else{
        _placeHolderLabel.hidden = NO;
    }
}

#pragma mark - GMGridViewDataSource
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return _images.count;
    
}
- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation {
    
    return CGSizeMake(ONE_IMAGE_HEIGHT, ONE_IMAGE_HEIGHT);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        UIImageView* imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        cell.contentView = imageView;
        
    }
    UIImageView* imageView = (UIImageView* )cell.contentView;
    imageView.image = _images[index];
    return cell;
}
#pragma mark GMGridViewActionDelegate
- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %ld", position);
}

#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    {
        UIImage* imageAfterScale = image;
        if (image.size.width != image.size.height) {
            CGSize cropSize = image.size;
            cropSize.height = MIN(image.size.width, image.size.height);
            cropSize.width = MIN(image.size.width, image.size.height);
            imageAfterScale = [image imageCroppedToFitSize:cropSize];
        }
//        NSData* imageData = UIImageJPEGRepresentation(imageAfterScale, XE_IMAGE_COMPRESSION_QUALITY);
        [self.images addObject:imageAfterScale];
        
    }
    [self refreshViewUI];
    [picker dismissModalViewControllerAnimated:YES];
    //    [LSCommonUtils saveImageToAlbum:picker Img:image];
    
}

#pragma mark - WSAssetPickerControllerDelegate
- (void)assetPickerControllerDidCancel:(WSAssetPickerController *)sender{
    [sender dismissViewControllerAnimated:YES completion:^{
        
    }];
}

// Called when the done button is tapped.
- (void)assetPickerController:(WSAssetPickerController *)sender didFinishPickingMediaWithAssets:(NSArray *)assets{
    [sender dismissViewControllerAnimated:YES completion:NULL];
    
    for (ALAsset* asset in assets) {
        UIImage *image = [self addOperationAsset:asset];
        [self.images addObject:image];
    }
    [self refreshViewUI];
}
//- (void)assetPickerController:(WSAssetPickerController *)sender didFinishPickingMediaWithAssets:(NSArray *)assets images:(NSArray *)images isResolution:(BOOL) isResolution{
//    [self.images addObjectsFromArray:images];
//    
//}

#define LS_MAX_IMAGE_WIDTH  640.0
-(UIImage *)addOperationAsset:(ALAsset *) asset
{
    NSLog(@"########start");
    
    UIImage* image = nil;
    //只有长图才去压缩，一般的图直接取fullScreenImage
    CGSize fullResolutionImageSize = [UIScreen mainScreen].bounds.size;
    
    if ([asset.defaultRepresentation respondsToSelector:@selector(dimensions)]) {
        fullResolutionImageSize = asset.defaultRepresentation.dimensions;
    } else {
        fullResolutionImageSize.width = CGImageGetWidth(asset.defaultRepresentation.fullResolutionImage);
        fullResolutionImageSize.height = CGImageGetHeight(asset.defaultRepresentation.fullResolutionImage);
    }
    
    if (fullResolutionImageSize.height/fullResolutionImageSize.width > [UIScreen mainScreen].bounds.size.height/[UIScreen mainScreen].bounds.size.width) {
        CFTimeInterval tick = CACurrentMediaTime();
        image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage scale:1.0 orientation:asset.defaultRepresentation.orientation];
        NSLog(@"imageWithCGImage tick=%f", CACurrentMediaTime() -tick);
        
        if (MIN(image.size.width, image.size.height) > LS_MAX_IMAGE_WIDTH) {
            CGSize newSize = image.size;
            if (image.size.width == MIN(image.size.width, image.size.height)) {
                newSize.width = LS_MAX_IMAGE_WIDTH;
                newSize.height = image.size.height/(image.size.width/LS_MAX_IMAGE_WIDTH);
            } else {
                newSize.height = LS_MAX_IMAGE_WIDTH;
                newSize.width = image.size.width/(image.size.height/LS_MAX_IMAGE_WIDTH);
            }
            //                @synchronized(_selectedAssetsSet){
            //                    if (![_selectedAssetsSet containsObject:asset]) {
            //                        return ;
            //                    }
            //                }
            image = [XEUIUtils scaleImage:image toSize:newSize];
            //image = [image imageScaledToFitSize:newSize];
        }
        NSLog(@"scaleImage tick=%f", CACurrentMediaTime() -tick);
    } else {
        image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    }
    
    if (image == nil) {
        image = [[UIImage alloc] init];
    }
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            @synchronized(_selectedAssetsSet) {
    //                if ([self.selectedAssetsSet containsObject:asset]) {
    //                    [[self selectedImageDic] setObject:image forKey:[NSNumber numberWithInt:(int)asset]];
    //                }
    //            }
    //        });
    NSLog(@"########stop");
    return image;
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
