//
//  BabyImpressAddController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/27.
//
//

#import "BabyImpressAddController.h"
#import "BabyImpressCollectCell.h"
#import "BabyImpressAddCollectCell.h"
#import "BabyImpressAddFooterView.h"
#import "BabyImpressMyPictureController.h"
#import "XEProgressHUD.h"
#import "ImageScrollController.h"
#import "UIImage+ProportionalFill.h"
#import "QHQnetworkingTool.h"
#import "AppDelegate.h"
#import "XEEngine.h"
#import <QiniuSDK.h>

#import "XETabBarViewController.h"

#import "MBProgressHUD.h"


@interface BabyImpressAddController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,babyImpressAddbtnTouchedDelegate,UIAlertViewDelegate,babyImpressShowBtnTouched,deleteDelegate>
@property (nonatomic,strong)NSMutableArray *dataSources;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;


@property (nonatomic,strong)UIImagePickerController *imagePicker;
@property (nonatomic,strong)UIAlertView *chooseWayUpload;
@property (nonatomic,strong)NSMutableArray *imageData;
@property (nonatomic,strong)NSMutableArray *imageArray;

@property (nonatomic,assign)NSInteger restNum;
@property (nonatomic,strong)UIView *hideView;

@property (nonatomic,assign)NSInteger totalIndex;
//@property (nonatomic,strong)UIButton *gotoOtherBtn;
//@property (nonatomic,strong)NSMutableString *failedStr;
//@property (nonatomic,strong)NSMutableString *successStr;
//@property (nonatomic,strong)UIAlertView *goToOtherAlert;
/**
 *  保存是否是进入此界面
 */
@property (nonatomic,assign)BOOL firstIn;

- (IBAction)verify:(id)sender;


@end

@implementation BabyImpressAddController
- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        self.imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
//- (NSMutableString *)successStr{
//    if (!_successStr) {
//        self.successStr = [[NSMutableString alloc]init];
//    }
//    return _successStr;
//}
//- (NSMutableString *)failedStr{
//    if (!_failedStr) {
//        self.failedStr = [[NSMutableString alloc]init];
//    }
//    return _failedStr;
//}
//- (UIAlertView *)goToOtherAlert{
//    if (!_goToOtherAlert) {
//        self.goToOtherAlert =  [[UIAlertView alloc]initWithTitle:@"正在上传照片，您可以去首页看看哦" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
//    }
//    return _goToOtherAlert;
//}



- (UIView *)hideView{
    if (!_hideView) {
        self.hideView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT + 64)];
        _hideView.backgroundColor = [UIColor lightTextColor];
        _hideView.alpha = 0.6;
    }
    return _hideView;
    
}
- (NSMutableArray *)imageData{
    if (!_imageData) {
        self.imageData = [NSMutableArray array];
    }
    return _imageData;
}
- (UIAlertView *)chooseWayUpload{
    if (!_chooseWayUpload) {
        self.chooseWayUpload = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    }
    return _chooseWayUpload;
}
- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        self.imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;//设置图片选择器的代理对象为当前视图控制器
        _imagePicker.allowsEditing = NO;
    }
    return _imagePicker;
}
- (NSMutableArray *)dataSources{
    if (!_dataSources) {
        self.dataSources = [NSMutableArray array];
    }
    return _dataSources;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.firstIn = YES;
    [self finalGetResuNum];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   self.view.backgroundColor = [UIColor whiteColor];
    self.restNum = 0;
    self.title = @"宝宝印像";
    self.checkBtn.layer.borderWidth = 1;
    self.checkBtn.layer.borderColor = SKIN_COLOR.CGColor;
    self.checkBtn.layer.cornerRadius = 5;
    self.checkBtn.layer.masksToBounds = YES;
    
    self.hideView.hidden = YES;
    self.totalIndex = 0;
    
    [self configureCollectionView];

    [self presentColtrollWith:self.index];
    [self.view addSubview:self.hideView];


}

