//
//  BabyImpressMainController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/23.
//
//

#import "BabyImpressMainController.h"
#import "BabyImpressVerifyController.h"
#import "BabyImpressAddController.h"

@interface BabyImpressMainController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;
@property (nonatomic,strong)UIAlertView *chooseWayUpload;
@end

@implementation BabyImpressMainController



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
                    BabyImpressAddController *add = [[BabyImpressAddController alloc]init];
                    add.index = 0;
                    [self.navigationController pushViewController:add animated:YES];


                }

            }
                break;
            case 2:
                //从手机相册选择
            {
                BabyImpressAddController *add = [[BabyImpressAddController alloc]init];
                add.index = 1;
                [self.navigationController pushViewController:add animated:YES];
            }
                break;
            default:
                break;
        }
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
