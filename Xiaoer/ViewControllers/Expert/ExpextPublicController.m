//
//  ExpextPublicController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/9/1.
//
//

#import "ExpextPublicController.h"

#import "BabyImpressCollectCell.h"
#import "BabyImpressAddCollectCell.h"
#import "WSAssetPicker.h"
#import "XEActionSheet.h"
#import "AVCamUtilities.h"
#import "XEImagePickerController.h"
#import "UIImage+ProportionalFill.h"
#import "UIImage+Resize.h"
#import "ImageScrollController.h"
#import "XEProgressHUD.h"
#import "QHQnetworkingTool.h"
#import "XEEngine.h"
#import "XEAlertView.h"
#import "XENavigationController.h"
#import "WelcomeViewController.h"


#define itemH (SCREEN_WIDTH - 40) / 3

@interface ExpextPublicController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,babyImpressAddbtnTouchedDelegate,babyImpressShowBtnTouched, UIImagePickerControllerDelegate,WSAssetPickerControllerDelegate,deleteDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *typeView;

@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (strong, nonatomic) IBOutlet UIView *desView;


@property (weak, nonatomic) IBOutlet UIButton *heartBtn;
- (IBAction)heart:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *raiseBtn;
- (IBAction)raise:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *nuration;
- (IBAction)nuration:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *getInbtn;

- (IBAction)getIn:(id)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *desTextView;

@property (weak, nonatomic) IBOutlet UILabel *placeHolderLab;


@property (weak, nonatomic) IBOutlet UILabel *backLab;

@property (nonatomic,strong)UIButton *saveBtn;
@property (nonatomic,strong)UICollectionViewFlowLayout *layOut;

@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *imgIds;
@property (nonatomic,assign)BOOL ifPublic;

@end

@implementation ExpextPublicController
- (NSMutableArray *)imgIds{
    if (!_imgIds) {
        self.imgIds = [NSMutableArray array];
    }
    return _imgIds;
}
- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        self.imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (UICollectionViewFlowLayout *)layOut{
    if (!_layOut) {
        self.layOut = [[UICollectionViewFlowLayout alloc]init];
        _layOut.scrollDirection =  UICollectionViewScrollDirectionVertical;
        _layOut.minimumLineSpacing = 10;
        _layOut.minimumInteritemSpacing = 10;
    }
    return _layOut;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.desTextView.delegate = self;
    
    if (![[XEEngine shareInstance] hasAccoutLoggedin]) {
        XEAlertView *alertView = [[XEAlertView alloc] initWithTitle:nil message:@"请登录" cancelButtonTitle:@"取消" cancelBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        } okButtonTitle:@"登录" okBlock:^{
            WelcomeViewController *welcomeVc = [[WelcomeViewController alloc] init];
            welcomeVc.showBackButton = YES;
            welcomeVc.backActionCallBack = ^(BOOL isBack){
                if (isBack) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            };
            XENavigationController* navigationController = [[XENavigationController alloc] initWithRootViewController:welcomeVc];
            navigationController.navigationBarHidden = YES;
            [self.navigationController presentViewController:navigationController animated:YES completion:nil];
        }];
        [alertView show];
        return;
    }
    
    if (self.publicType == publicExpert) {
        self.ifPublic = NO;
        if (self.doctorInfo) {
            self.title = [NSString stringWithFormat:@"向%@专家提问",self.doctorInfo.doctorName];
        }
    }else{
        
        self.title = @"发布话题";

    }
    
    [self setRightButtonWithTitle:@"发布" selector:@selector(goToPublish)];
    [self configureTableView];
    [self configureFooterView];
}


