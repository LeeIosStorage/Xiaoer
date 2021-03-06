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
#import "JSONKit.h"
#import "NSString+Value.h"
#import "ApplyActivityViewController.h"

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
#define TAG_USER_DUEDATE   10
#define TAG_USER_HOSPITAL  11

@interface PerfectInfoViewController () <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,XEInputViewControllerDelegate,SelectBirthdayViewControllerDelegate,ChooseLocationDelegate>
{
    int _editTag;
    UIImage *_userAvatar;
    NSData  *_userData;
    UIImage *_babyAvatar;
    NSData  *_babyData;
    NSString *_babyAvatarId;
    NSString *_userAvatarId;
    
    XEUserInfo *_oldUserInfo;
}
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@property (assign, nonatomic) int showType;//阶段类型 0无选择 1怀孕中 2已有宝宝 3怀孕中且已有宝宝

- (IBAction)saveAction:(id)sender;
@end

@implementation PerfectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"8===========================");
    if (_userInfo == nil || _userInfo.uid.length == 0) {
        [XEProgressHUD AlertError:@"用户不存在"];
    }
    
    XEUserInfo* tmpUserInfo = _userInfo;
    _oldUserInfo = [[XEUserInfo alloc] init];
    [_oldUserInfo setUserInfoByJsonDic:tmpUserInfo.userInfoByJsonDic];
    
    _userInfo = [[XEUserInfo alloc] init];
    [_userInfo setUserInfoByJsonDic:tmpUserInfo.userInfoByJsonDic];
    _userInfo.uid = tmpUserInfo.uid;
    if (!_userInfo.hasbaby || _userInfo.hasbaby.length == 0) {
        XEUserInfo *babyUserInfo = [self getBabyUserInfo:0];
        if (babyUserInfo.babyId.length > 0) {
            _userInfo.hasbaby = @"y";
        }
    }
    
    [self setTilteLeftViewHide:_isNeedSkip];
    self.saveButton.layer.cornerRadius = 4;
    self.saveButton.layer.masksToBounds = YES;
    self.tableView.tableFooterView = self.footerView;
    self.view.backgroundColor = UIColorRGB(240, 240, 240);
    
    [self.tableView reloadData];
    [self refreshViewUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    //title
    [self setTitle:@"完善资料"];
    if (_isNeedSkip) {
        [self setRightButtonWithTitle:@"跳过" selector:@selector(skipAction:)];
    }
}

-(void)backAction:(id)sender{
    if ([self isChangedWithUserInfo]) {
        
        __weak PerfectInfoViewController *weakSlef = self;
        XEAlertView *alert = [[XEAlertView alloc] initWithTitle:nil message:@"资料已修改还没保存哦！" cancelButtonTitle:@"取消" cancelBlock:^{
            [super backAction:sender];
        } okButtonTitle:@"保存" okBlock:^{
            [weakSlef saveAction:nil];
        }];
        [alert show];
    }else{
        
        [super backAction:sender];
    }
}

- (int)showType{
    
    if (_userInfo.hasbaby.length == 0 || !_userInfo.hasbaby) {
        return 0;
    }
    
    XEUserInfo *babyUserInfo = [self getBabyUserInfo:0];
    if ([_userInfo.hasbaby isEqualToString:@"n"] && babyUserInfo.babyId.length > 0){
        return 3;
    }
    
    if ([_userInfo.hasbaby isEqualToString:@"n"]) {
        return 1;
    }else if ([_userInfo.hasbaby isEqualToString:@"y"]){
        return 2;
    }
    return 0;
}

