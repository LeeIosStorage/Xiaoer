//
//  XEImagePickerController.m
//  Xiaoer
//
//  Created by KID on 15/1/8.
//
//

#import "XEImagePickerController.h"
#import "XESettingConfig.h"
#import "AVCamCaptureManager.h"

@interface XEImagePickerController ()

@end

@implementation XEImagePickerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
        
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
    if (self.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //恢复上次的相机状态
        UIImagePickerControllerCameraFlashMode flashModel = [[XESettingConfig staticInstance] systemCameraFlashStatus];
        if (flashModel < UIImagePickerControllerCameraFlashModeOff || flashModel > UIImagePickerControllerCameraFlashModeOn) {
            flashModel = UIImagePickerControllerCameraFlashModeAuto;
        }
        [self setCameraFlashMode:flashModel];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{    
    if (self.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //记录当前的相机状态
        UIImagePickerControllerCameraFlashMode flashModel = [self cameraFlashMode];
        //    NSLog(@"flashModel = %d", flashModel);
        //ios7.1系统存在bug,cameraFlashMode无法获取。只能用AVCaptureDevice识别

        Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
        if (captureDeviceClass != nil) {
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            [device lockForConfiguration:nil];
            if ([device hasFlash]) {
                if (device.flashMode ==  AVCaptureFlashModeAuto) {
                    flashModel = UIImagePickerControllerCameraFlashModeAuto;
                }else if (device.flashMode ==  AVCaptureFlashModeOn) {
                    flashModel = UIImagePickerControllerCameraFlashModeOn;
                }else if (device.flashMode ==  AVCaptureFlashModeOff) {
                    flashModel = UIImagePickerControllerCameraFlashModeOff;
                }
            }
            [device unlockForConfiguration];
        }

        [[XESettingConfig staticInstance] setSystemCameraFlashStatus:flashModel];
    }
    [super viewDidDisappear:animated];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