#pragma mark 按钮
- (IBAction)verify:(id)sender {
    self.firstIn = NO;
    self.totalIndex = 0;
    if (self.dataSources.count == 0) {
        [XEProgressHUD lightAlert:@"您还没有选择照片，请选择照片"];
        return;
    }
    [XEProgressHUD AlertLoading:@"照片正在上传中，因为上传照片较大，可能需要几分钟时间，请耐心等待"];
    NSThread *nsth=  [[NSThread alloc] initWithTarget:self selector:@selector(configureImageOneByOne) object:nil];
    [nsth start];
    self.hideView.hidden = NO;

}
- (void)configureImageOneByOne{
    NSMutableArray *imarray = [NSMutableArray array];
    for (int i = 0; i < self.dataSources.count; i++) {
        UIImage *img = self.dataSources[i];
        CGSize size = CGSizeMake(img.size.width, img.size.height);
        UIGraphicsBeginImageContext(size);
        [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData* data;
        QHQFormData* pData = [[QHQFormData alloc] init];
        //强转jpg
        pData.mimeType = @".jpg";
        data = UIImageJPEGRepresentation(scaledImage, 1.0);
        if (data) {
            pData.data = data;
            NSLog(@"pData.name === %@ %ld",pData.name,(unsigned long)pData.data.length);
            [imarray addObject:pData];
            [self.imageData addObject:pData];
        }
        
        if (i == self.dataSources.count - 1) {
            [self getQiNiutoken];
        }
    }

}
- (void)goToOtherView{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[XETabBarViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }else{
            NSLog(@"%@",controller);

            NSLog(@"没有");
        }
    }
    
}
- (IBAction)showPosedPhoto:(id)sender {
    BabyImpressMyPictureController *my = [[BabyImpressMyPictureController alloc]init];
    [self.navigationController pushViewController:my animated:YES];
}
#pragma mark 数据请求
- (void)ExtentionPhotoGetRestImageNumber{
    __weak BabyImpressAddController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    
    [[XEEngine shareInstance]qiNiuGetRestCanPostImageWith:tag userid:[XEEngine shareInstance].uid];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        //获取失败信息
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return ;
        }
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"获取剩余上传数量失败" At:weakSelf.view];
            return;
        }
        NSString *string = [NSString stringWithFormat:@"%@",jsonRet[@"object"]];
        self.restNum = [string integerValue];
        
        if (self.index == 0) {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"未检测到摄像头" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                return;
            }
            if (self.restNum > 0){
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:self.imagePicker animated:YES completion:^{
                    
                }];
            }else{
                [XEProgressHUD lightAlert:@"您上传的照片数量已经超过当月上传数"];
                return;
            }
        }else if (self.index == 1){
            UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
            picker.delegate = self;
            picker.maximumNumberOfSelectionVideo = 0;
            
            if (self.restNum == 0) {
                [XEProgressHUD lightAlert:@"您上传的照片数量已经超过当月上传数"];
                return;
            }
            
            
            if (self.restNum > self.dataSources.count) {
                if (self.restNum - self.dataSources.count > 10) {
                    picker.maximumNumberOfSelectionPhoto = (10 - self.dataSources.count);
                }else if (self.restNum - self.dataSources.count == 10){
                    picker.maximumNumberOfSelectionPhoto = 10;
                }else if (self.restNum - self.dataSources.count < 10){
                    picker.maximumNumberOfSelectionPhoto = (self.restNum - self.dataSources.count);
                }
            }
            
            if (self.restNum < self.dataSources.count) {
                picker.maximumNumberOfSelectionPhoto = 0;
                [XEProgressHUD lightAlert:@"您选择的照片数量已经超过当月上传数"];
                return;
            }
            if (self.restNum == self.dataSources.count) {
                [XEProgressHUD lightAlert:@"您选择的照片数量已经超过当月上传数"];
                return;
            }

            [self presentViewController:picker animated:YES completion:^{
                
            }];
        
        }
        
        [self.collectionView reloadData];
    } tag:tag];


}

- (void)getQiNiutoken{
//    [self.failedStr setString:@"0"];
//    [self.successStr setString:@"0"];
    __weak BabyImpressAddController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance]qiNiuGetTokenWith:tag];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        //获取失败信息
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return ;
        }
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"获取上传token值失败" At:weakSelf.view];
            return;
        }
        NSString *token = jsonRet[@"object"];
        
        if (token.length <= 0 || [token isKindOfClass:[NSNull class]]) {
            [XEProgressHUD AlertError:@"获取上传token值失败" At:weakSelf.view];
            return;
        }

        [weakSelf reailPostDataWith:token];