- (void)refreshViewUI{
    if (_isNeedSkip) {
        [self.saveButton setTitle:@"完成" forState:0];
    }
    if (_isFromActivity) {
        [self.saveButton setTitle:@"确认报名" forState:0];
        if (_activityInfo.aType == 1) {
            [self.saveButton setTitle:@"确认抢票" forState:0];
        }
    }
    if (_isFromCard) {
        [self.saveButton setTitle:@"确认领取" forState:0];
    }
    
    [self.tableView reloadData];
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
    [XEProgressHUD AlertLoading:@"保存中" At:self.view];
    __weak PerfectInfoViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] editUserInfoWithUid:_userInfo.uid name:_userInfo.name nickname:_userInfo.nickName hasBaby:_userInfo.hasbaby desc:_userInfo.desc district:_userInfo.region address:_userInfo.address phone:_userInfo.phone bbId:babyUserInfo.babyId bbName:babyUserInfo.babyNick bbGender:babyUserInfo.babyGender bbBirthday:babyUserInfo.birthdayString bbAvatar:babyUserInfo.babyAvatarId userAvatar:_userInfo.avatar dueDate:_userInfo.dueDateString hospital:_userInfo.hospital tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"保存失败";  
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        
        [XEProgressHUD AlertSuccess:[XEEngine getSuccessMsgWithReponseDic:jsonRet] At:weakSelf.view];
        [_userInfo setUserInfoByJsonDic:[[jsonRet objectForKey:@"object"] objectForKey:@"user"]];
        [XEEngine shareInstance].userInfo = _userInfo;
        [weakSelf.tableView reloadData];
        
        if (_isNeedSkip) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate signIn];
        }else if (_isFromActivity){
            [self applyActivity];
        }else if (_isFromCard){
            [self receiveCard];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }tag:tag];
    
}

