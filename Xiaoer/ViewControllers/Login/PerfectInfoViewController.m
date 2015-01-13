//
//  PerfectInfoViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/8.
//
//

#import "PerfectInfoViewController.h"
#import "AppDelegate.h"
#import "MineTabCell.h"
#import "UIImageView+WebCache.h"
#import "XEInputViewController.h"
#import "XEActionSheet.h"
#import "XEAlertView.h"
#import "XEImagePickerController.h"
#import "UIImage+ProportionalFill.h"
#import "AVCamUtilities.h"
#import "XEUIUtils.h"
#import "XEProgressHUD.h"
#import "XEEngine.h"
#import "QHQnetworkingTool.h"
#import "SelectBirthdayViewController.h"
#import "ChooseLocationViewController.h"

#define TAG_USER_NAME      0
#define TAG_USER_IDENTITY  1
#define TAG_USER_REGION    2
#define TAG_USER_ADDRESS   3
#define TAG_USER_PHONE     4
#define TAG_BOBY_NAME      5
#define TAG_BOBY_GENDER    6
#define TAG_BOBY_DATE      7
#define TAG_USER_AVATER    8
#define TAG_BOBY_AVATER    9

@interface PerfectInfoViewController () <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,XEInputViewControllerDelegate,SelectBirthdayViewControllerDelegate,ChooseLocationDelegate>
{
    int _editTag;
    UIImage *_userAvatar;
    NSData  *_userData;
    UIImage *_babyAvatar;
    NSData  *_babyData;
    NSString *_babyAvatarId;
}
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

- (IBAction)saveAction:(id)sender;
@end

@implementation PerfectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    XEUserInfo *oldUserInfo = _userInfo;
    oldUserInfo.uid = _userInfo.uid;
    if (_userInfo.title.length == 0) {
        _userInfo.title = @"妈妈";
    }
    _userInfo = [[XEUserInfo alloc] init];
    _userInfo = oldUserInfo;
    
    [self setTilteLeftViewHide:YES];
    self.saveButton.layer.cornerRadius = 4;
    self.saveButton.layer.masksToBounds = YES;
    self.tableView.tableFooterView = self.footerView;
    self.view.backgroundColor = UIColorRGB(240, 240, 240);
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    //title
    [self setTitle:@"完善资料"];
    
    [self setRightButtonWithTitle:@"跳过" selector:@selector(skipAction:)];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)editUserInfo{
    
//    _babyAvatar = [UIImage imageNamed:@"tmp_avatar_icon"];
//    NSData* imageData = UIImageJPEGRepresentation(_babyAvatar, XE_IMAGE_COMPRESSION_QUALITY);
//    NSString* pictureDataString =[imageData base64Encoding];
//    NSString *dataStr = [[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding];
    
    
    [XEProgressHUD AlertLoading:@"保存中"];
    __weak PerfectInfoViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] editUserInfoWithUid:_userInfo.uid name:@"1" nickname:_userInfo.nickName title:_userInfo.title desc:@"1" district:_userInfo.region address:_userInfo.address bbId:nil bbName:_userInfo.babyNick bbGender:_userInfo.babyGender bbBirthday:_userInfo.birthdayString bbAvatar:_userInfo.babyAvatarId tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"保存失败";
            }
            return;
        }
        
        [XEProgressHUD AlertSuccess:@"保存成功."];
        [weakSelf.tableView reloadData];
        
    }tag:tag];
    
}

#pragma mark - custom
-(void)skipAction:(id)sender{
    
    XEAlertView *alertView = [[XEAlertView alloc] initWithTitle:nil message:@"你确定要跳过吗？确定将不保存已输入的内容" cancelButtonTitle:@"取消" cancelBlock:^{
        
    } okButtonTitle:@"确认" okBlock:^{
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate signIn];
    }];
    [alertView show];
}

