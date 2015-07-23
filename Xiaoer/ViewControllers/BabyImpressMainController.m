//
//  BabyImpressMainController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/23.
//
//

#import "BabyImpressMainController.h"
#import "BabyImpressVerifyController.h"

@interface BabyImpressMainController ()<UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;
@property (nonatomic,strong)UIAlertView *chooseWayUpload;
@end

@implementation BabyImpressMainController

- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        self.imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//如果有相机，则设置图片选取器的类型为相机
        _imagePicker.delegate = self;//设置图片选择器的代理对象为当前视图控制器
        _imagePicker.allowsEditing = NO;
    }
    return _imagePicker;
}

- (UIAlertView *)chooseWayUpload{
    if (!_chooseWayUpload) {
        self.chooseWayUpload = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    }
    return _chooseWayUpload;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 上传照片按钮点击
- (IBAction)uploadPhotoBtnTouched:(id)sender {
    [self.chooseWayUpload show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == self.chooseWayUpload) {
        NSLog(@"%ld ",(long)buttonIndex);

        switch (buttonIndex) {
            case 0:
                //取消
            {
                BabyImpressVerifyController *verify = [[BabyImpressVerifyController alloc]init];
                [self.navigationController pushViewController:verify animated:YES];
            }
                break;
            case 1:
                //拍照
            {
                if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"未检测到摄像头" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                    return;
                }else{
                    [self presentViewController:self.imagePicker animated:YES completion:^{
                        
                    }];
                }
            }
                break;
            case 2:
                //从手机相册选择
            {
                UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
                picker.delegate = self;
                picker.maximumNumberOfSelectionVideo = 0;
                picker.maximumNumberOfSelectionPhoto = 10;
                [self presentViewController:picker animated:YES completion:^{
                    
                }];
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
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ALAsset *representation = obj;
        NSLog(@"obj == %@",obj);
        UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                           scale:representation.defaultRepresentation.scale
                                     orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
        NSLog(@"img.size == %f %f",img.size.width,img.size.height);
        
        
    }];
    
    
    
    
}

#pragma mark imagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%@", info);
    UIImage *editedImage = info[@"UIImagePickerControllerOriginalImage"];
    self.testImageView.image = editedImage;
    //将imagePicker撤销
    [self dismissViewControllerAnimated:YES completion:nil];
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