- (void)goToPublish{
    NSLog(@"发布");
    
    if (self.publicType == publicTopic) {
        
        if (!self.saveBtn) {
            [XEProgressHUD lightAlert:@"请选择话题分类"];
            return;
        }
        if (self.titleField.text.length == 0) {
            [XEProgressHUD lightAlert:@"请输入标题"];
            return;
        }
        if ([XECommonUtils getHanziTextNum:self.titleField.text] < 4) {
            [XEProgressHUD lightAlert:@"标题太短了"];
            return;
        }
        if (self.desTextView.text.length == 0) {
            [XEProgressHUD lightAlert:@"请输入内容"];
            return;
        }
        if ([XECommonUtils getHanziTextNum:self.desTextView.text] < 10) {
            [XEProgressHUD lightAlert:@"内容太短了"];
            return;
        }
        [self.desTextView resignFirstResponder];
        [self.titleField resignFirstResponder];
        if (self.imageArray.count > 0) {
            /**
             *  发送照片
             */
            [self updateImage:self.imageArray];
        }else{
            /**
             *  发布话题
             */
            [self publicTopic];
        }
        
    }else if (self.publicType == publicExpert){
        if (self.titleField.text.length == 0) {
            [XEProgressHUD lightAlert:@"请输入标题"];
            return;
        }
        if ([XECommonUtils getHanziTextNum:self.titleField.text] < 4) {
            [XEProgressHUD lightAlert:@"标题太短了"];
            return;
        }
        if (self.desTextView.text.length == 0) {
            [XEProgressHUD lightAlert:@"请输入内容"];
            return;
        }
        if ([XECommonUtils getHanziTextNum:self.desTextView.text] < 10) {
            [XEProgressHUD lightAlert:@"内容太短了"];
            return;
        }
        [self.desTextView resignFirstResponder];
        [self.titleField resignFirstResponder];
        if (self.imageArray.count > 0) {
            /**
             *  发送照片
             */
          [self updateImage:self.imageArray];
        }else{
            /**
             *  发布询问医生
             */
            [self publicAskExpert];

        }
    }
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
    
    
    [XEProgressHUD AlertLoading:@"图片上传中..." At:self.view];
    __weak ExpextPublicController *weakSelf = self;
    int index = 0;
    for (NSData *imgData in tmpDataArray) {
        XELog(@"imageData.length=%d",(int)imgData.length);
        QHQFormData* pData = [[QHQFormData alloc] init];
        pData.data = imgData;
        pData.name = @"img";
        pData.filename = [NSString stringWithFormat:@"%d",index];
        pData.mimeType = @"image/png";
        
        NSMutableArray *dataArray = [NSMutableArray array];
        [dataArray addObject:pData];
        int tag = [[XEEngine shareInstance] getConnectTag];
        if (self.publicType == publicTopic) {
            [[XEEngine shareInstance] updateTopicWithImgs:dataArray index:-1 tag:tag];
        }else if (self.publicType == publicExpert){
            [[XEEngine shareInstance] updateExpertQuestionWithImgs:dataArray index:-1 tag:tag];
        }
        [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
            //            [XEProgressHUD AlertLoadDone];
            NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
            if (!jsonRet || errorMsg) {
                if (!errorMsg.length) {
                    errorMsg = @"上传失败";
                }
                [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
                return;
            }
            [imgIdDics setObject:[jsonRet stringObjectForKey:@"object"] forKey:[NSNumber numberWithInt:index]];
            if (imgIdDics.count == tmpDataArray.count) {
                [XEProgressHUD AlertSuccess:@"上传成功." At:weakSelf.view];
                NSMutableArray* picIds = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < tmpDataArray.count; ++i) {
                    NSString* picId = [imgIdDics objectForKey:[NSNumber numberWithInt:i]];
                    if (picId.length > 0) {
                        [picIds addObject:picId];
                    }
                }
                weakSelf.imgIds = picIds;
                if (self.publicType == publicTopic) {
                    [weakSelf publicTopic];
                }else if (self.publicType == publicExpert){
                    [weakSelf publicAskExpert];
                }
                
            }
            
        }tag:tag];
        
        index ++;
    }
}

