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

@interface BabyImpressAddController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,babyImpressAddbtnTouchedDelegate,UIAlertViewDelegate,babyImpressShowBtnTouched,deleteDelegate>
@property (nonatomic,strong)NSMutableArray *dataSources;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)UIImagePickerController *imagePicker;
@property (nonatomic,strong)UIAlertView *chooseWayUpload;
@end

@implementation BabyImpressAddController

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

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self configureCollectionView];

    [self presentColtrollWith:self.index];

}

-(void)useSystemPhoto{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"未检测到摄像头" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }else{
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePicker animated:YES completion:^{
            
        }];
    
    }


}

- (void)useExtentionPhoto{
    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
    picker.delegate = self;
    picker.maximumNumberOfSelectionVideo = 0;
    picker.maximumNumberOfSelectionPhoto = 10;
    [self presentViewController:picker animated:YES completion:^{
        
    }];

}
- (void)presentColtrollWith:(NSInteger)index{
    switch (index) {
        case 0:
            // 0 拍照
        {
            [self useSystemPhoto];
        
        }
            break;
        case 1:
            //1手机相册
        {
            [self useExtentionPhoto];
        }
            break;
        default:
            break;
    }
    
}


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

#pragma mark  查看照片
- (IBAction)showPosedPhoto:(id)sender {
    BabyImpressMyPictureController *my = [[BabyImpressMyPictureController alloc]init];
    [self.navigationController pushViewController:my animated:YES];
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
                [self useSystemPhoto];
                
            }
                break;
            case 2:
                //从手机相册选择
            {
                [self useExtentionPhoto];
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
    [XEProgressHUD AlertLoading:@"正在加载照片" At:self.view];
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ALAsset *representation = obj;
        NSLog(@"obj == %@",obj);
        UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                           scale:representation.defaultRepresentation.scale
                                     orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
        NSLog(@"img.size == %f %f",img.size.width,img.size.height);
        [self.dataSources addObject:img];
        [self.collectionView reloadData];
        
        
    }];
    
    [XEProgressHUD AlertSuccess:@"加载完成"];
    
    
}


#pragma mark imagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%@", info);
    UIImage *editedImage = info[@"UIImagePickerControllerOriginalImage"];
    //将imagePicker撤销
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.dataSources addObject:editedImage];

    [self.collectionView reloadData];
}



#pragma mark Cell delegate
- (void)babyImpressAddbtnTouched{
    [self.chooseWayUpload show];
}

- (void)babyImpressShowBtnTouchedWith:(NSInteger)index{
    NSLog(@"%ld",index);
    ImageScrollController *show = [[ImageScrollController alloc]init];
    show.ifHaveDelete = YES;
    show.array = self.dataSources;
    show.delegate = self;
    show.moveIndex = index;
    [self.navigationController pushViewController:show animated:YES];
}

- (void)deleteResultWith:(NSMutableArray *)array{
    self.dataSources = array;
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
        [cell configureCellWith:self.dataSources[indexPath.row]];
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
    return CGSizeMake(SCREEN_WIDTH, 200);
}

//定义区头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        BabyImpressAddFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        NSLog(@"you");
        return footer;
    }else{
        NSLog(@"you1");
        return nil;
    }

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