-(void)checkPhone:(NSString *)phone{
    
    if (![phone isPhone]) {
        [XEProgressHUD lightAlert:@"请输入正确的手机号"];
        return;
    }
    self.userInfo.phone = phone;
    [self.tableView reloadData];
    return;
    
//    [XEProgressHUD AlertLoading:@"正在验证手机号" At:self.view];
//    __weak PerfectInfoViewController *weakSelf = self;
//    int tag = [[XEEngine shareInstance] getConnectTag];
//    [[XEEngine shareInstance] checkPhoneWithPhone:phone uid:nil tag:tag];
//    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//        
//        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
//        if (!jsonRet || errorMsg) {
//            if (!errorMsg.length) {
//                errorMsg = @"请求失败!";
//            }
//            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
//            return;
//        }
//        [XEProgressHUD AlertLoadDone];
//        weakSelf.userInfo.phone = phone;
//        [weakSelf.tableView reloadData];
//    }tag:tag];
    
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
    
//    if (_userInfo.avatar.length == 0) {
//        [XEProgressHUD lightAlert:@"请上传用户头像"];
//        return;
//    }
    if (_userInfo.nickName.length == 0) {
        [XEProgressHUD lightAlert:@"请输入昵称"];
        return;
    }
    if ([XECommonUtils getHanziTextNum:_userInfo.nickName] < 2) {
        [XEProgressHUD lightAlert:@"昵称太短了"];
        return;
    }
    if (_isFromCard || _isFromActivity) {
        if (_userInfo.hasbaby.length == 0) {
            [XEProgressHUD lightAlert:@"请输入您的阶段类型"];
            return;
        }
        if (_userInfo.regionName.length == 0) {
            [XEProgressHUD lightAlert:@"请输入您的地区"];
            return;
        }
//        if (_userInfo.address.length == 0) {
//            [XEProgressHUD lightAlert:@"请输入您的详细地址"];
//            return;
//        }
        if (_userInfo.phone.length == 0) {
            [XEProgressHUD lightAlert:@"请输入您的常用手机"];
            return;
        }
    }
    if (self.showType == 2 || self.showType == 3){
        XEUserInfo *babyUserInfo = [self getBabyUserInfo:0];
//        if (babyUserInfo.babyAvatarId.length == 0) {
//            [XEProgressHUD lightAlert:@"请上传宝宝头像"];
//            return;
//        }
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
    }
    if (self.showType == 1 || self.showType == 3) {
        if (_userInfo.dueDateString.length == 0) {
            [XEProgressHUD lightAlert:@"请输入预产期"];
            return;
        }
        if (_userInfo.hospital.length == 0) {
            [XEProgressHUD lightAlert:@"请输入产检医院"];
            return;
        }
    }
    
    if (_isFromActivity || _isFromCard) {
        [self editUserInfo];
        return;
    }
    
    if ([self isChangedWithUserInfo]) {
        
        [self editUserInfo];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

-(BOOL)isChangedWithUserInfo{
    //baby信息
    XEUserInfo *babyUserInfo = [self getBabyUserInfo:0];
    XEUserInfo *oldBabyUserInfo = [self getOldBabyUserInfo:0];
    BOOL isBabyInfoChange = (![babyUserInfo.babyAvatarId isEqualToString:oldBabyUserInfo.babyAvatarId] || ![babyUserInfo.babyNick isEqualToString:oldBabyUserInfo.babyNick] || ![babyUserInfo.birthdayString isEqualToString:oldBabyUserInfo.birthdayString] || ![babyUserInfo.babyGender isEqualToString:oldBabyUserInfo.babyGender]);
    
    //怀孕信息
    BOOL isPregnancyChange = (![_userInfo.dueDateString isEqualToString:_oldUserInfo.dueDateString] || ![_userInfo.hospital isEqualToString:_oldUserInfo.hospital]);
    
    //user信息
    BOOL isUserInfoChange = (![_userInfo.avatar isEqualToString:_oldUserInfo.avatar] || ![_userInfo.nickName isEqualToString:_oldUserInfo.nickName] || ![_userInfo.hasbaby isEqualToString:_oldUserInfo.hasbaby] || ![_userInfo.address isEqualToString:_oldUserInfo.address] || ![_userInfo.phone isEqualToString:_oldUserInfo.phone] || ![_userInfo.regionName isEqualToString:_oldUserInfo.regionName]);
    if (self.showType == 0) {
        return isUserInfoChange;
    }else if (self.showType == 1){
        return (isUserInfoChange || isPregnancyChange);
    }else if (self.showType == 2){
        return (isUserInfoChange || isBabyInfoChange);
    }else if (self.showType == 3){
        return (isUserInfoChange || isBabyInfoChange || isPregnancyChange);
    }
    return YES;
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

-(XEUserInfo *)getBabyUserInfo:(NSInteger)index{
    
    if (!_userInfo.babys) {
        _userInfo.babys = [[NSMutableArray alloc] init];
    }
    if (_userInfo.babys.count == 0) {
        XEUserInfo *babyInfo = [[XEUserInfo alloc] init];
        [_userInfo.babys addObject:babyInfo];
    }
    if (_userInfo.babys.count > index) {
        XEUserInfo *babyUserInfo = [_userInfo.babys objectAtIndex:index];
        return babyUserInfo;
    }
    
    return nil;
}

-(XEUserInfo *)getOldBabyUserInfo:(NSInteger)index{
    if (_oldUserInfo.babys.count > index) {
        XEUserInfo *babyUserInfo = [_oldUserInfo.babys objectAtIndex:index];
        return babyUserInfo;
    }
    return nil;
}

-(void)reloadDataWithAnimation{
    NSMutableArray *sectionArray=[NSMutableArray array];
    for (int section=0; section<[self newSections]; section++) {
        NSDictionary *cellDicts = [[self tableDataModule] objectForKey:[NSString stringWithFormat:@"s%d", section]];
//        NSMutableArray *rowArray=[NSMutableArray array];
        for (int row=0; row<cellDicts.allKeys.count; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            [sectionArray addObject:indexPath];
        }
//        [sectionArray addObject:rowArray];
    }
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:sectionArray withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

-(NSDictionary *)tableDataModule{
    NSDictionary *moduleDict;
    NSMutableDictionary *tmpMutDict = [NSMutableDictionary dictionary];
    
    
    //section = 0
    NSMutableDictionary *sectionDict0 = [NSMutableDictionary dictionary];
    NSString *intro = _userInfo.getSmallAvatarUrl;
    NSDictionary *dict00 = @{@"titleLabel": @"我的头像",
                           @"intro": intro!=nil?intro:@"",
                           };
    [sectionDict0 setObject:dict00 forKey:[NSString stringWithFormat:@"r%d",(int)sectionDict0.count]];
    
    //section = 1
    NSMutableDictionary *sectionDict1 = [NSMutableDictionary dictionary];
    intro = _userInfo.nickName;
    NSDictionary *dict10 = @{@"titleLabel": @"昵称",
                            @"intro": intro!=nil?intro:@"2-16个字",
                            };
    intro = @"";
    if ([_userInfo.hasbaby isEqualToString:@"y"]) {
        intro = @"已有宝宝";
    }else if ([_userInfo.hasbaby isEqualToString:@"n"]){
        intro = @"怀孕中";
    }
    NSDictionary *dict11 = @{@"titleLabel": @"阶段类型",
                             @"intro": intro!=nil?intro:@"",
                             };
    intro = _userInfo.regionName;
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
    [sectionDict1 setObject:dict10 forKey:[NSString stringWithFormat:@"r%d",(int)sectionDict1.count]];
    [sectionDict1 setObject:dict11 forKey:[NSString stringWithFormat:@"r%d",(int)sectionDict1.count]];
    [sectionDict1 setObject:dict12 forKey:[NSString stringWithFormat:@"r%d",(int)sectionDict1.count]];
    [sectionDict1 setObject:dict13 forKey:[NSString stringWithFormat:@"r%d",(int)sectionDict1.count]];
    [sectionDict1 setObject:dict14 forKey:[NSString stringWithFormat:@"r%d",(int)sectionDict1.count]];
    
    //section = 2
    XEUserInfo *babyUserInfo = [self getBabyUserInfo:0];
    NSMutableDictionary *sectionDict2 = [NSMutableDictionary dictionary];
    intro = [babyUserInfo.babySmallAvatarUrl absoluteString];
    NSDictionary *dict20 = @{@"titleLabel": @"宝宝头像",
                             @"intro": intro!=nil?intro:@"",
                             };
    intro = babyUserInfo.babyNick;
    NSDictionary *dict21 = @{@"titleLabel": @"宝宝昵称",
                             @"intro": intro!=nil?intro:@"2-16个字",
                             };
    intro = @"";
    if ([babyUserInfo.babyGender isEqualToString:@"m"]) {
        intro = @"男宝宝";
    }else if ([babyUserInfo.babyGender isEqualToString:@"f"]){
        intro = @"女宝宝";
    }
    NSDictionary *dict22 = @{@"titleLabel": @"宝宝性别",
                             @"intro": intro!=nil?intro:@"",
                             };
    intro = babyUserInfo.birthdayString;
    NSDictionary *dict23 = @{@"titleLabel": @"出生日期",
                             @"intro": intro!=nil?intro:@"",
                             };
    [sectionDict2 setObject:dict20 forKey:[NSString stringWithFormat:@"r%d",(int)sectionDict2.count]];
    [sectionDict2 setObject:dict21 forKey:[NSString stringWithFormat:@"r%d",(int)sectionDict2.count]];
    [sectionDict2 setObject:dict22 forKey:[NSString stringWithFormat:@"r%d",(int)sectionDict2.count]];
    [sectionDict2 setObject:dict23 forKey:[NSString stringWithFormat:@"r%d",(int)sectionDict2.count]];
    
    //section = 3
    NSMutableDictionary *sectionDict3 = [NSMutableDictionary dictionary];
    intro = _userInfo.dueDateString;
    NSDictionary *dict30 = @{@"titleLabel": @"预产期",
                             @"intro": intro!=nil?intro:@"",
                             };
    intro = _userInfo.hospital;
    NSDictionary *dict31 = @{@"titleLabel": @"产检医院",
                             @"intro": intro!=nil?intro:@"",
                             };
    [sectionDict3 setObject:dict30 forKey:[NSString stringWithFormat:@"r%d",(int)sectionDict3.count]];
    [sectionDict3 setObject:dict31 forKey:[NSString stringWithFormat:@"r%d",(int)sectionDict3.count]];
    
    
    [tmpMutDict setObject:sectionDict0 forKey:[NSString stringWithFormat:@"s%d",(int)tmpMutDict.count]];
    [tmpMutDict setObject:sectionDict1 forKey:[NSString stringWithFormat:@"s%d",(int)tmpMutDict.count]];
    if (self.showType == 2) {
        [tmpMutDict setObject:sectionDict2 forKey:[NSString stringWithFormat:@"s%d",(int)tmpMutDict.count]];
    }else if (self.showType == 1){
        [tmpMutDict setObject:sectionDict3 forKey:[NSString stringWithFormat:@"s%d",(int)tmpMutDict.count]];
    }else if (self.showType == 3){
        [tmpMutDict setObject:sectionDict2 forKey:[NSString stringWithFormat:@"s%d",(int)tmpMutDict.count]];
        [tmpMutDict setObject:sectionDict3 forKey:[NSString stringWithFormat:@"s%d",(int)tmpMutDict.count]];
    }
    
    moduleDict = tmpMutDict;
    return moduleDict;
}

-(NSInteger)newSections{
    
    return [[self tableDataModule] allKeys].count;
}
-(NSInteger)newSectionPolicy:(NSInteger)section{
    
    NSDictionary *rowContentDic = [[self tableDataModule] objectForKey:[NSString stringWithFormat:@"s%d", (int)section]];
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
        return 44;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0 && self.showType != 1) {
            return 61;
        }
    }
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self newSectionPolicy:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MineTabCell";
    MineTabCell *cell;
    cell.introduceImg.hidden = YES;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    cell.introduceImg.hidden = YES;
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.leftAvater.hidden = NO;
            cell.introLabel.hidden = YES;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0 && self.showType != 1) {
            cell.leftAvater.hidden = NO;
            cell.introLabel.hidden = YES;
        }
    }
    
    NSDictionary *cellDicts = [[self tableDataModule] objectForKey:[NSString stringWithFormat:@"s%d", (int)indexPath.section]];
    NSDictionary *rowDicts = [cellDicts objectForKey:[NSString stringWithFormat:@"r%d", (int)indexPath.row]];
    
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
            [cell.leftAvater sd_setImageWithURL:[NSURL URLWithString:[rowDicts objectForKey:@"intro"]] placeholderImage:[UIImage imageNamed:@"topic_avatar_icon"]];
        }
    }
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.titleLabel.frame = CGRectMake(15, 20, 60, 20);
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
    NSDictionary *cellDicts = [[self tableDataModule] objectForKey:[NSString stringWithFormat:@"s%d", (int)indexPath.section]];
    NSDictionary *rowDicts = [cellDicts objectForKey:[NSString stringWithFormat:@"r%d", (int)indexPath.row]];
    
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
            AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [sheet showInView:appDelegate.window];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self editUserInfo:TAG_USER_NAME withRowDicts:rowDicts];
        }else if (indexPath.row == 1){
            _editTag = TAG_USER_IDENTITY;
            __weak PerfectInfoViewController *weakSelf = self;
            XEActionSheet *sheet = [[XEActionSheet alloc] initWithTitle:@"阶段类型" actionBlock:^(NSInteger buttonIndex) {
                if (2 == buttonIndex) {
                    return;
                }
                if (buttonIndex == 0) {
                    weakSelf.userInfo.hasbaby = @"n";
                }else if (buttonIndex == 1){
                    weakSelf.userInfo.hasbaby = @"y";
                }
//                [weakSelf reloadDataWithAnimation];
                [UIView transitionWithView:tableView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    [weakSelf.tableView reloadData];
                } completion:nil];
            } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"怀孕中", @"已有宝宝", nil];
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
        if (self.showType == 1) {
            [self selectUserPregnancyRowAtIndexPath:indexPath rowDicts:rowDicts];
        }else if (self.showType == 2 || self.showType == 3){
            [self selectBabyRowAtIndexPath:indexPath rowDicts:rowDicts];
        }
    }else if (indexPath.section == 3){
        if (self.showType == 3) {
            [self selectUserPregnancyRowAtIndexPath:indexPath rowDicts:rowDicts];
        }
    }
}