- (IBAction)saveAction:(id)sender {
    
    if (!_userData) {
        [XEProgressHUD lightAlert:@"请上传用户头像"];
        return;
    }
    if (_userInfo.nickName.length == 0) {
        [XEProgressHUD lightAlert:@"请输入昵称"];
        return;
    }
    if ([XECommonUtils getHanziTextNum:_userInfo.nickName] < 2) {
        [XEProgressHUD lightAlert:@"昵称太短了"];
        return;
    }
    if (_userInfo.babyAvatarId.length == 0) {
        [XEProgressHUD lightAlert:@"请上传宝宝头像"];
        return;
    }
    if (_userInfo.babyNick.length == 0) {
        [XEProgressHUD lightAlert:@"请输入宝宝昵称"];
        return;
    }
    if ([XECommonUtils getHanziTextNum:_userInfo.babyNick] < 2) {
        [XEProgressHUD lightAlert:@"宝宝昵称太短了"];
        return;
    }
//    if (_userInfo.region.length == 0) {
//        [XEProgressHUD lightAlert:@"请输入您的地区"];
//        return;
//    }
    if (_userInfo.birthdayString.length == 0) {
        [XEProgressHUD lightAlert:@"请输入宝宝生日"];
        return;
    }
    if (_userInfo.babyGender.length == 0) {
        [XEProgressHUD lightAlert:@"请输入宝宝性别"];
        return;
    }
    
    [self editUserInfo];
}

