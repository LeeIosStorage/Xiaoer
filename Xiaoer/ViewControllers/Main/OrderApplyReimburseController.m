//
//  OrderApplyReimburseController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/3.
//
//

#import "OrderApplyReimburseController.h"
#import "OrderApplyReimburseCell.h"
#import "UIImage+ProportionalFill.h"
#import "QHQnetworkingTool.h"


#import "XEEngine.h"
#import "XEProgressHUD.h"
@interface OrderApplyReimburseController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  描述array
 */
@property (nonatomic,strong)NSMutableArray *desArray;
@property (strong, nonatomic) IBOutlet UIView *pickBackView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;


@property (strong, nonatomic) IBOutlet UIView *tabFooterView;
/**
 *  退款说明（最多0.00元，含发货邮费0.00元）
 */
@property (weak, nonatomic) IBOutlet UILabel *specification;



//退款服务
@property (nonatomic,strong)NSMutableArray *serveArray;
//退款原因
@property (nonatomic,strong)NSMutableArray *reasonArray;
//保存现在展示的是哪个数组
@property (nonatomic,strong)NSMutableArray *saveArray;

@property (nonatomic,assign)NSInteger PickerFinalIndex;
@property (nonatomic,strong)NSString *pickerFinalStr;

//留言
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIView *postPhotoView;
//保存上传图片的数组
@property (nonatomic,strong)NSMutableArray *arrPics;

@property (nonatomic,strong)NSMutableArray *imageDataArr;
//提交申请按钮
@property (weak, nonatomic) IBOutlet UIButton *submitApplyBtn;
//上传凭证图片
@property (nonatomic,strong)UIImageView *imageViewA;
@property (nonatomic,strong)UIImageView *imageViewB;
@property (nonatomic,strong)UIImageView *imageViewC;

@end

@implementation OrderApplyReimburseController
- (UIImageView *)imageViewA{
    if (!_imageViewA) {
        self.imageViewA = [[UIImageView alloc]init];
    }
    return _imageViewA;
}
- (UIImageView *)imageViewB{
    if (!_imageViewB) {
        self.imageViewB = [[UIImageView alloc]init];
    }
    return _imageViewB;
}
- (UIImageView *)imageViewC{
    if (!_imageViewC) {
        self.imageViewC = [[UIImageView alloc]init];
    }
    return _imageViewC;
}
- (NSMutableArray *)imageDataArr{
    if (!_imageDataArr) {
        self.imageDataArr = [NSMutableArray array];
    }
    return _imageDataArr;
}
- (NSMutableArray *)arrPics {
    if (!_arrPics) {
        self.arrPics = [NSMutableArray array];
    }
    return _arrPics;
}
- (NSMutableArray *)serveArray{
    if (!_serveArray) {
        self.serveArray = [NSMutableArray arrayWithObjects:@"退货退款",@"退货", nil];
    }
    return _serveArray;
}

