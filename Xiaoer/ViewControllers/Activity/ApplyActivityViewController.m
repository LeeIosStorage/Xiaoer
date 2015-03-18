//
//  ApplyActivityViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/19.
//
//

#import "ApplyActivityViewController.h"
#import "MineTabCell.h"
#import "XEUserInfo.h"
#import "XEEngine.h"
#import "XEActionSheet.h"
#import "ChooseLocationViewController.h"
#import "XEInputViewController.h"
#import "XEProgressHUD.h"
#import "ActivityDetailsViewController.h"
#import "CardDetailViewController.h"
#import "CardPackViewController.h"
#import "TicketListViewController.h"

#define TAG_USER_NAME      0
#define TAG_USER_IDENTITY  1
#define TAG_BOBY_DATE      2
#define TAG_USER_PHONE     3
#define TAG_USER_REGION    4
#define TAG_USER_ADDRESS   5


@interface ApplyActivityViewController ()<UITableViewDataSource,UITableViewDelegate,ChooseLocationDelegate,XEInputViewControllerDelegate>
{
    int _editTag;
    XEUserInfo *_oldUserInfo;
    NSString *_babyAgeOfMoon;
    
    NSString *_userNickName;
}
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *placeHolderLabel;

@end

@implementation ApplyActivityViewController