- (void)publicAskExpert{
    
    NSString *imgs = nil;
    if (self.imgIds.count > 0) {
        imgs = [XECommonUtils stringSplitWithCommaForIds:self.imgIds];
    }
    [XEProgressHUD AlertLoading:@"发送中..." At:self.view];
    NSString *overt = [NSString stringWithFormat:@"%@",self.ifPublic ? @"0":@"1" ];
    __weak ExpextPublicController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] publishQuestionWithExpertId:self.doctorInfo.doctorId uid:[XEEngine shareInstance].uid title:self.titleField.text content:self.desTextView.text overt:overt imgs:imgs tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        //        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        XEAlertView* alertView = [[XEAlertView alloc] initWithTitle:nil message:@"已向专家提问，需要您耐心等待，24小时内会解答" cancelButtonTitle:@"知道了" cancelBlock:^{
            [super backAction:nil];
        }];
        [alertView show];
        
    }tag:tag];
}

- (void)publicTopic{
    /**
     *  cat	话题分类(话题 1:养育 2:营养 3:入园 4:心理|
     */
    NSString *imgs = nil;
    if (self.imgIds.count > 0) {
        imgs = [XECommonUtils stringSplitWithCommaForIds:self.imgIds];
    }
    
    int cat = 0;
    if ([self.saveBtn.titleLabel.text isEqualToString:@"养育"]) {
        cat = 1;
    }
    
    if ([self.saveBtn.titleLabel.text isEqualToString:@"营养"]) {
        cat = 2;
    }
    if ([self.saveBtn.titleLabel.text isEqualToString:@"入园"]) {
        cat = 3;
    }
    if ([self.saveBtn.titleLabel.text isEqualToString:@"心理"]) {
        cat = 4;
    }
    
    [XEProgressHUD AlertLoading:@"发送中..." At:self.view];
    __weak ExpextPublicController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];

    [[XEEngine shareInstance] publishTopicWithUserId:[XEEngine shareInstance].uid title:self.titleField.text content:self.desTextView.text cat:cat imgs:imgs tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        //        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
        [self performSelector:@selector(back) withObject:nil afterDelay:2];
        
    }tag:tag];
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];

}
- (UIView *)creatHeaderView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    
    /**
     最上面的头描述
     */
    UILabel *des = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, SCREEN_WIDTH - 24, 0)];
    des.font = [UIFont systemFontOfSize:15];
    des.numberOfLines = 0;
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil];
    des.text = @"10分公益”活动是由国家卫生计生委主导的“新家庭”项目，面向全国0~3岁婴幼儿家庭推出的爱心传递公益活动。每位参加活动奉献爱心的家长都将获得由“新家庭”送出的惊喜大礼哦~";
    CGRect rect = [des.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    CGRect textFram = des.frame;
    
    textFram.size.height = rect.size.height + 10;
    des.frame = textFram;
    
    if (self.publicType == publicTopic) {
        self.typeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        CGRect typeFrame = self.typeView.frame;
        typeFrame.origin.y = des.frame.size.height + des.frame.origin.y;
        self.typeView.frame = typeFrame;
        [headerView addSubview:self.typeView];

    }else{
        self.typeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);

    }
    
    self.desView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
    CGRect desFrame = self.desView.frame;
    desFrame.origin.y = des.frame.origin.y + des.frame.size.height + self.typeView.frame.size.height;
    self.desView.frame = desFrame;
    
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, des.frame.size.height + 10+ self.typeView.frame.size.height + self.desView.frame.size.height);
    [headerView addSubview:des];
    [headerView addSubview:self.desView];
    return headerView;
}

#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}


#pragma mark collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count+ 1;
    
}
//设置分区数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == self.imageArray.count) {
    BabyImpressAddCollectCell *add = [collectionView dequeueReusableCellWithReuseIdentifier:@"add" forIndexPath:indexPath];
        add.delegate = self;
    return add;
    
    }else{
    BabyImpressCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
        cell.delegate = self;
    cell.tag = indexPath.row;
    [cell configureCellWithImage:self.imageArray[indexPath.row]];

    return cell;
    
    }
    return nil;

}

//每个Item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
        return CGSizeMake((SCREEN_WIDTH - 40) / 3, (SCREEN_WIDTH - 40) / 3 );
}