/*
        AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [XEProgressHUD AlertLoading:@"照片正在上传中，因为上传照片较大，可能需要几分钟时间，请耐心等待" At:weakSelf.view];
        weakSelf.view.userInteractionEnabled = YES;
        weakSelf.hideView.hidden = NO;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"begainPostImage" object:nil];

         for (int i = 0; i < self.imageData.count; i++) {

        QHQFormData *qdata = (QHQFormData *)self.imageData[i];
        NSString *fileName = [NSString stringWithFormat:@"xiaorup/photoprint/%@-%@-%d%@",[XEEngine shareInstance].uid,[self getDateTimeString],i,qdata.mimeType];
             NSLog(@"fileName ==  %@", fileName);

        [appDelegate.upManager putData:qdata.data key:fileName token:token
                                      complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                          NSLog(@"error ==  %@,info == %@", info.error,info);
                                          if (info.error) {
//                                              NSInteger fail = [weakSelf.failedStr integerValue];
//                                              fail++;
//                                              weakSelf.failedStr = [NSMutableString stringWithFormat:@"%ld",(long)fail];
                                              if ( i == weakSelf.imageData.count - 1) {
                                                  [weakSelf.dataSources removeAllObjects];
                                                  [weakSelf.imageData removeAllObjects];
                                                  [weakSelf finalGetResuNum];
                                              }
                                    
                                          }else
                                          
                                          {
                                              //保存
                                              int tag = [[XEEngine shareInstance] getConnectTag];
                                              [[XEEngine shareInstance]qiNiuSavePhotoWith:tag cat:@"1" url:[NSString stringWithFormat:@"%@",key] objid:[XEEngine shareInstance].uid];
                                              [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
                                                  if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
//                                                      NSInteger fail = [weakSelf.failedStr integerValue];
//                                                      fail++;
//                                                      weakSelf.failedStr = [NSMutableString stringWithFormat:@"%ld",(long)fail];
                                                      NSLog(@"失败");
                                                  }else{
                                                      NSLog(@"成功");
//                                                      NSInteger sucess = [weakSelf.successStr integerValue];
//                                                      sucess++;
//                                                      weakSelf.successStr = [NSMutableString stringWithFormat:@"%ld",(long)sucess];

                                                  }
//                                                  [self finalGetResuNum];

                                                  if (i == weakSelf.imageData.count-1) {
//                                                      [[NSNotificationCenter defaultCenter]postNotificationName:@"endPostImage" object:nil];
//                                                      if ([weakSelf.failedStr integerValue] > 0) {
//                                                          [XEProgressHUD lightAlert:[NSString stringWithFormat:@"%@张图片上传失败,%@张图片上传成功",weakSelf.failedStr,weakSelf.successStr]];
//                                                          [weakSelf.dataSources removeAllObjects];
//                                                          [weakSelf.imageData removeAllObjects];
//                                                          [weakSelf finalGetResuNum];
//                                                          [self configureHideView];
//                                                      }else{

//                                                          [XEProgressHUD lightAlert:[NSString stringWithFormat:@"%@张图片上传成功",weakSelf.successStr]];
                                                          [XEProgressHUD AlertSuccess:@"上传完成"];
                                                          [XEProgressHUD lightAlert:[NSString stringWithFormat:@"上传成功"]];

//                                                          NSLog(@"weakSelf.successStr === %@",weakSelf.successStr);
                                                          [weakSelf.dataSources removeAllObjects];
                                                          [weakSelf.imageData removeAllObjects];
                                                          [weakSelf finalGetResuNum];
//                                                      }

                                                  }
                                                  
                                              } tag:tag];
                                          }
                                      } option:nil];
        
        }
 */

    } tag:tag];
 
}

