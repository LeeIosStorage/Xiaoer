//
//  BabyProfileViewController.m
//  Xiaoer
//
//  Created by KID on 15/2/6.
//
//

#import "BabyProfileViewController.h"
#import "AppDelegate.h"
#import "MineTabCell.h"
#import "UIImageView+WebCache.h"
#import "XEInputViewController.h"
#import "XEActionSheet.h"
#import "SelectBirthdayViewController.h"
#import "XEImagePickerController.h"
#import "UIImage+ProportionalFill.h"
#import "AVCamUtilities.h"
#import "XEUIUtils.h"
#import "XEProgressHUD.h"
#import "XEEngine.h"
#import "QHQnetworkingTool.h"

@interface BabyProfileViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,XEInputViewControllerDelegate,SelectBirthdayViewControllerDelegate>
{
    BOOL _isEditStatus;
}
@property (nonatomic, strong) XEUserInfo *selectBabyInfo;
@property (nonatomic, strong) NSMutableArray *babyInfos;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation BabyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isEditStatus = NO;
    self.view.backgroundColor = UIColorRGB(240, 240, 240);
    
    _babyInfos = [[NSMutableArray alloc] init];
    if ([XEEngine shareInstance].userInfo.babys && [XEEngine shareInstance].userInfo.babys.count > 0) {
        [_babyInfos addObject:[[XEEngine shareInstance].userInfo.babys objectAtIndex:0]];
    }else{
        XEUserInfo *babyInfo = [[XEUserInfo alloc] init];
        [_babyInfos addObject:babyInfo];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    //title
    [self setTitle:@"宝宝资料"];
    [self setRightButtonWithTitle:@"编辑" selector:@selector(editAction:)];
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
    XEUserInfo *babyUserInfo = [self getBabyUserInfo:0];
    if (_babyInfos.count == 0) {
        [XEProgressHUD lightAlert:@"请填写宝宝资料"];
        return;
    }
    if (babyUserInfo.babyAvatarId.length == 0) {
        [XEProgressHUD lightAlert:@"请上传宝宝头像"];
        return;
    }
    if (babyUserInfo.babyNick.length == 0) {
        [XEProgressHUD lightAlert:@"请输入宝宝昵称"];
        return;
    }
    if ([XECommonUtils getHanziTextNum:babyUserInfo.babyNick] < 2) {
        [XEProgressHUD lightAlert:@"宝宝昵称太短了"];
        return;
    }
    if (babyUserInfo.babyGender.length == 0) {
        [XEProgressHUD lightAlert:@"请输入宝宝性别"];
        return;
    }
    if (babyUserInfo.birthdayString.length == 0) {
        [XEProgressHUD lightAlert:@"请输入宝宝生日"];
        return;
    }
    
    [XEProgressHUD AlertLoading:@"资料保存中" At:self.view];
    __weak BabyProfileViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] editBabyInfoWithUserId:[XEEngine shareInstance].uid bbId:babyUserInfo.babyId bbName:babyUserInfo.babyNick bbGender:babyUserInfo.babyGender bbBirthday:babyUserInfo.birthdayString bbAvatar:babyUserInfo.babyAvatarId acquiesce:nil tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"保存失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        
        [XEProgressHUD AlertSuccess:[XEEngine getSuccessMsgWithReponseDic:jsonRet] At:weakSelf.view];
        NSDictionary *babyDic = [jsonRet objectForKey:@"object"];
        
        NSMutableDictionary *userDic = [[NSMutableDictionary alloc] initWithDictionary:[XEEngine shareInstance].userInfo.userInfoByJsonDic];
        NSMutableArray *babyArray = [NSMutableArray array];
        [babyArray addObject:babyDic];
        [userDic setObject:babyArray forKey:@"babys"];
        
        XEUserInfo *userInfo = [XEEngine shareInstance].userInfo;
        [userInfo setUserInfoByJsonDic:userDic];
        [XEEngine shareInstance].userInfo = userInfo;
        
        [weakSelf.tableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
        
    }tag:tag];
    
}