//每个Item的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//区头的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeMake(0, 1);
//}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (self.publicType == publicExpert) {
        return CGSizeMake(0, 50);

    }else{
        return CGSizeMake(0, 0);

    }

}
//定义区尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (self.publicType == publicExpert)
    {
        if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
            UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"sectionFooter" forIndexPath:indexPath];
            UIButton *ifPublicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            ifPublicBtn.frame = CGRectMake(SCREEN_WIDTH - 15 - 60, 10, 60, 30);
            [ifPublicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            ifPublicBtn.layer.cornerRadius = 5;
            ifPublicBtn.layer.masksToBounds = YES;
            [ifPublicBtn addTarget:self action:@selector(changeIfPublic) forControlEvents:UIControlEventTouchUpInside];
            if (self.ifPublic == NO) {
                ifPublicBtn.backgroundColor = [UIColor lightGrayColor];
                [ifPublicBtn setTitle:@"不公开" forState:UIControlStateNormal];
                
            }else{
                
                ifPublicBtn.backgroundColor = SKIN_COLOR;
                [ifPublicBtn setTitle:@"公开" forState:UIControlStateNormal];
            }
            [footer addSubview:ifPublicBtn];
            return footer;
        }else{
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader" forIndexPath:indexPath];
            header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
            return header;
        }
    }else{
        return nil;
    }
    return nil;
    
    
}



#pragma mark Cell delegate
- (void)babyImpressAddbtnTouched{
    NSLog(@"babyImpressAddbtnTouched");
    
    if (self.imageArray.count >= MAX_IMAGES_NUM) {
        NSString* alertMsg = [NSString stringWithFormat:@"您一次最多只能选择%d张图片", MAX_IMAGES_NUM];
        UIAlertView *noticeAlert = [[UIAlertView alloc] initWithTitle:nil message:alertMsg delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [noticeAlert show];
        return;
    }
    
    __weak ExpextPublicController *weakSelf = self;
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
            assetPickerController.selectionLimit = MAX_IMAGES_NUM - weakSelf.imageArray.count;
            [weakSelf presentViewController:assetPickerController animated:YES completion:NULL];
        }
    }];
    [sheet addButtonWithTitle:@"拍照"];
    [sheet addButtonWithTitle:@"从手机相册选择"];
    [sheet addButtonWithTitle:@"取消"];
    sheet.cancelButtonIndex = sheet.numberOfButtons -1;
    
    
    [sheet showInView:self.view];

    
}

- (void)babyImpressShowBtnTouchedWith:(NSInteger)index{
    ImageScrollController *show = [[ImageScrollController alloc]init];
    show.ifHaveDelete = YES;
    show.delegate = self;
    show.moveIndex = index;
    show.array = [NSMutableArray arrayWithArray:self.imageArray];
    [self.navigationController pushViewController:show animated:YES];
    NSLog(@"babyImpressShowBtnTouchedWith");
}

#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    {
        CGSize size = image.size;
        UIImage * originalImage = image;
        if (originalImage.size.width > 640) {
            CGFloat factor = 640.0/originalImage.size.width;
            originalImage = [XEUIUtils scaleImage:image toSize:CGSizeMake(640, roundf(originalImage.size.height*factor))];
        } else {
            originalImage = [originalImage resizedImage:size interpolationQuality:0];
        }
        //        NSData* imageData = UIImageJPEGRepresentation(imageAfterScale, XE_IMAGE_COMPRESSION_QUALITY);
        [self.imageArray addObject:originalImage];
        
    }
    [self refreshCollectionView];
    [picker dismissModalViewControllerAnimated:YES];
    
}

#pragma mark - WSAssetPickerControllerDelegate
- (void)assetPickerControllerDidCancel:(WSAssetPickerController *)sender{
    [sender dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)assetPickerController:(WSAssetPickerController *)sender didFinishPickingMediaWithAssets:(NSArray *)assets{
    [sender dismissViewControllerAnimated:YES completion:NULL];
    
    for (ALAsset* asset in assets) {
        UIImage *image = [XEUIUtils addOperationAsset:asset];
        [self.imageArray addObject:image];
    }
    [self refreshCollectionView];
}


#pragma mark textView delegate
-(void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"textViewDidChange");
    if (textView.text.length == 0) {
        self.placeHolderLab.hidden = NO;
    }
    else
    {
        self.placeHolderLab.hidden = YES;
    }
}