- (void)reailPostDataWith:(NSString *)token{
    __weak BabyImpressAddController *weakSelf = self;
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [XEProgressHUD AlertLoading:@"照片正在上传中，因为上传照片较大，可能需要几分钟时间，请耐心等待" At:weakSelf.view];
    weakSelf.view.userInteractionEnabled = YES;
    weakSelf.hideView.hidden = NO;
    for (int i = 0; i < self.imageData.count; i++)
{
    
    QHQFormData *qdata = (QHQFormData *)self.imageData[i];
    NSString *fileName = [NSString stringWithFormat:@"xiaorup/photoprint/%@-%@-%d%@",[XEEngine shareInstance].uid,[self getDateTimeString],i,qdata.mimeType];
    [appDelegate.upManager putData:qdata.data key:fileName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp)
    {
        NSLog(@"error ==  %@,info == %@", info.error,info);
        if (info.error)
        {
            weakSelf.totalIndex +=1;

            if (weakSelf.totalIndex == weakSelf.imageData.count )
            {
                [weakSelf.dataSources removeAllObjects];
                [weakSelf.imageData removeAllObjects];
                [weakSelf finalGetResuNum];
            }
            
        }else
            
        {
            dispatch_queue_t queue = dispatch_queue_create("标示符", DISPATCH_QUEUE_SERIAL);

            dispatch_async(queue, ^{
                [self savePhothWith:[NSString stringWithFormat:@"%@",key] index:i];
            });

            
        }
        
    } option:nil];
    

    
}

    
}
- (void)savePhothWith:(NSString *)url index:(int)index
{
    __weak BabyImpressAddController *weakSelf = self;
    
    //保存
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance]qiNiuSavePhotoWith:tag cat:@"1" url:url objid:[XEEngine shareInstance].uid];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err)
     {
         weakSelf.totalIndex += 1;
         
         if (![[jsonRet objectForKey:@"code"] isEqual:@0])
         {
             
             NSLog(@"失败");
             [weakSelf finalGetResuNum];
         }else
         {
             NSLog(@"成功");
             if (weakSelf.totalIndex == weakSelf.imageData.count)
             {
                 NSLog(@"进入最后一张== %d",weakSelf.totalIndex);
                 [weakSelf.dataSources removeAllObjects];
                 [weakSelf.imageData removeAllObjects];
                 [weakSelf finalGetResuNum];
             }
             
         }
         
     } tag:tag];
}




- (void)finalGetResuNum{
    __weak BabyImpressAddController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    
    [[XEEngine shareInstance]qiNiuGetRestCanPostImageWith:tag userid:[XEEngine shareInstance].uid];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        //获取失败信息
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return ;
        }
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"获取剩余上传数量失败" At:weakSelf.view];
            return;
        }
        NSString *string = [NSString stringWithFormat:@"%@",jsonRet[@"object"]];
        self.restNum = [string integerValue];
        [self.collectionView reloadData];
        
        if (self.firstIn == YES) {
            
        }else{
            
            [XEProgressHUD AlertSuccess:@"上传完成"];
            [XEProgressHUD lightAlert:[NSString stringWithFormat:@"上传成功"]];
        }
        
        self.hideView.hidden = YES;
        
    } tag:tag];
}
- (void)presentColtrollWith:(NSInteger)index{
    switch (index) {
        case 0:
            // 0 拍照
        {
            
            [self ExtentionPhotoGetRestImageNumber];
        
        }
            break;
        case 1:
            //1手机相册
        {
            [self ExtentionPhotoGetRestImageNumber];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark 布局collectionView
- (void)configureCollectionView{
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"BabyImpressCollectCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BabyImpressAddCollectCell" bundle:nil] forCellWithReuseIdentifier:@"add"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BabyImpressAddFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    UICollectionViewFlowLayout *flowOut = [[UICollectionViewFlowLayout alloc]init];
    flowOut.scrollDirection =  UICollectionViewScrollDirectionVertical;
    flowOut.minimumLineSpacing = 10;
    flowOut.minimumInteritemSpacing = 0;
    self.collectionView.collectionViewLayout = flowOut;
    
}




#pragma mark alert Delagte
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == self.chooseWayUpload) {
        NSLog(@"%ld ",(long)buttonIndex);
        
        switch (buttonIndex) {
            case 0:
                //取消
            {
            }
                break;
            case 1:
                //拍照
            {
                if (self.dataSources.count >= 10) {
                    [XEProgressHUD lightAlert:@"单次上传数量不得超过十张"];
                    return;
                }
                if (self.dataSources.count == self.restNum) {
                    [XEProgressHUD lightAlert:@"您选择的照片数已超过剩余可上传数"];
                    return;
                }
                self.index = 0;
                [self ExtentionPhotoGetRestImageNumber];
                
            }
                break;
            case 2:
                //从手机相册选择
            {
                
                if (self.dataSources.count >= 10) {
                    [XEProgressHUD lightAlert:@"单次上传数量不得超过十张"];
                    return;
                }
                if (self.dataSources.count == self.restNum) {
                    [XEProgressHUD lightAlert:@"您选择的照片数已超过剩余可上传数"];
                    return;
                }
                self.index = 1;
                [self ExtentionPhotoGetRestImageNumber];
            }
                break;
            default:
                break;
        }
    }
    
}