- (void)dealloc{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = UIColorRGB(240, 240, 240);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self setTilteLeftViewHide:YES];
    self.disablePan = YES;
    
    XEUserInfo* tmpUserInfo = [XEEngine shareInstance].userInfo;
    _oldUserInfo = [[XEUserInfo alloc] init];
    [_oldUserInfo setUserInfoByJsonDic:tmpUserInfo.userInfoByJsonDic];
    
    [self refreshHeadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initNormalTitleNavBarSubviews{
    
    [self setTitle:@"报名成功"];
    if (_vcType == 1) {
        [self setTitle:@"领取成功"];
    }
    [self setRightButtonWithTitle:@"完成" selector:@selector(submitAction:)];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSDictionary *)tableDataModule{
    NSDictionary *moduleDict;
    NSMutableDictionary *tmpMutDict = [NSMutableDictionary dictionary];
    
    
    //section = 0
    NSMutableDictionary *sectionDict0 = [NSMutableDictionary dictionary];
    
    NSString *intro = _userNickName;
    NSDictionary *dict10 = @{@"titleLabel": @"称呼",
                             @"intro": intro!=nil?intro:@"先生/女士",
                             };
    
//    intro = _oldUserInfo.title;
//    if ([_oldUserInfo.title isEqualToString:@"f"]) {
//        intro = @"妈妈";
//    }else if ([_oldUserInfo.title isEqualToString:@"m"]){
//        intro = @"爸爸";
//    }else if ([_oldUserInfo.title isEqualToString:@"o"]){
//        intro = @"其他";
//    }
//    NSDictionary *dict11 = @{@"titleLabel": @"身份",
//                             @"intro": intro!=nil?intro:@"",
//                             };
//    
//    intro =_babyAgeOfMoon;
//    NSDictionary *dict12 = @{@"titleLabel": @"宝宝月龄",
//                             @"intro": intro!=nil?intro:@"",
//                             };
//    
//    intro = _oldUserInfo.phone;
//    NSDictionary *dict13 = @{@"titleLabel": @"常用电话",
//                             @"intro": intro!=nil?intro:@"",
//                             };
//    
//    intro = _oldUserInfo.regionName;
//    NSDictionary *dict14 = @{@"titleLabel": @"所在区域",
//                             @"intro": intro!=nil?intro:@"",
//                             };
//    intro = _oldUserInfo.address;
//    NSDictionary *dict15 = @{@"titleLabel": @"详细街道",
//                             @"intro": intro!=nil?intro:@"",
//                             };
    
    [sectionDict0 setObject:dict10 forKey:[NSString stringWithFormat:@"r%d",(unsigned int)sectionDict0.count]];
//    [sectionDict0 setObject:dict11 forKey:[NSString stringWithFormat:@"r%d",(unsigned int)sectionDict0.count]];
//    [sectionDict0 setObject:dict12 forKey:[NSString stringWithFormat:@"r%d",(unsigned int)sectionDict0.count]];
//    [sectionDict0 setObject:dict13 forKey:[NSString stringWithFormat:@"r%d",(unsigned int)sectionDict0.count]];
//    [sectionDict0 setObject:dict14 forKey:[NSString stringWithFormat:@"r%d",(unsigned int)sectionDict0.count]];
//    [sectionDict0 setObject:dict15 forKey:[NSString stringWithFormat:@"r%d",(unsigned int)sectionDict0.count]];
    
    [tmpMutDict setObject:sectionDict0 forKey:[NSString stringWithFormat:@"s%d",(unsigned int)tmpMutDict.count]];
    moduleDict = tmpMutDict;
    return moduleDict;
}

#pragma mark - custom
-(void)refreshHeadView{
    
    _titleLabel.text = @"恭喜，您已报名成功！请输入以下信息，方便我们联系和发放奖品.";
    if (_vcType == 1){
        _titleLabel.text = @"恭喜，您已领取成功！请输入以下信息，方便我们联系和发放奖品.";
    }
    self.tableView.tableHeaderView = self.headView;
    self.tableView.tableFooterView = self.footerView;
    
    [self.tableView reloadData];
}
-(void)submitAction:(id)sender{
    
    if ([XEEngine shareInstance].uid.length == 0) {
        return;
    }
    if (_userNickName.length == 0) {
        [XEProgressHUD lightAlert:@"称呼必填哦"];
        return;
    }
//    if (_oldUserInfo.title.length == 0) {
//        [XEProgressHUD lightAlert:@"身份必填哦"];
//        return;
//    }
//    if (_oldUserInfo.stage == 0) {
//        [XEProgressHUD lightAlert:@"宝宝月龄必填哦"];
//        return;
//    }
//    if (_oldUserInfo.phone.length == 0) {
//        [XEProgressHUD lightAlert:@"常用电话必填哦"];
//        return;
//    }
//    if (_oldUserInfo.region.length == 0) {
//        [XEProgressHUD lightAlert:@"所在地区必填哦"];
//        return;
//    }
//    if (_oldUserInfo.address.length == 0) {
//        [XEProgressHUD lightAlert:@"详细街道必填哦"];
//        return;
//    }
    [XEProgressHUD AlertLoading:@"正在提交信息" At:self.view];
    if (_vcType == 0) {
        [self submitActivityInfo];
    }else if (_vcType == 1){
        [self submitCardInfo];
    }
}

-(void)submitActivityInfo{
    __weak ApplyActivityViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] applyActivityAddInfoWithActivityId:_infoId name:_userNickName remark:_textView.text tag:tag];
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
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"] At:weakSelf.view];
        [weakSelf performSelector:@selector(popViewController) withObject:nil afterDelay:1.0];
        
    }tag:tag];
}

-(void)submitCardInfo{
    __weak ApplyActivityViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] receiveCardAddInfoWithInfoId:_infoId name:_userNickName remark:_textView.text tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"] At:weakSelf.view];
        [weakSelf performSelector:@selector(popViewController) withObject:nil afterDelay:1.0];
        
    }tag:tag];
}