- (void)deleteResultWith:(NSInteger)index{
    [self.imageArray removeObjectAtIndex:index];
    [self refreshCollectionView];
    
}
- (IBAction)heart:(id)sender {
    [self ifHaveSaveBtnWith:(UIButton *)sender];
}
- (IBAction)raise:(id)sender {
    [self ifHaveSaveBtnWith:(UIButton *)sender];

}
- (IBAction)nuration:(id)sender {
    [self ifHaveSaveBtnWith:(UIButton *)sender];

}
- (IBAction)getIn:(id)sender {
    [self ifHaveSaveBtnWith:(UIButton *)sender];

}
- (void)ifHaveSaveBtnWith:(UIButton *)sender{
    if (self.saveBtn) {
        self.saveBtn.backgroundColor = [UIColor lightGrayColor];
        sender.backgroundColor = SKIN_COLOR;
        self.saveBtn = sender;
    }else{
        self.saveBtn = sender;
        self.saveBtn.backgroundColor = SKIN_COLOR;
    }
}
- (void)changeIfPublic{
    self.ifPublic =! self.ifPublic;
    [self.collectionView reloadData];
    
}
- (void)refreshCollectionView{
    
    NSInteger total = self.imageArray.count + 1;
    int lines = (int)((total/3) + (total%3?1:0));
    
    if (self.publicType == publicTopic)
    {
        
        self.footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, lines*itemH + 20*lines - 10);
        self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, lines*itemH + 20*lines-10);

        
    }else
    {
        self.footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, lines*itemH + 20*lines + 40);
        self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, lines*itemH + 20*lines + 40);

        
    }
    self.tableView.tableFooterView = self.footerView;
    [self.collectionView reloadData];
    
}
- (void)configureFooterView{
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.collectionViewLayout = self.layOut;
    NSInteger total = self.imageArray.count + 1;
    int lines = (int)((total/3) + (total%3?1:0));
    
    if (self.publicType == publicTopic)
    {

        
        self.footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, lines*itemH + 20);

    }else
    {
        self.footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, lines*itemH + 20 + 50);

    }
    self.tableView.tableFooterView = self.footerView;
    [self.collectionView registerNib:[UINib nibWithNibName:@"BabyImpressCollectCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BabyImpressAddCollectCell" bundle:nil] forCellWithReuseIdentifier:@"add"];
    
    if (self.publicType == publicExpert) {
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"sectionFooter"];
    }
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader"];

    
    
}
- (void)configureTableView{
    
    
    self.heartBtn.layer.cornerRadius = 7;
    self.heartBtn.layer.masksToBounds = YES;
    self.raiseBtn.layer.cornerRadius = 7;
    self.raiseBtn.layer.masksToBounds = YES;
    self.nuration.layer.cornerRadius = 7;
    self.nuration.layer.masksToBounds = YES;
    self.getInbtn.layer.cornerRadius = 7;
    self.getInbtn.layer.masksToBounds = YES;
    
    self.titleField.placeholder = @"请输入标题";
    self.backLab.layer.cornerRadius = 8;
    self.backLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backLab.layer.borderWidth = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = [self creatHeaderView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)backAction:(id)sender{
    if (self.desTextView.text.length > 0 || self.titleField.text.length > 0 || self.imageArray.count > 0) {
        XEAlertView* alertView = [[XEAlertView alloc] initWithTitle:nil message:@"确定要放弃本次操作?" cancelButtonTitle:@"取消" cancelBlock:^{
            
        }  okButtonTitle:@"确定" okBlock:^{
            [super backAction:sender];
        }];
        [alertView show];
    } else {
        [super backAction:sender];
    }
}
@end