#pragma mark  上传照片第三方代理
- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSLog(@"assets %@",assets);
    [XEProgressHUD AlertLoading:@"正在加载照片"];
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ALAsset *representation = obj;
        UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                           scale:representation.defaultRepresentation.scale
                                     orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
        [self.dataSources addObject:img];
        
    }];
    [self.collectionView reloadData];
    [XEProgressHUD AlertSuccess:@"加载完成"];
}
- (void)addPicrArrayWith:(UIImage *)img{
    CGSize size = CGSizeMake(img.size.width, img.size.height);
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self resultImageDataArratWith:scaledImage];
    
}
- (void)resultImageDataArratWith:(UIImage *)img{
    NSData* data;
    QHQFormData* pData = [[QHQFormData alloc] init];
    //判断图片是不是png格式的文件
//    if (UIImagePNGRepresentation(img)) {
//        //返回为png图像。
//        pData.mimeType = @".png";
//
//        data = UIImagePNGRepresentation(img);
//    }else {
//        //返回为JPEG图像。
//        pData.mimeType = @".jpg";
//        data = UIImageJPEGRepresentation(img, 1.0);
//    }
    //强转jpg
    pData.mimeType = @".jpg";
    data = UIImageJPEGRepresentation(img, 1.0);
    if (data) {
        pData.data = data;
        NSLog(@"pData.name === %@ %ld",pData.name,(unsigned long)pData.data.length);
            [self.imageData addObject:pData];
    }

    [self.collectionView reloadData];
}

#pragma mark imagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:^{

    }];

    UIImage *editedImage = info[@"UIImagePickerControllerOriginalImage"];
    [self.dataSources addObject:editedImage];
    [self.collectionView reloadData];
}


#pragma mark Cell delegate
- (void)babyImpressAddbtnTouched{
    if (self.restNum == 0) {
        [XEProgressHUD lightAlert:@"您当月上传照片数量已经达到上限"];
    }else{
        [self.chooseWayUpload show];
    }
}

- (void)babyImpressShowBtnTouchedWith:(NSInteger)index{
    ImageScrollController *show = [[ImageScrollController alloc]init];
    show.ifHaveDelete = YES;
    show.delegate = self;
    show.moveIndex = index;
    show.array = [NSMutableArray arrayWithArray:self.dataSources];
    [self.navigationController pushViewController:show animated:YES];

}

- (void)deleteResultWith:(NSInteger )index{
    [self.dataSources removeObjectAtIndex:index];
    [self.collectionView reloadData];
}


#pragma mark collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSources.count + 1;
    
}
//设置分区数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    
    if (indexPath.row == self.dataSources.count) {
        BabyImpressAddCollectCell *add = [collectionView dequeueReusableCellWithReuseIdentifier:@"add" forIndexPath:indexPath];
        add.delegate = self;
        return add;

    }else{
        BabyImpressCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
        [cell configureCellWithImage:self.dataSources[indexPath.row]];
        cell.delegate = self;
        cell.tag = indexPath.row;
        return cell;
    
    }
    return nil;
    
}

//每个Item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((self.view.frame.size.width - 20)/3, (self.view.frame.size.width - 20)/3);
    
}

//每个Item的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 245);
}

//定义区头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        BabyImpressAddFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        for (UIView *view in footer.subviews) {
            if (view.tag == 100) {
                UILabel *lable = (UILabel *)view;
                lable.text = [NSString stringWithFormat:@"您当月剩余上传数量还剩%ld张",self.restNum];
            }else{
            }
        }
        return footer;
    }else{
        return nil;
    }

}

#pragma mark 时间戳
- (NSString *)getDateTimeString
{
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
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

@end