-(void)popViewController{
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 2) {
        UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
        if ([vc isKindOfClass:[ActivityDetailsViewController class]] || [vc isKindOfClass:[CardDetailViewController class]] || [vc isKindOfClass:[CardPackViewController class]] || [vc isKindOfClass:[TicketListViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateRemainNumLabel{
    if (_textView.text.length > 0) {
        _placeHolderLabel.hidden = YES;
    }else{
        _placeHolderLabel.hidden = NO;
    }
}

-(void) keyboardWillShow:(NSNotification *)note{
    
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
//    CGRect containerFrame = _toolbarContainerView.frame;
//    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    CGRect tableViewFrame = _tableView.frame;
    tableViewFrame.size.height = self.view.bounds.size.height - keyboardBounds.size.height;
    _tableView.frame = tableViewFrame;
    
    CGPoint offset = _tableView.contentOffset;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    offset = CGPointMake(0, _tableView.contentSize.height -  _tableView.frame.size.height);
    _tableView.contentOffset = offset;
    // commit animations
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect tableViewFrame = _tableView.frame;
    tableViewFrame.size.height = self.view.bounds.size.height;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    _tableView.frame = tableViewFrame;
    // commit animations
    [UIView commitAnimations];
}

#pragma mark - UITextViewDelegate
static int _maxTextLength = 200;
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (text.length == 0) {
        return YES;
    }
    int newLength = [XECommonUtils getHanziTextNum:[textView.text stringByAppendingString:text]];
    if(newLength >= _maxTextLength && textView.markedTextRange == nil) {
        _textView.text = [XECommonUtils getHanziTextWithText:[textView.text stringByReplacingCharactersInRange:range withString:text] maxLength:_maxTextLength];
        return NO;
    }
    
    [textView scrollRangeToVisible:range];
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
//    if (textView.markedTextRange != nil) {
//        return;
//    }
    
    if ([XECommonUtils getHanziTextNum:textView.text] > _maxTextLength && textView.markedTextRange == nil) {
        textView.text = [XECommonUtils getHanziTextWithText:textView.text maxLength:_maxTextLength];
    }
    [self updateRemainNumLabel];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self tableDataModule].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *rowContentDic = [[self tableDataModule] objectForKey:[NSString stringWithFormat:@"s%d", (int)section]];
    return [rowContentDic count];
}
static int redIconImageView_tag = 201;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MineTabCell";
    MineTabCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        UIImageView *redIconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"s_n_round_red"]];
        redIconImgView.frame = CGRectMake(0, 0, 6, 6);
        redIconImgView.tag = redIconImageView_tag;
        [cell addSubview:redIconImgView];
    }
    CGRect frame = cell.titleLabel.frame;
    frame.origin.x = 13;
    cell.titleLabel.frame = frame;
    
    cell.introLabel.hidden = NO;
    cell.introLabel.textColor = UIColorToRGB(0x1ba7d8);
    
    NSDictionary *cellDicts = [[self tableDataModule] objectForKey:[NSString stringWithFormat:@"s%d", (int)indexPath.section]];
    NSDictionary *rowDicts = [cellDicts objectForKey:[NSString stringWithFormat:@"r%d", (int)indexPath.row]];
    cell.titleLabel.text = [rowDicts objectForKey:@"titleLabel"];
    
    if (!cell.introLabel.hidden) {
        cell.introLabel.text = [rowDicts objectForKey:@"intro"];
    }
    
    UIImageView *redIconImgView = (UIImageView *)[cell viewWithTag:redIconImageView_tag];
    float titleLabelWidth = [XECommonUtils widthWithText:[rowDicts objectForKey:@"titleLabel"] font:self.titleLabel.font lineBreakMode:self.titleLabel.lineBreakMode];
    frame = redIconImgView.frame;
    frame.origin.x = self.titleLabel.frame.origin.x + titleLabelWidth;
    frame.origin.y = (cell.frame.size.height-frame.size.height)/2;
    redIconImgView.frame = frame;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
    NSDictionary *cellDicts = [[self tableDataModule] objectForKey:[NSString stringWithFormat:@"s%d", (int)indexPath.section]];
    NSDictionary *rowDicts = [cellDicts objectForKey:[NSString stringWithFormat:@"r%d", (int)indexPath.row]];
    if (indexPath.row == 0) {
        [self editUserInfo:TAG_USER_NAME withRowDicts:rowDicts];
    }else if (indexPath.row == 1) {
        _editTag = TAG_USER_IDENTITY;
        __weak ApplyActivityViewController *weakSelf = self;
        XEActionSheet *sheet = [[XEActionSheet alloc] initWithTitle:@"选择身份" actionBlock:^(NSInteger buttonIndex) {
            if (3 == buttonIndex) {
                return;
            }
            if (buttonIndex == 0) {
                _oldUserInfo.title = @"f";
            }else if (buttonIndex == 1){
                _oldUserInfo.title = @"m";
            }else if (buttonIndex == 2){
                _oldUserInfo.title = @"o";
            }
            [weakSelf.tableView reloadData];
        } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"我是妈妈", @"我是爸爸",@"其他", nil];
        [sheet showInView:self.view];
    }else if (indexPath.row == 2){
        _editTag = TAG_BOBY_DATE;
        __weak ApplyActivityViewController *weakSelf = self;
        XEActionSheet *sheet = [[XEActionSheet alloc] initWithTitle:@"宝宝月龄" actionBlock:^(NSInteger buttonIndex) {
            if (5 == buttonIndex) {
                return;
            }
            if (buttonIndex == 0) {
                _babyAgeOfMoon = @"0-4周";
                _oldUserInfo.stage = 1;
            }else if (buttonIndex == 1){
                _babyAgeOfMoon = @"4-16周";
                _oldUserInfo.stage = 2;
            }else if (buttonIndex == 2){
                _babyAgeOfMoon = @"16-28周";
                _oldUserInfo.stage = 3;
            }else if (buttonIndex == 3){
                _babyAgeOfMoon = @"28-40周";
                _oldUserInfo.stage = 4;
            }else if (buttonIndex == 4){
                _babyAgeOfMoon = @"40-52周";
                _oldUserInfo.stage = 5;
            }else if (buttonIndex == 5){
                _babyAgeOfMoon = @"12-18月";
                _oldUserInfo.stage = 6;
            }else if (buttonIndex == 6){
                _babyAgeOfMoon = @"18-24月";
                _oldUserInfo.stage = 7;
            }else if (buttonIndex == 7){
                _babyAgeOfMoon = @"24-36月";
                _oldUserInfo.stage = 8;
            }
            [weakSelf.tableView reloadData];
        } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"0-4周", @"4-16周",@"16-28周",@"28-40周",@"40-52周",@"12-18月",@"18-24月",@"24-36月", nil];
        [sheet showInView:self.view];
        
    }else if (indexPath.row == 3){
        [self editUserInfo:TAG_USER_PHONE withRowDicts:rowDicts];
    }else if (indexPath.row == 4){
        _editTag = TAG_USER_REGION;
        ChooseLocationViewController *chooseLocationVc=[[ChooseLocationViewController alloc] initWithLoactionType:ChooseLoactionTypeProvince WithCode:nil];
        chooseLocationVc.delegate = self;
        [self.navigationController pushViewController:chooseLocationVc animated:YES];
        
    }else if (indexPath.row == 5){
        [self editUserInfo:TAG_USER_ADDRESS withRowDicts:rowDicts];
    }
}