-(void)selectBabyRowAtIndexPath:(NSIndexPath *)indexPath rowDicts:(NSDictionary *)rowDicts{
    if (indexPath.row == 0) {
        _editTag = TAG_BOBY_AVATER;
        __weak PerfectInfoViewController *weakSelf = self;
        XEActionSheet *sheet = [[XEActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"设置%@",[rowDicts objectForKey:@"titleLabel"]] actionBlock:^(NSInteger buttonIndex) {
            if (2 == buttonIndex) {
                return;
            }
            
            [weakSelf doActionSheetClickedButtonAtIndex:buttonIndex];
        } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择", @"拍一张", nil];
        AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [sheet showInView:appDelegate.window];
    }else if (indexPath.row == 1) {
        [self editUserInfo:TAG_BOBY_NAME withRowDicts:rowDicts];
    }else if (indexPath.row == 2){
        _editTag = TAG_BOBY_GENDER;
        __weak PerfectInfoViewController *weakSelf = self;
        XEActionSheet *sheet = [[XEActionSheet alloc] initWithTitle:@"宝宝性别" actionBlock:^(NSInteger buttonIndex) {
            if (2 == buttonIndex) {
                return;
            }
            XEUserInfo *babyUserInfo = [self getBabyUserInfo:0];
            if (buttonIndex == 0) {
                babyUserInfo.babyGender = @"m";
            }else if (buttonIndex == 1){
                babyUserInfo.babyGender = @"f";
            }
            [weakSelf.tableView reloadData];
        } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男宝宝", @"女宝宝", nil];
        [sheet showInView:self.view];
    }else if (indexPath.row == 3){
        _editTag = TAG_BOBY_DATE;
        
        SelectBirthdayViewController* selectBirthdayViewController = [[SelectBirthdayViewController alloc] init];
        selectBirthdayViewController.delegate = self;
        XEUserInfo *babyUserInfo = [self getBabyUserInfo:0];
        if (babyUserInfo.birthdayDate) {
            selectBirthdayViewController.oldDate = babyUserInfo.birthdayDate;
        }else{
            selectBirthdayViewController.oldDate = babyUserInfo.birthdayDate;
        }
        [self.navigationController pushViewController:selectBirthdayViewController animated:YES];
    }
}

-(void)selectUserPregnancyRowAtIndexPath:(NSIndexPath *)indexPath rowDicts:(NSDictionary *)rowDicts{
    if (indexPath.row == 0){
        _editTag = TAG_USER_DUEDATE;
        SelectBirthdayViewController* selectBirthdayViewController = [[SelectBirthdayViewController alloc] init];
        selectBirthdayViewController.delegate = self;
        selectBirthdayViewController.oldDate = _userInfo.dueDate;
        selectBirthdayViewController.maximumDateAddYear = 1;
        [self.navigationController pushViewController:selectBirthdayViewController animated:YES];
    }else if (indexPath.row == 1){
        [self editUserInfo:TAG_USER_HOSPITAL withRowDicts:rowDicts];
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
        XEUserInfo *babyUserInfo = [self getBabyUserInfo:0];
        lvc.oldText = babyUserInfo.babyNick;
        lvc.minTextLength = 2;
        lvc.maxTextLength = 16;
    }
    if (Tag == TAG_USER_PHONE) {
        lvc.oldText = _userInfo.phone;
        lvc.minTextLength = 1;
        lvc.maxTextLength = 6;
        lvc.maxTextViewHight = 50.0f;
        lvc.keyboardType = UIKeyboardTypeNumberPad;
    }
    lvc.titleText = [rowDicts objectForKey:@"titleLabel"];
    [self.navigationController pushViewController:lvc animated:YES];
}

#pragma mark -XEInputViewControllerDelegate
- (void)inputViewControllerWithText:(NSString*)text{
    XELog(@"text==%@",text);
    if (_editTag == TAG_USER_NAME) {
        _userInfo.nickName = text;
    }else if (_editTag == TAG_USER_ADDRESS){
        _userInfo.address = text;
    }else if (_editTag == TAG_USER_PHONE){
        [self checkPhone:text];
    }else if (_editTag == TAG_BOBY_NAME){
        XEUserInfo *babyUserInfo = [self getBabyUserInfo:0];
        babyUserInfo.babyNick = text;
    }else if (_editTag == TAG_USER_HOSPITAL) {
        _userInfo.hospital = text;
    }
    [self.tableView reloadData];
}

#pragma mark - SelectBirthdayViewControllerDelegate
- (void)SelectBirthdayWithDate:(NSDate *)date{
    if (_editTag == TAG_USER_DUEDATE) {
        _userInfo.dueDate = date;
        [self.tableView reloadData];
        return;
    }
    XEUserInfo *babyUserInfo = [self getBabyUserInfo:0];
    babyUserInfo.birthdayDate = date;
    [self.tableView reloadData];
    
}

#pragma mark - ChooseLocationDelegate
-(void) didSelectLocation:(NSDictionary *)location
{
    _userInfo.region = [location objectForKey:@"code"];
    _userInfo.regionName = [location objectForKey:@"fullname"];
    
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
        NSData* imageAfterData = UIImageJPEGRepresentation(imageAfterScale, 1);
        float length = [imageAfterData length]/1024;
        CGFloat compressionQuality = XE_IMAGE_COMPRESSION_QUALITY;
        if (length < 70) {
            compressionQuality = 1;
        }
        NSData* imageData = UIImageJPEGRepresentation(imageAfterScale, compressionQuality);
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
    pData.filename = @".png";
    pData.mimeType = @"image/png";
    
    [XEProgressHUD AlertLoading:@"头像上传中..." At:self.view];
    __weak PerfectInfoViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] updateAvatarWithUid:_userInfo.uid avatar:@[pData] tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"上传失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        weakSelf.userInfo.avatar = [jsonRet stringObjectForKey:@"object"];
        [XEProgressHUD AlertSuccess:@"上传成功." At:weakSelf.view];
    }tag:tag];
}