-(XEUserInfo *)getBabyUserInfo:(NSInteger)index{
    
    if (_babyInfos.count > index) {
        XEUserInfo *babyUserInfo = [_babyInfos objectAtIndex:index];
        return babyUserInfo;
    }
    
    return nil;
}
#pragma mark - custom
-(void)editAction:(id)sender{
    if (_isEditStatus) {
        [self editUserInfo];
        return;
    }
    _isEditStatus = !_isEditStatus;
    if (_isEditStatus) {
        [UIView animateWithDuration:1.0 animations:^{
            [self setTitle:@"编辑宝宝资料"];
            [self setRightButtonWithTitle:@"保存"];
        }];
    }else{
        [UIView animateWithDuration:1.0 animations:^{
            [self setTitle:@"宝宝资料"];
            [self setRightButtonWithTitle:@"编辑"];
        }];
    }
    [self.tableView reloadData];
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
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.babyInfos.count;
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
    if (indexPath.row == 0) {
        return 61;
    }
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MineTabCell";
    MineTabCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    
    if (_isEditStatus) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CGRect frame = cell.leftAvater.frame;
    frame.size.width = 61-8*2;
    frame.size.height = frame.size.width;
    frame.origin.x = self.view.bounds.size.width - frame.size.width - 12;
    cell.leftAvater.frame = frame;
    cell.leftAvater.layer.cornerRadius = 5;
    cell.leftAvater.layer.masksToBounds = YES;
    
    frame = cell.titleLabel.frame;
    frame.origin.x = 13;
    cell.titleLabel.frame = frame;
    
    cell.introLabel.hidden = NO;
    cell.leftAvater.hidden = YES;
    if (indexPath.row == 0) {
        cell.leftAvater.hidden = NO;
        cell.introLabel.hidden = YES;
    }
    
    XEUserInfo *babyInfo = [self.babyInfos objectAtIndex:indexPath.section];
    
    NSString *titleName = @"";
    NSString *intro = @"";
    if (indexPath.row == 0){
        titleName = @"宝宝头像";
        intro = [babyInfo.babySmallAvatarUrl absoluteString];
    }else if (indexPath.row == 1){
        titleName = @"宝宝昵称";
        intro = babyInfo.babyNick!=nil?babyInfo.babyNick:@"2-16个字";
    }else if (indexPath.row == 2){
        titleName = @"宝宝性别";
        if ([babyInfo.babyGender isEqualToString:@"m"]) {
            intro = @"男宝宝";
        }else if ([babyInfo.babyGender isEqualToString:@"f"]){
            intro = @"女宝宝";
        }
    }else if (indexPath.row == 3){
        titleName = @"出生日期";
        intro = babyInfo.birthdayString;
    }
    
    cell.titleLabel.text = titleName;
    
    if (!cell.introLabel.hidden) {
        cell.introLabel.text = intro;
    }
    if (!cell.leftAvater.hidden) {
        [cell.leftAvater sd_setImageWithURL:nil];
        [cell.leftAvater sd_setImageWithURL:[NSURL URLWithString:intro] placeholderImage:[UIImage imageNamed:@"topic_avatar_icon"]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!_isEditStatus) {
        return;
    }
    
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
    XEUserInfo *babyInfo = [self.babyInfos objectAtIndex:indexPath.section];
    self.selectBabyInfo = babyInfo;
    
    if (indexPath.row == 0) {
        __weak BabyProfileViewController *weakSelf = self;
        XEActionSheet *sheet = [[XEActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"设置%@",@"宝宝头像"] actionBlock:^(NSInteger buttonIndex) {
            if (2 == buttonIndex) {
                return;
            }
            
            [weakSelf doActionSheetClickedButtonAtIndex:buttonIndex];
        } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择", @"拍一张", nil];
        [sheet showInView:self.view];
    }else if (indexPath.row == 1) {
        [self editBabyInfowithRowInfo:babyInfo];
    }else if (indexPath.row == 2){
        __weak BabyProfileViewController *weakSelf = self;
        XEActionSheet *sheet = [[XEActionSheet alloc] initWithTitle:@"宝宝性别" actionBlock:^(NSInteger buttonIndex) {
            if (2 == buttonIndex) {
                return;
            }
            if (buttonIndex == 0) {
                babyInfo.babyGender = @"m";
            }else if (buttonIndex == 1){
                babyInfo.babyGender = @"f";
            }
            [weakSelf.tableView reloadData];
        } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男宝宝", @"女宝宝", nil];
        [sheet showInView:self.view];
    }else if (indexPath.row == 3){
        
        SelectBirthdayViewController* selectBirthdayViewController = [[SelectBirthdayViewController alloc] init];
        selectBirthdayViewController.delegate = self;
        if (babyInfo.birthdayDate) {
            selectBirthdayViewController.oldDate = babyInfo.birthdayDate;
        }else{
            selectBirthdayViewController.oldDate = babyInfo.birthdayDate;
        }
        [self.navigationController pushViewController:selectBirthdayViewController animated:YES];
    }
}

-(void)editBabyInfowithRowInfo:(XEUserInfo *)babyInfo{
    
//    if (![_selectBabyInfo.babyId isEqualToString:babyInfo.babyId] && _selectBabyInfo.babyId && babyInfo.babyId) {
//        return;
//    }
    XEInputViewController *lvc = [[XEInputViewController alloc] init];
    lvc.delegate = self;
    lvc.oldText = _selectBabyInfo.babyNick;
    lvc.minTextLength = 2;
    lvc.maxTextLength = 16;
    lvc.titleText = @"宝宝昵称";
    [self.navigationController pushViewController:lvc animated:YES];
}

#pragma mark -XEInputViewControllerDelegate
- (void)inputViewControllerWithText:(NSString*)text{
    XELog(@"text==%@",text);
    _selectBabyInfo.babyNick = text;
    [self.tableView reloadData];
}

#pragma mark - SelectBirthdayViewControllerDelegate
- (void)SelectBirthdayWithDate:(NSDate *)date{
    _selectBabyInfo.birthdayDate = date;
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
        
        [self updateBabyAvatar:imageData];
        [self.tableView reloadData];
    }
    [picker dismissModalViewControllerAnimated:YES];
    //    [LSCommonUtils saveImageToAlbum:picker Img:image];
    
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
    
    [XEProgressHUD AlertLoading:@"头像上传中..." At:self.view];
    __weak BabyProfileViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] updateBabyAvatarWithBabyUid:nil avatar:dataArray tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"上传失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        [XEProgressHUD AlertSuccess:@"上传成功." At:weakSelf.view];
        weakSelf.selectBabyInfo.babyAvatarId = [jsonRet stringObjectForKey:@"object"];
        [weakSelf.tableView reloadData];
        
    }tag:tag];
}

@end