- (NSMutableArray *)reasonArray{
    if (!_reasonArray) {
        self.reasonArray = [NSMutableArray arrayWithObjects:@"尺寸问题",@"材质不符",@"主商品破损",@"款式/图案/颜色不符",@"效果不好/不喜欢",@"功能故障",@"做工瑕疵",@"配件破损",@"假冒品牌",@"其他", nil];
    }
    return _reasonArray;
}
- (NSMutableArray *)desArray{
    if(!_desArray){
        self.desArray = [NSMutableArray array];
    }
    return _desArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请退款";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.submitApplyBtn.layer.borderWidth = 1;
    self.submitApplyBtn.layer.borderColor = SKIN_COLOR.CGColor;
    self.submitApplyBtn.layer.cornerRadius = 8;
    
    //    （最多0.00元，含发货邮费0.00元）
    
    if (self.order) {
        NSString *money = [NSString stringWithFormat:@"%.2f",([self.order.money floatValue] - [self.order.carriage floatValue])/100];
        self.specification.text = [NSString stringWithFormat:@"最多%@元，含发货邮费：%.2f元",money,[self.order.carriage floatValue]/100];
        self.desArray = [NSMutableArray arrayWithObjects:@"退货退款",@"尺寸问题",money, nil];
    }else{
        NSString *money = [NSString stringWithFormat:@"%.2f",([self.detailInfo.money floatValue] - [self.detailInfo.carriage floatValue])/100];
        self.specification.text = [NSString stringWithFormat:@"最多%@元，含发货邮费：%.2f元",money,[self.detailInfo.carriage floatValue]/100];
        self.desArray = [NSMutableArray arrayWithObjects:@"退货退款",@"尺寸问题",money, nil];
    
    }
    

    
    [self configureTableView];
    [self configurePickBackView];
    
    /**
     *  键盘将要出现的监听
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    /**
     *  键盘将要消失的监听
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardEndChange:) name:UIKeyboardWillHideNotification object:nil];


    // Do any additional setup after loading the view from its nib.
}

#pragma mark 布局PickBackView
- (void)configurePickBackView{
    self.pickBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200);
    self.pickerView.delegate  =self;
    self.pickerView.dataSource = self;
    [self.view addSubview:self.pickBackView];
}
#pragma mark 布局tableview
- (void)configureTableView{
    
    self.tabFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 308);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = self.tabFooterView;
    
    
    self.textView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.textView.layer.cornerRadius = 8;
    self.textView.delegate = self;
    
    
#warning 此版本不加上传图片功能 暂时隐藏
    CGRect postPhotoRect = self.postPhotoView.frame;
    postPhotoRect.origin.x = 15;
    postPhotoRect.origin.y = 223;
    self.postPhotoView.frame = postPhotoRect;
    [self.tabFooterView addSubview:self.postPhotoView];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderApplyReimburseCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark 提交申请按钮点击
- (IBAction)submitApplyBtnTouched:(id)sender {
    //键盘消失
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
    __weak OrderApplyReimburseController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    
    NSString *money = @"";
    NSString *orderproviderid = @"";
    if (self.order) {
        money = [NSString stringWithFormat:@"%f",([self.order.money floatValue] - [self.order.carriage floatValue])];
        orderproviderid = self.order.id;
    }else{
        orderproviderid = self.detailInfo.id;
        money = [NSString stringWithFormat:@"%f",([self.detailInfo.money floatValue] - [self.detailInfo.carriage floatValue])];
    }
    
    if (self.textView.text.length == 0 ) {
        self.textView.text = @"";
        NSLog(@"nohave");
    }else {
        NSLog(@"have");
    }
    

    

    [[XEEngine shareInstance]applyForRefundWith:tag userid:[XEEngine shareInstance].uid orderproviderid:orderproviderid refundservice:self.desArray[0] refundreason:self.desArray[1] refundprice:money refundintro:self.textView.text];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return ;
        }
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            return;
        }
        
        if ([[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertLoading:@"申请退款成功" At: weakSelf.view];
            if (self.delegate && [self.delegate respondsToSelector:@selector(sucessRefreshData)]) {
                [self.delegate  sucessRefreshData];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"apply" object:nil];
            [self performSelector:@selector(back) withObject:nil afterDelay:2];
            return;
        }
    
    } tag:tag];

}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 键盘将要消失的监听
- (void)keyBoardEndChange:(NSNotification *)note{
    
    //取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}



#pragma mark 键盘将要出现的监听
- (void)keyBoardWillChange:(NSNotification *)note{
    //取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //取出键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    //计算控制器的view需要偏移评议的距离
    
    
    CGFloat transForm =  keyboardFrame.size.height;
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, -transForm , SCREEN_WIDTH, SCREEN_HEIGHT);
        
    }];
    
}



#pragma mark tableView delegate 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }else{
        return 8;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderApplyReimburseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell configureCellWith:indexPath desText:[self.desArray objectAtIndex:indexPath.section]];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  == 2  && self.pickBackView.frame.origin.y == (SCREEN_HEIGHT - 200)) {
        [self animationChooseDataView];
        
    }else if (indexPath.section == 0){
        self.saveArray = self.serveArray;
        [self.pickerView selectRow:0 inComponent:0 animated:YES];
        [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
        [self.pickerView reloadAllComponents];
        if (self.pickBackView.frame.origin.y == (SCREEN_HEIGHT - 200)) {
        }else{
            [self animationChooseDataView];
        }

    }else if (indexPath.section == 1){
        
        self.saveArray = self.reasonArray;
        [self.pickerView selectRow:0 inComponent:0 animated:YES];
        [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
        [self.pickerView reloadAllComponents];
        if (self.pickBackView.frame.origin.y == (SCREEN_HEIGHT - 200)) {
        }else{
            [self animationChooseDataView];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark 实现协议UIPickerViewDataSource方法
//确定Picker的轮子的个数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
    
}


//确定picker的每个轮子的item数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.saveArray.count;
}


#pragma mark 实现协议UIPickerViewDelegate方法

//显示每个轮子的内容

-  (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.saveArray[row];
}
//监听轮子的移动

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
       self.PickerFinalIndex = row;
}



#pragma mark scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.pickBackView.frame.origin.y == (SCREEN_HEIGHT - 200)) {
        [self animationChooseDataView];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  取消按钮点击
- (IBAction)cancleBtnTouched:(id)sender {
    [self animationChooseDataView];
}

#pragma mark pickerBack 上确定按钮点击
- (IBAction)verifyChooserPickerBtnTouched:(id)sender {
    if (self.saveArray == self.serveArray) {
        self.desArray[0] = self.serveArray[self.PickerFinalIndex];
    }else{
        self.desArray[1] = self.reasonArray[self.PickerFinalIndex];
    }
    [self.tableView reloadData];
    [self animationChooseDataView];
}
- (IBAction)postPhotoBtnToouched:(id)sender {
    NSLog(@"上传照片按钮点击");
    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
    picker.delegate = self;
    if (self.arrPics.count ==0) {
        picker.maximumNumberOfSelectionPhoto = 3;
    }else if (self.arrPics.count == 1){
        picker.maximumNumberOfSelectionPhoto = 2;
    }else if (self.arrPics.count == 2){
        picker.maximumNumberOfSelectionPhoto = 1;
    }else if (self.arrPics.count == 3){
        picker.maximumNumberOfSelectionPhoto = 0;
    }
    picker.maximumNumberOfSelectionVideo = 0;

    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
#pragma mark  上传照片第三方代理
- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSLog(@"assets %@",assets);
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ALAsset *representation = obj;
            NSLog(@"obj == %@",obj);
            UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                               scale:representation.defaultRepresentation.scale
                                         orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
        NSLog(@"img.size == %f %f",img.size.width,img.size.height);
            [self addPicrArrayWith:img];
        }];
        
        
    
    
}
- (void)addPicrArrayWith:(UIImage *)img{
    CGSize size = CGSizeMake(500, 500);
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.arrPics addObject:scaledImage];
    NSLog(@"self.arrPics == %@",self.arrPics);
    [self changePictureFrame];

    [self resultImageDataArratWith:img];
    
}
#pragma mark 重新布局
- (void)changePictureFrame{
    CGRect postPhotoRect = self.postPhotoView.frame;
    postPhotoRect.origin.x = 15;
    postPhotoRect.origin.y = 223;
    
    self.postPhotoView.frame = postPhotoRect;
    if (self.arrPics.count == 1) {
        self.imageViewA.frame = postPhotoRect;
        self.imageViewA.image = self.arrPics[0];
        [self.tabFooterView addSubview:self.imageViewA];
        
        postPhotoRect.origin.x += (postPhotoRect.size.width + 15);
        self.postPhotoView.frame = postPhotoRect;
        
    }else if (self.arrPics.count == 2){
        self.imageViewA.frame = postPhotoRect;
        self.imageViewA.image = self.arrPics[0];
        
        postPhotoRect.origin.x += (postPhotoRect.size.width + 15);
        
        self.imageViewB.frame = postPhotoRect;
        self.imageViewB.image = self.arrPics[1];
        [self.tabFooterView addSubview:self.imageViewB];
        
        postPhotoRect.origin.x += (postPhotoRect.size.width + 15);
        self.postPhotoView.frame = postPhotoRect;
        
        
        
    }else if (self.arrPics.count == 3){
        self.imageViewA.frame = postPhotoRect;
        self.imageViewA.image = self.arrPics[0];
        postPhotoRect.origin.x += (postPhotoRect.size.width + 15);
        
        self.imageViewB.frame = postPhotoRect;
        self.imageViewB.image = self.arrPics[1];
        self.imageViewB.frame = postPhotoRect;
        
        postPhotoRect.origin.x += (postPhotoRect.size.width + 15);
        
        self.imageViewC.frame = postPhotoRect;
        self.imageViewC.image = self.arrPics[2];
        self.imageViewC.frame = postPhotoRect;
        [self.tabFooterView addSubview:self.imageViewC];
        
        postPhotoRect.origin.x += (postPhotoRect.size.width + 15);
        self.postPhotoView.frame = postPhotoRect;
        self.postPhotoView.hidden = YES;
        
    }
    
}
- (void)resultImageDataArratWith:(UIImage *)img{
    UIImage* imageAfterScale = img;
    if (img.size.width != img.size.height) {
        CGSize cropSize = img.size;
        cropSize.height = MIN(img.size.width, img.size.height);
        cropSize.width = MIN(img.size.width, img.size.height);
        imageAfterScale = [img imageCroppedToFitSize:cropSize];
    }
    NSData* imageData = UIImageJPEGRepresentation(imageAfterScale, XE_IMAGE_COMPRESSION_QUALITY);
    if (imageData) {
        QHQFormData* pData = [[QHQFormData alloc] init];
        pData.data = imageData;
        pData.name = @"bbavatar";
        pData.filename = @".png";
        pData.mimeType = @"image/png";
        [self.imageDataArr addObject:pData];
    }
    NSLog(@"self.imageDataArr ==%@",self.imageDataArr);
}

//- (void)animationTableView{
//
//    if (SCREEN_HEIGHT <= 500) {
//        if (self.view.frame.origin.y == 0) {
//            [UIView animateWithDuration:0.5 animations:^{
//                    self.view.frame = CGRectMake(0, -SCREEN_HEIGHT / 3 , SCREEN_WIDTH, SCREEN_HEIGHT );
//            }];
//        }else if (self.view.frame.origin.y == -SCREEN_HEIGHT/3){
//            [UIView animateWithDuration:0.5 animations:^{
//                    self.view.frame = CGRectMake(0, 0 , SCREEN_WIDTH, SCREEN_HEIGHT );
//            }];
//        }
//    }else if (SCREEN_HEIGHT == 568){
//        if (self.view.frame.origin.y == 0) {
//            [UIView animateWithDuration:0.5 animations:^{
//                self.view.frame = CGRectMake(0, -SCREEN_HEIGHT / 3 , SCREEN_WIDTH, SCREEN_HEIGHT );
//            }];
//        }else if (self.view.frame.origin.y == -SCREEN_HEIGHT/3){
//            [UIView animateWithDuration:0.5 animations:^{
//                self.view.frame = CGRectMake(0, 0 , SCREEN_WIDTH, SCREEN_HEIGHT );
//            }];
//        }
//    }    
//}
#pragma mark pickerBackView  动画
- (void)animationChooseDataView{
    if (self.pickBackView.frame.origin.y == (SCREEN_HEIGHT - 200)) {
        [UIView animateWithDuration:0.2 animations:^{
            self.pickBackView.frame = CGRectMake(0, SCREEN_HEIGHT + 200, SCREEN_WIDTH, 200);
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.pickBackView.frame = CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200);
        }];
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

@end