-(void)updateBabyAvatar:(NSData *)data{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    if (data) {
        QHQFormData* pData = [[QHQFormData alloc] init];
        pData.data = data;
        pData.name = @"bbavatar";
        pData.filename = @".png";
        pData.mimeType = @"image/png";
        [dataArray addObject:pData];
    }
    
    [XEProgressHUD AlertLoading:@"头像上传中..." At:self.view];
    __weak PerfectInfoViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] updateBabyAvatarWithBabyUid:nil avatar:dataArray tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//        [XEProgressHUD AlertLoadDone];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"上传失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        [XEProgressHUD AlertSuccess:@"上传成功." At:weakSelf.view];
        XEUserInfo *babyUserInfo = [self getBabyUserInfo:0];
        babyUserInfo.babyAvatarId = [jsonRet stringObjectForKey:@"object"];
        [weakSelf.tableView reloadData];
        
    }tag:tag];
}



#pragma mark - activity
-(void)applyActivity{
    
    _saveButton.enabled = NO;
    [_saveButton setTitle:@"报名中..." forState:0];
    if (_activityInfo.aType == 1) {
        [_saveButton setTitle:@"抢票中..." forState:0];
    }
    __weak PerfectInfoViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] applyActivityWithActivityId:_activityInfo.aId uid:[XEEngine shareInstance].uid type:_activityInfo.aType tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            weakSelf.saveButton.enabled = YES;
            [weakSelf.saveButton setTitle:@"确认报名" forState:0];
            if (_activityInfo.aType == 1) {
                [weakSelf.saveButton setTitle:@"确认抢票" forState:0];
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        weakSelf.saveButton.enabled = NO;
        [weakSelf.saveButton setTitle:@"已报名" forState:0];
        if (_activityInfo.aType == 1) {
            [weakSelf.saveButton setTitle:@"已抢票" forState:0];
        }
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"] At:weakSelf.view];
        weakSelf.activityInfo.status = 3;
        weakSelf.activityInfo.regnum ++;
        
        if (weakSelf.finishedCallBack) {
            weakSelf.finishedCallBack(YES);
        }
        if (_activityInfo.aType == 0) {
            ApplyActivityViewController *applyVc = [[ApplyActivityViewController alloc] init];
            applyVc.infoId = [jsonRet stringObjectForKey:@"object"];
            [weakSelf.navigationController pushViewController:applyVc animated:YES];
        }else if (_activityInfo.aType == 1){
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    }tag:tag];
}
#pragma mark - 卡包
-(void)receiveCard{
    
    _saveButton.enabled = NO;
    [_saveButton setTitle:@"领取中..." forState:0];
    [self.saveButton setBackgroundImage:[UIImage imageNamed:@"card_staus_hover_bg"] forState:UIControlStateNormal];
    __weak PerfectInfoViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] receiveCardWithUid:[XEEngine shareInstance].uid cid:_cardInfo.cid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            weakSelf.saveButton.enabled = YES;
            [weakSelf.saveButton setTitle:@"确认领取" forState:0];
            [weakSelf.saveButton setBackgroundImage:[UIImage imageNamed:@"card_status_bg"] forState:UIControlStateNormal];
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        [weakSelf.saveButton setTitle:@"已领取" forState:UIControlStateNormal];
        weakSelf.saveButton.enabled = NO;
        [weakSelf.saveButton setBackgroundImage:[UIImage imageNamed:@"card_staus_hover_bg"] forState:UIControlStateNormal];
        weakSelf.cardInfo.status = 4;
        weakSelf.cardInfo.leftNum ++;
        
        if (weakSelf.finishedCallBack) {
            weakSelf.finishedCallBack(YES);
        }
        
        ApplyActivityViewController *applyVc = [[ApplyActivityViewController alloc] init];
        applyVc.infoId = [jsonRet stringObjectForKey:@"receiveid"];
        applyVc.vcType = 1;
        [weakSelf.navigationController pushViewController:applyVc animated:YES];
        
    }tag:tag];
}
@end
