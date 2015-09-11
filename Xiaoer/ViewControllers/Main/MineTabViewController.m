//
//  MineTabViewController.m
//  Xiaoer
//
//  Created by KID on 14/12/30.
//
//

#import "MineTabViewController.h"
#import "MineTabCell.h"
#import "XEEngine.h"
#import "UIImageView+WebCache.h"
#import "PerfectInfoViewController.h"
#import "XETabBarViewController.h"
#import "WelcomeViewController.h"
#import "AppDelegate.h"
#import "SettingViewController.h"
#import "CollectionViewController.h"
#import "MineMsgViewController.h"
#import "CardPackViewController.h"
#import "MineActivityListViewController.h"
#import "MineTopicListViewController.h"
#import "XEActionSheet.h"
#import "AVCamUtilities.h"
#import "XEImagePickerController.h"
#import "UIImage+ProportionalFill.h"
#import "QHQnetworkingTool.h"
#import "XEProgressHUD.h"
#import "XENavigationController.h"
#import "StageSelectViewController.h"
#import "XEWebViewWithEvaluationVc.h"
#import "BabyListViewController.h"
#import "OrderViewController.h"
#import "BabyImpressMyPictureController.h"
enum TABLEVIEW_SECTION_INDEX {
    kMyProfile = 0,
    kMyBaby,
    kMyOrder,
    KMyPhoto,
    kMyCard,
    kSectionNumber,
};

@interface MineTabViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) XEUserInfo *userInfo;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIImageView *bkImageView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIImageView *headEdgeview;
@property (strong, nonatomic) IBOutlet UIImageView *ownerHeadImageView;
@property (strong, nonatomic) IBOutlet UIImageView *locationImageView;
@property (strong, nonatomic) IBOutlet UIImageView *ownerbkImageView;


@property (weak, nonatomic) IBOutlet UIButton *nickName;
@property (weak, nonatomic) IBOutlet UIButton *address;
@property (weak, nonatomic) IBOutlet UIButton *birthday;


@property (weak, nonatomic) IBOutlet UIImageView *header_stoneImg;
@property (weak, nonatomic) IBOutlet UILabel *header_stoneLab;
@property (weak, nonatomic) IBOutlet UIImageView *header_loveImg;
@property (weak, nonatomic) IBOutlet UILabel *header_loveLab;


@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;

@property (strong, nonatomic) IBOutlet UIView *visitorHeadView;
@property (strong, nonatomic) IBOutlet UIImageView *visitorImageView;

@property (weak, nonatomic) IBOutlet UIView *headerRound;

- (IBAction)ownerHeadAction:(id)sender;
- (IBAction)setOwnerImageAction:(id)sender;
- (IBAction)editInfoAction:(id)sender;
- (IBAction)loginAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *textBtn;
@end

@implementation MineTabViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self refreshUserInfoShow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.textBtn.imageView.image.size = CGSizeMake(18, 18);
    self.view.backgroundColor = LGrayColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserInfoChanged:) name:XE_USERINFO_CHANGED_NOTIFICATION object:nil];
#warning 此版本暂时隐藏headxer_stone
    self.header_stoneImg.hidden = YES;
    self.header_stoneLab.hidden = YES;
    

    
    self.editBtn.layer.cornerRadius = 18;
    self.editBtn.layer.masksToBounds = YES;
    self.editBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.editBtn.layer.borderWidth = 1;
    
    self.headerRound.layer.cornerRadius = 45;
    self.headerRound.layer.masksToBounds = YES;
    self.headerRound.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headerRound.layer.borderWidth = 2;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    
    [self setRightButtonWithImageName:@"setting_mine_icon" selector:@selector(settingAction)];
    
}

- (UINavigationController *)navigationController{
    if ([super navigationController]) {
        return [super navigationController];
    }
    return self.tabController.navigationController;
}

- (void)settingAction
{
    SettingViewController *sVc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:sVc animated:YES];
}

- (void)handleUserInfoChanged:(NSNotification *)notification{
    [self.tableView reloadData];
}

- (BOOL)isVisitor{
    if (![[XEEngine shareInstance] hasAccoutLoggedin]) {
        return YES;
    }
    return NO;
}

-(XEUserInfo *)getBabyUserInfo:(NSInteger)index{
    _userInfo = [XEEngine shareInstance].userInfo;
    if (_userInfo.babys.count > index) {
        XEUserInfo *babyUserInfo = [_userInfo.babys objectAtIndex:index];
        return babyUserInfo;
    }
    return nil;
}