-(void)doActionSheetClickedButtonAtIndex:(NSInteger)buttonIndex{
    if (1 == buttonIndex ) {
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
    }
    
    XEImagePickerController *picker = [[XEImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if (buttonIndex == 1) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

-(NSDictionary *)tableDataModule{
    NSDictionary *moduleDict;
    NSMutableDictionary *tmpMutDict = [NSMutableDictionary dictionary];
    
    
    //section = 0
    NSMutableDictionary *sectionDict0 = [NSMutableDictionary dictionary];
    NSString *intro = _userInfo.avatarId;
    NSDictionary *dict00 = @{@"titleLabel": @"我的头像",
                           @"intro": intro!=nil?intro:@"",
                           };
    [sectionDict0 setObject:dict00 forKey:[NSString stringWithFormat:@"r%ld",sectionDict0.count]];
    
    //section = 1
    NSMutableDictionary *sectionDict1 = [NSMutableDictionary dictionary];
    intro = _userInfo.nickName;
    NSDictionary *dict10 = @{@"titleLabel": @"昵称",
                            @"intro": intro!=nil?intro:@"2-16个字",
                            };
    intro = _userInfo.title;
    NSDictionary *dict11 = @{@"titleLabel": @"我的身份",
                             @"intro": intro!=nil?intro:@"",
                             };
    intro = _userInfo.region;
    NSDictionary *dict12 = @{@"titleLabel": @"地区",
                             @"intro": intro!=nil?intro:@"",
                             };
    intro = _userInfo.address;
    NSDictionary *dict13 = @{@"titleLabel": @"详细地址",
                             @"intro": intro!=nil?intro:@"",
                             };
    intro = _userInfo.phone;
    NSDictionary *dict14 = @{@"titleLabel": @"常用手机",
                             @"intro": intro!=nil?intro:@"",
                             };
    [sectionDict1 setObject:dict10 forKey:[NSString stringWithFormat:@"r%ld",sectionDict1.count]];
    [sectionDict1 setObject:dict11 forKey:[NSString stringWithFormat:@"r%ld",sectionDict1.count]];
    [sectionDict1 setObject:dict12 forKey:[NSString stringWithFormat:@"r%ld",sectionDict1.count]];
    [sectionDict1 setObject:dict13 forKey:[NSString stringWithFormat:@"r%ld",sectionDict1.count]];
    [sectionDict1 setObject:dict14 forKey:[NSString stringWithFormat:@"r%ld",sectionDict1.count]];
    
    //section = 2
    NSMutableDictionary *sectionDict2 = [NSMutableDictionary dictionary];
    intro = _userInfo.babyAvatarId;
    NSDictionary *dict20 = @{@"titleLabel": @"宝宝头像",
                             @"intro": intro!=nil?intro:@"",
                             };
    intro = _userInfo.babyNick;
    NSDictionary *dict21 = @{@"titleLabel": @"宝宝昵称",
                             @"intro": intro!=nil?intro:@"2-16个字",
                             };
    intro = @"";
    if ([_userInfo.babyGender isEqualToString:@"m"]) {
        intro = @"男宝宝";
    }else if ([_userInfo.babyGender isEqualToString:@"f"]){
        intro = @"女宝宝";
    }
    NSDictionary *dict22 = @{@"titleLabel": @"宝宝性别",
                             @"intro": intro!=nil?intro:@"",
                             };
    intro = _userInfo.birthdayString;
    NSDictionary *dict23 = @{@"titleLabel": @"出生日期",
                             @"intro": intro!=nil?intro:@"",
                             };
    [sectionDict2 setObject:dict20 forKey:[NSString stringWithFormat:@"r%ld",sectionDict2.count]];
    [sectionDict2 setObject:dict21 forKey:[NSString stringWithFormat:@"r%ld",sectionDict2.count]];
    [sectionDict2 setObject:dict22 forKey:[NSString stringWithFormat:@"r%ld",sectionDict2.count]];
    [sectionDict2 setObject:dict23 forKey:[NSString stringWithFormat:@"r%ld",sectionDict2.count]];
    
    
    
    [tmpMutDict setObject:sectionDict0 forKey:[NSString stringWithFormat:@"s%ld",tmpMutDict.count]];
    [tmpMutDict setObject:sectionDict1 forKey:[NSString stringWithFormat:@"s%ld",tmpMutDict.count]];
    [tmpMutDict setObject:sectionDict2 forKey:[NSString stringWithFormat:@"s%ld",tmpMutDict.count]];
    
    moduleDict = tmpMutDict;
    return moduleDict;
}

-(NSInteger)newSections{
    
    return [[self tableDataModule] allKeys].count;
}
-(NSInteger)newSectionPolicy:(NSInteger)section{
    
    NSDictionary *rowContentDic = [[self tableDataModule] objectForKey:[NSString stringWithFormat:@"s%ld", section]];
    return [rowContentDic count];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self newSections];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 61;
    }else if (indexPath.section == 1){
        return 35;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 61;
        }
    }
    return 35;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self newSectionPolicy:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MineTabCell";
    MineTabCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    
    CGRect frame = cell.leftAvater.frame;
    frame.size.width = 61-8*2;
    frame.size.height = frame.size.width;
    frame.origin.x = cell.frame.size.width - frame.size.width - 12;
    cell.leftAvater.frame = frame;
    cell.leftAvater.layer.cornerRadius = 5;
    cell.leftAvater.layer.masksToBounds = YES;
    
    cell.introLabel.hidden = NO;
    cell.leftAvater.hidden = YES;
    if (indexPath.section == 0 || indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.leftAvater.hidden = NO;
            cell.introLabel.hidden = YES;
        }
    }
    
    NSDictionary *cellDicts = [[self tableDataModule] objectForKey:[NSString stringWithFormat:@"s%ld", indexPath.section]];
    NSDictionary *rowDicts = [cellDicts objectForKey:[NSString stringWithFormat:@"r%ld", indexPath.row]];
    cell.titleLabel.text = [rowDicts objectForKey:@"titleLabel"];
    
    if (!cell.introLabel.hidden) {
        cell.introLabel.text = [rowDicts objectForKey:@"intro"];
    }
    if (!cell.leftAvater.hidden) {
        if (_userAvatar && indexPath.section == 0) {
            [cell.leftAvater setImage:_userAvatar];
        }else if (_babyAvatar && indexPath.section == 2){
            [cell.leftAvater setImage:_babyAvatar];
        }else{
            [cell.leftAvater sd_setImageWithURL:nil];
            [cell.leftAvater sd_setImageWithURL:[NSURL URLWithString:[rowDicts objectForKey:@"intro"]] placeholderImage:[UIImage imageNamed:@"tmp_avatar_icon"]];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
    NSDictionary *cellDicts = [[self tableDataModule] objectForKey:[NSString stringWithFormat:@"s%ld", indexPath.section]];
    NSDictionary *rowDicts = [cellDicts objectForKey:[NSString stringWithFormat:@"r%ld", indexPath.row]];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            _editTag = TAG_USER_AVATER;
            __weak PerfectInfoViewController *weakSelf = self;
            XEActionSheet *sheet = [[XEActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"设置%@",[rowDicts objectForKey:@"titleLabel"]] actionBlock:^(NSInteger buttonIndex) {
                if (2 == buttonIndex) {
                    return;
                }
                
                [weakSelf doActionSheetClickedButtonAtIndex:buttonIndex];
            } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择", @"拍一张", nil];
            [sheet showInView:self.view];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self editUserInfo:TAG_USER_NAME withRowDicts:rowDicts];
        }else if (indexPath.row == 1){
            _editTag = TAG_USER_IDENTITY;
            __weak PerfectInfoViewController *weakSelf = self;
            XEActionSheet *sheet = [[XEActionSheet alloc] initWithTitle:@"身份" actionBlock:^(NSInteger buttonIndex) {
                if (2 == buttonIndex) {
                    return;
                }
                if (buttonIndex == 0) {
                    _userInfo.title = @"妈妈";
                }else if (buttonIndex == 1){
                    _userInfo.title = @"爸爸";
                }
                [weakSelf.tableView reloadData];
            } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"我是妈妈", @"我是爸爸", nil];
            [sheet showInView:self.view];
        }else if (indexPath.row == 2){
            _editTag = TAG_USER_REGION;
            //            [self editUserInfo:TAG_USER_REGION withRowDicts:rowDicts];
            ChooseLocationViewController *chooseLocationVc=[[ChooseLocationViewController alloc] initWithLoactionType:ChooseLoactionTypeProvince WithCode:nil];
            chooseLocationVc.delegate=self;
            [self.navigationController pushViewController:chooseLocationVc animated:YES];
        }else if (indexPath.row == 3){
            [self editUserInfo:TAG_USER_ADDRESS withRowDicts:rowDicts];
        }else if (indexPath.row == 4){
            [self editUserInfo:TAG_USER_PHONE withRowDicts:rowDicts];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            _editTag = TAG_BOBY_AVATER;
            __weak PerfectInfoViewController *weakSelf = self;
            XEActionSheet *sheet = [[XEActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"设置%@",[rowDicts objectForKey:@"titleLabel"]] actionBlock:^(NSInteger buttonIndex) {
                if (2 == buttonIndex) {
                    return;
                }
                
                [weakSelf doActionSheetClickedButtonAtIndex:buttonIndex];
            } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择", @"拍一张", nil];
            [sheet showInView:self.view];
        }else if (indexPath.row == 1) {
            [self editUserInfo:TAG_BOBY_NAME withRowDicts:rowDicts];
        }else if (indexPath.row == 2){
            _editTag = TAG_BOBY_GENDER;
            __weak PerfectInfoViewController *weakSelf = self;
            XEActionSheet *sheet = [[XEActionSheet alloc] initWithTitle:@"宝宝性别" actionBlock:^(NSInteger buttonIndex) {
                if (2 == buttonIndex) {
                    return;
                }
                if (buttonIndex == 0) {
                    weakSelf.userInfo.babyGender = @"m";
                }else if (buttonIndex == 1){
                    weakSelf.userInfo.babyGender = @"f";
                }
                [weakSelf.tableView reloadData];
            } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男宝宝", @"女宝宝", nil];
            [sheet showInView:self.view];
        }else if (indexPath.row == 3){
            _editTag = TAG_BOBY_DATE;
            
            SelectBirthdayViewController* selectBirthdayViewController = [[SelectBirthdayViewController alloc] init];
            selectBirthdayViewController.delegate = self;
            if (_userInfo.birthdayDate) {
                selectBirthdayViewController.oldDate = _userInfo.birthdayDate;
            }else{
                selectBirthdayViewController.oldDate = _userInfo.birthdayDate;
            }
            [self.navigationController pushViewController:selectBirthdayViewController animated:YES];
            
//            NSDate *nowDate = [NSDate date];
//            _userInfo.birthdayDate = nowDate;
//            [self.tableView reloadData];
        }
    }
}

-(void)editUserInfo:(int)Tag withRowDicts:(NSDictionary *)rowDicts{
    
    _editTag = Tag;
    XEInputViewController *lvc = [[XEInputViewController alloc] init];
    lvc.delegate = self;
    lvc.oldText = [rowDicts objectForKey:@"intro"];
    if (Tag == TAG_USER_NAME) {
        lvc.oldText = _userInfo.nickName;
        lvc.minTextLength = 2;
        lvc.maxTextLength = 16;
    }
    if (Tag == TAG_BOBY_NAME) {
        lvc.oldText = _userInfo.babyNick;
        lvc.minTextLength = 2;
        lvc.maxTextLength = 16;
    }
    if (Tag == TAG_USER_PHONE) {
        lvc.oldText = _userInfo.phone;
//        lvc.minTextLength = 1;
//        lvc.maxTextLength = 6;
        lvc.maxTextViewHight = 50.0f;
    }
    lvc.titleText = [rowDicts objectForKey:@"titleLabel"];
    [self.navigationController pushViewController:lvc animated:YES];
}

#pragma mark -XEInputViewControllerDelegate
- (void)inputViewControllerWithText:(NSString*)text{
    XELog(@"text==%@",text);
    if (_editTag == TAG_USER_NAME) {
        _userInfo.nickName = text;
    }else if (_editTag == TAG_USER_REGION){
        _userInfo.region = text;
    }else if (_editTag == TAG_USER_ADDRESS){
        _userInfo.address = text;
    }else if (_editTag == TAG_USER_PHONE){
        _userInfo.phone = text;
    }else if (_editTag == TAG_BOBY_NAME){
        _userInfo.babyNick = text;
    }
    [self.tableView reloadData];
}

#pragma mark - SelectBirthdayViewControllerDelegate
- (void)SelectBirthdayWithDate:(NSDate *)date{
    
    _userInfo.birthdayDate = date;
    [self.tableView reloadData];
    
}

#pragma mark - ChooseLocationDelegate
-(void) didSelectLocation:(NSDictionary *)location
{
    [self.tableView reloadData];
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
        
        NSData* imageData = UIImageJPEGRepresentation(imageAfterScale, XE_IMAGE_COMPRESSION_QUALITY);
//        XELog(@"imageData%@",imageData);
        
        if (_editTag == TAG_USER_AVATER) {
            _userData = imageData;
            _userAvatar = imageAfterScale;
            [self updateUserAvatar:imageData];
        }else if (_editTag == TAG_BOBY_AVATER){
            _babyData = imageData;
            _babyAvatar = imageAfterScale;
            [self updateBabyAvatar:imageData];
        }
        [self.tableView reloadData];
    }
    [picker dismissModalViewControllerAnimated:YES];
//    [LSCommonUtils saveImageToAlbum:picker Img:image];
    
}

-(void)updateUserAvatar:(NSData *)data{
    
    QHQFormData* pData = [[QHQFormData alloc] init];
    pData.data = data;
    pData.name = @"avatar";
    pData.filename = @"userAvatar";
    pData.mimeType = @"image/png";
    
    [XEProgressHUD AlertLoading:@"头像上传中..."];
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] updateAvatarWithUid:_userInfo.uid avatar:@[pData] tag:tag];
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
    }tag:tag];
}

-(void)updateBabyAvatar:(NSData *)data{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    if (data) {
        QHQFormData* pData = [[QHQFormData alloc] init];
        pData.data = data;
        pData.name = @"bbavatar";
        pData.filename = @"bbAvatar";
        pData.mimeType = @"image/png";
        [dataArray addObject:pData];
    }
    
    [XEProgressHUD AlertLoading:@"头像上传中..."];
    __weak PerfectInfoViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] updateBabyAvatarWithBabyUid:nil avatar:dataArray tag:tag];
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
        weakSelf.userInfo.babyAvatarId = [jsonRet stringObjectForKey:@"object"];
        [weakSelf.tableView reloadData];
        
    }tag:tag];
}

@end