-(void)editUserInfo:(int)Tag withRowDicts:(NSDictionary *)rowDicts{
    
    _editTag = Tag;
    XEInputViewController *lvc = [[XEInputViewController alloc] init];
    lvc.delegate = self;
    lvc.oldText = [rowDicts objectForKey:@"intro"];
    if (Tag == TAG_USER_NAME) {
        lvc.oldText = _userNickName;
//        lvc.minTextLength = 2;
        lvc.maxTextLength = 16;
    }
    if (Tag == TAG_USER_PHONE) {
        lvc.oldText = _oldUserInfo.phone;
        lvc.minTextLength = 1;
        lvc.maxTextLength = 6;
        lvc.maxTextViewHight = 50.0f;
        lvc.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (Tag == TAG_USER_ADDRESS) {
        lvc.maxTextLength = 100;
    }
    lvc.titleText = [rowDicts objectForKey:@"titleLabel"];
    [self.navigationController pushViewController:lvc animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }
}

#pragma mark -XEInputViewControllerDelegate
- (void)inputViewControllerWithText:(NSString*)text{
    if (_editTag == TAG_USER_ADDRESS){
        _oldUserInfo.address = text;
    }else if (_editTag == TAG_USER_PHONE){
        _oldUserInfo.phone = text;
    }else if (_editTag == TAG_USER_NAME){
        _userNickName = text;
    }
    [self.tableView reloadData];
}

#pragma mark - ChooseLocationDelegate
-(void) didSelectLocation:(NSDictionary *)location
{
    _oldUserInfo.region = [location objectForKey:@"code"];
    _oldUserInfo.regionName = [location objectForKey:@"fullname"];
    
    [self.tableView reloadData];
}

@end