- (void)refreshUserInfoShow
{
    if ([self isVisitor]) {
        [self setTitle:@"未登录"];
        self.visitorImageView.layer.cornerRadius = 8;
        self.tableView.tableHeaderView = self.headView;
        self.ownerHeadImageView.image = [UIImage imageNamed:@"header_avatarHold"];
        [self.nickName setTitle:@"未设置" forState:UIControlStateNormal];
        [self.birthday setTitle:@"未设置" forState:UIControlStateNormal];
        [self.address setTitle:@"未绑定手机" forState:UIControlStateNormal];
        [self.editBtn setTitle:@"请登录" forState:UIControlStateNormal];
        self.header_loveLab.text = @"0";
        [self.editBtn setBackgroundColor:SKIN_COLOR ];

    }else{
        XEUserInfo *userInfo = [self getBabyUserInfo:0];
        if (_userInfo.nickName.length > 0) {
            [self setTitle:_userInfo.nickName];
        }else{
            [self setTitle:@"我的"];
        }
        self.loginBtn.hidden = YES;

//        self.ownerbkImageView.clipsToBounds = YES;
//        self.ownerbkImageView.contentMode = UIViewContentModeScaleAspectFill;

        self.ownerbkImageView.clipsToBounds = YES;
        self.ownerbkImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.ownerHeadImageView sd_setImageWithURL:_userInfo.smallAvatarUrl placeholderImage:[UIImage imageNamed:@"header_avatarHold"]];
        self.ownerHeadImageView.layer.cornerRadius = 8;
        NSString *babyNick = userInfo.babyNick;
        if (babyNick.length == 0) {
            babyNick = @"未设置";
        }
        [self.nickName setTitle:babyNick forState:UIControlStateNormal];

        if ([XEUIUtils dateDiscription1FromNowBk: userInfo.birthdayDate].length  > 0 ) {
            [self.birthday setTitle:[XEUIUtils dateDiscription1FromNowBk: userInfo.birthdayDate] forState:UIControlStateNormal];
        }else{
            
            [self.birthday setTitle:@"未设置" forState:UIControlStateNormal];
        }
        
        NSLog(@"userInfo.bphone === %@",[XEEngine shareInstance].userInfo.bphone);
        if (![XEEngine shareInstance].userInfo.bphone) {
            [self.address setTitle:@"未绑定手机" forState:UIControlStateNormal];
        }else{
            
            [self.address setTitle:[NSString stringWithFormat:@"已绑定手机：%@",[XEEngine shareInstance].userInfo.bphone] forState:UIControlStateNormal];

        }

        if (_userInfo.lovePoint) {
            self.header_loveLab.text = _userInfo.lovePoint;
        }else{
            self.header_loveLab.text = @"0";
        }

        [self.editBtn setBackgroundColor:[UIColor lightGrayColor]];
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];

        self.tableView.tableHeaderView = self.headView;
    }
    
    ///底部加点间隙
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 19)];
    footer.userInteractionEnabled = NO;
    footer.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footer;
//    [self.ownerHeadImageView sd_setImageWithURL:_userInfo.mediumAvatarUrl placeholderImage:[UIImage imageNamed:@"placeholder_avatar_icon"]];
//    if (_userInfo.backgroudImageUrl) {
//        [self.ownerbkImageView sd_setImageWithURL:_userInfo.largeAvatarUrl placeholderImage:[UIImage imageNamed:@"placeholder_avatar_bg"]];
//    }else{
//        [self.ownerbkImageView setImage:[UIImage imageNamed:@"placeholder_avatar_bg"]];
//    }
    [self.tableView reloadData];
}

#pragma mark - Scroll view
static CGFloat beginOffsetY = 190;
static CGFloat BKImageHeight = 320;
static CGFloat beginImageH = 64;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    CGPoint offset = scrollView.contentOffset;
////    XELog(@"offset = %f",offset.y);
//    CGRect frame = CGRectMake(0, -63, SCREEN_WIDTH, BKImageHeight);
//    CGFloat factor;
//    
//    //pull animation
//    if (offset.y < 0) {
//        factor = 0.5;
//    } else {
//        factor = 1;
//    }
//    
//    float topOffset = -63;
//    frame.origin.y = topOffset-offset.y*factor;
//    if (frame.origin.y > 0) {
//        frame.origin.y =  topOffset/factor - offset.y;
//    }
//    
//    // zoom image
//    if (offset.y <= -beginOffsetY) {
//        factor = (ABS(offset.y+beginOffsetY)+BKImageHeight) * SCREEN_WIDTH/BKImageHeight;
//        frame = CGRectMake(-(factor-SCREEN_WIDTH)/2, beginImageH, factor, BKImageHeight+ABS(offset.y+beginOffsetY));
//    }
//    _ownerbkImageView.frame = frame;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return kSectionNumber;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == kMyProfile) {
        return 4;
    }

    else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return SINGLE_HEADER_HEADER;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SINGLE_HEADER_HEADER)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MineTabCell";
    MineTabCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    
//    cell.badgeLab.backgroundColor = SKIN_COLOR;
//    cell.badgeLab.layer.cornerRadius = 10;
//    cell.badgeLab.layer.masksToBounds = YES;
//    cell.badgeLab.text = @"2";
    switch (indexPath.section) {
        case kMyProfile:{

            if (indexPath.row == 0) {
                cell.titleLabel.text = @"我的消息";
                [cell.avatarImageView setImage:[UIImage imageNamed:@"mine_msg_icon"]];
                break;
            }else if (indexPath.row == 1){
                cell.titleLabel.text = @"我的活动";
                [cell.avatarImageView setImage:[UIImage imageNamed:@"mine_activity_icon"]];
                break;
            }else if (indexPath.row == 2){
                cell.titleLabel.text = @"我的收藏";
                [cell.avatarImageView setImage:[UIImage imageNamed:@"mine_collection_icon"]];
                break;
            }else if (indexPath.row == 3){
                cell.titleLabel.text = @"我的话题";
                [cell.avatarImageView setImage:[UIImage imageNamed:@"mine_topic_icon"]];
                break;
            }
        }
            
        case kMyBaby:{
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"我的宝宝";
                [cell.avatarImageView setImage:[UIImage imageNamed:@"mine_baby_icon"]];
                break;
            }
        }
            
        case kMyOrder:{
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"我的订单";
                [cell.avatarImageView setImage:[UIImage imageNamed:@"mine_order_icon"]];
                break;
            }
        }
            
        case KMyPhoto:{
            cell.titleLabel.text = @"我的照片";
            [cell.avatarImageView setImage:[UIImage imageNamed:@"mine_photo_icon"]];
            break;
        }
            
        case kMyCard:{
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"我的卡包";
                [cell.avatarImageView setImage:[UIImage imageNamed:@"mine_card_icon"]];
                break;
            }
        }

        default:
            break;
    }
    if (indexPath.row == 0) {
        cell.topline.hidden = NO;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section is %ld",(long)indexPath.row);
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
    switch (indexPath.section) {
        case kMyProfile:{
            if (indexPath.row == 0) {
                MineMsgViewController *mVc = [[MineMsgViewController alloc] init];
                [self.navigationController pushViewController:mVc animated:YES];
                break;
            }else if (indexPath.row == 1){
                if ([[XEEngine shareInstance] needUserLogin:nil]) {
                    return;
                }
                MineActivityListViewController *mVc = [[MineActivityListViewController alloc] init];
                [self.navigationController pushViewController:mVc animated:YES];
                break;
            }else if (indexPath.row == 2){
                if ([[XEEngine shareInstance] needUserLogin:nil]) {
                    return;
                }
                CollectionViewController *cVc = [[CollectionViewController alloc] init];
                [self.navigationController pushViewController:cVc animated:YES];
                break;
            }else if (indexPath.row == 3){
                if ([[XEEngine shareInstance] needUserLogin:nil]) {
                    return;
                }
                MineTopicListViewController *mVc = [[MineTopicListViewController alloc] init];
                [self.navigationController pushViewController:mVc animated:YES];
                break;
            }
            break;
            
        }
            
            
        case kMyBaby:{
            if (indexPath.row == 0) {
                if ([[XEEngine shareInstance] needUserLogin:nil]) {
                    return;
                }
                BabyListViewController *vc = [[BabyListViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            //            if (indexPath.row == 0) {
            //                [[XEEngine shareInstance] logout];
            //                WelcomeViewController *weVc = [[WelcomeViewController alloc] init];
            //                [self.navigationController pushViewController:weVc animated:YES];
            //                break;
            //            }else if (indexPath.row == 1){
            //                [self onLogoutWithError:nil];
            //                break;
            //            }
            //            //暂时放下
        }
        
        case kMyOrder:{
            if ([[XEEngine shareInstance] needUserLogin:nil]) {
                return;
            }
            OrderViewController *order = [[OrderViewController alloc]init];
            [self.navigationController pushViewController:order animated:YES];
            break;
        }
        



        case KMyPhoto:{
            BabyImpressMyPictureController *myPicture = [[BabyImpressMyPictureController alloc]init];

            if ([[XEEngine shareInstance] needUserLogin:nil]) {
                return;
            }
            [self.navigationController pushViewController:myPicture animated:YES];

            break;
        }
        case kMyCard:{
            
            if (indexPath.row == 0) {
                if ([[XEEngine shareInstance] needUserLogin:nil]) {
                    return;
                }
                CardPackViewController *cpVc = [[CardPackViewController alloc] init];
                [self.navigationController pushViewController:cpVc animated:YES];
                break;
            }
            //            else if (indexPath.row == 1){
            //                NSLog(@"============历史测评");
            //                if ([[XEEngine shareInstance] needUserLogin:nil]) {
            //                    return;
            //                }
            //                StageSelectViewController *cpVc = [[StageSelectViewController alloc] init];
            //                [self.navigationController pushViewController:cpVc animated:YES];
            //                break;
            //            }
        }
            
        default:
            break;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)ownerHeadAction:(id)sender {
    NSLog(@"===========%s",__func__);
}

- (IBAction)setOwnerImageAction:(id)sender {
    __weak MineTabViewController *weakSelf = self;
    XEActionSheet *sheet = [[XEActionSheet alloc] initWithTitle:@"设置主页背景" actionBlock:^(NSInteger buttonIndex) {
        if (2 == buttonIndex) {
            return;
        }
        
        [weakSelf doActionSheetClickedButtonAtIndex:buttonIndex];
    } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择", @"拍一张", nil];
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [sheet showInView:appDelegate.window];
}

- (IBAction)editInfoAction:(id)sender {
    if ([[XEEngine shareInstance] needUserLogin:nil]) {
        return;
    }
    PerfectInfoViewController *piVc = [[PerfectInfoViewController alloc] init];
    piVc.userInfo = _userInfo;
    [self.navigationController pushViewController:piVc animated:YES];
}

- (IBAction)loginAction:(id)sender {
    WelcomeViewController *welcomeVc = [[WelcomeViewController alloc] init];
    welcomeVc.showBackButton = YES;
    XENavigationController* navigationController = [[XENavigationController alloc] initWithRootViewController:welcomeVc];
    navigationController.navigationBarHidden = YES;
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (void)onLogoutWithError:(NSError *)error {
    if ([XEEngine shareInstance].serverPlatform == TestPlatform) {
        [XEEngine shareInstance].serverPlatform = OnlinePlatform;
    } else {
        [XEEngine shareInstance].serverPlatform = TestPlatform;
    }
    AppDelegate * appDelgate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSLog(@"signOut for user logout");
    [appDelgate signOut];
    
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
    [self.navigationController presentViewController:picker animated:YES completion:NULL];//用self.navigationController弹出 相机 StatusBar才会隐藏
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
        
        [self updateMineBg:imageData];
        [self.tableView reloadData];
    }
    [picker dismissModalViewControllerAnimated:YES];
    //    [LSCommonUtils saveImageToAlbum:picker Img:image];
    
}

-(void)updateMineBg:(NSData *)data{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    if (data) {
        QHQFormData* pData = [[QHQFormData alloc] init];
        pData.data = data;
        pData.name = @"bgimg";
        pData.filename = @".png";
        pData.mimeType = @"image/png";
        [dataArray addObject:pData];
    }
    
    [XEProgressHUD AlertLoading:@"封面上传中..." At:self.view];
    __weak MineTabViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] updateBgImgWithUid:[XEEngine shareInstance].uid avatar:dataArray tag:tag];
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
        NSString *imgId = [jsonRet stringObjectForKey:@"object"];
        _userInfo.bgImgId = imgId;
        NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:_userInfo.userInfoByJsonDic];
        [userDic setObject:imgId forKey:@"bgImg"];
        [_userInfo setUserInfoByJsonDic:userDic];
        [XEEngine shareInstance].userInfo = _userInfo;
        [weakSelf refreshUserInfoShow];
        [weakSelf.tableView reloadData];
        
        [[XEEngine shareInstance] refreshUserInfo];
        
    }tag:tag];
}

@end
