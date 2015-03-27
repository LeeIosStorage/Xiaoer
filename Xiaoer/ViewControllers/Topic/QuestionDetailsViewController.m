//
//  QuestionDetailsViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/29.
//
//

#import "QuestionDetailsViewController.h"
#import "GMGridViewLayoutStrategies.h"
#import "GMGridViewCell+Extended.h"
#import "UIImageView+WebCache.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XECommentInfo.h"
#import "MWPhotoBrowser.h"
#import "XEShareActionSheet.h"
#import "ExpertIntroViewController.h"

#define ANSWER_ONE_IMAGE_HEIGHT  93
#define QUESTION_ONE_IMAGE_HEIGHT  66
#define item_spacing  4

@interface QuestionDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,GMGridViewDataSource, GMGridViewActionDelegate,MWPhotoBrowserDelegate,XEShareActionSheetDelegate>
{
    BOOL _isLookExpertPhotoBrowser;
    XEShareActionSheet *_shareAction;
}

@property (nonatomic, strong) XECommentInfo *expertComment;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UILabel *answerTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *answerContentContainerView;
@property (strong, nonatomic) IBOutlet UIImageView *answerAvatarImgView;
@property (strong, nonatomic) IBOutlet UILabel *answerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *answerHospitalLabel;
@property (strong, nonatomic) IBOutlet UILabel *answerTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *answerContentLabel;
@property (strong, nonatomic) IBOutlet GMGridView *answerImageGridView;

@property (strong, nonatomic) IBOutlet UIView *questionContentContainerView;
@property (strong, nonatomic) IBOutlet UILabel *questionTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *questionNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *questionContentLabel;
@property (strong, nonatomic) IBOutlet GMGridView *questionImageGridView;
@property (strong, nonatomic) IBOutlet UILabel *questionTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *expertCommentBgImgView;

- (IBAction)expertAvatarAction:(id)sender;
@end

@implementation QuestionDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _answerImageGridView.style = GMGridViewStyleSwap;
    _answerImageGridView.itemSpacing = item_spacing;
    _answerImageGridView.minEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _answerImageGridView.centerGrid = NO;
    _answerImageGridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutVertical];
    _answerImageGridView.actionDelegate = self;
    _answerImageGridView.showsHorizontalScrollIndicator = NO;
    _answerImageGridView.showsVerticalScrollIndicator = NO;
    _answerImageGridView.dataSource = self;
    _answerImageGridView.scrollsToTop = NO;
    _answerImageGridView.delegate = self;
    
    
    _questionImageGridView.style = GMGridViewStyleSwap;
    _questionImageGridView.itemSpacing = item_spacing;
    _questionImageGridView.minEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _questionImageGridView.centerGrid = NO;
    _questionImageGridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutVertical];
    _questionImageGridView.actionDelegate = self;
    _questionImageGridView.showsHorizontalScrollIndicator = NO;
    _questionImageGridView.showsVerticalScrollIndicator = NO;
    _questionImageGridView.dataSource = self;
    _questionImageGridView.scrollsToTop = NO;
    _questionImageGridView.delegate = self;
    
    [self refreshQuestionInfoShow];
    
    [self getCacheQuestionInfo];//cache
    [self refreshQuestionInfo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    
    [self setTitle:@"问答详情"];
    [self setRightButtonWithImageName:@"more_icon" selector:@selector(moreAction:)];
    [self.titleNavBarRightBtn setHidden:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)getCacheQuestionInfo{
    __weak QuestionDetailsViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getQuestionDetailsWithQuestionId:_questionInfo.sId uid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            NSDictionary *questionDic = [jsonRet dictionaryObjectForKey:@"question"];
            weakSelf.questionInfo = [[XEQuestionInfo alloc] init];
            [weakSelf.questionInfo setQuestionInfoByJsonDic:questionDic];
            
            NSDictionary *exComment = [jsonRet dictionaryObjectForKey:@"answer"];
            if (exComment) {
                weakSelf.expertComment = [[XECommentInfo alloc] init];
                [weakSelf.expertComment setCommentInfoByJsonDic:exComment];
            }
            
            [weakSelf refreshQuestionInfoShow];
            [weakSelf.tableView reloadData];
        }
    }];
}

-(void)refreshQuestionInfo{
    
    __weak QuestionDetailsViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getQuestionDetailsWithQuestionId:_questionInfo.sId uid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
//        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
        
        NSDictionary *questionDic = [jsonRet objectForKey:@"question"];
        weakSelf.questionInfo = [[XEQuestionInfo alloc] init];
        [weakSelf.questionInfo setQuestionInfoByJsonDic:questionDic];
        
        
        
        NSDictionary *exComment = [jsonRet objectForKey:@"answer"];
        if (exComment) {
            weakSelf.expertComment = [[XECommentInfo alloc] init];
            [weakSelf.expertComment setCommentInfoByJsonDic:exComment];
        }
        
        [weakSelf refreshQuestionInfoShow];
        [weakSelf.tableView reloadData];
        
    }tag:tag];
}

#pragma mark - custom
-(void)refreshQuestionInfoShow{
    
    if (!_questionInfo.uId || (_questionInfo.uId && ![_questionInfo.uId isEqualToString:[XEEngine shareInstance].uid])) {
        [self.titleNavBarRightBtn setHidden:YES];
    }else{
        [self.titleNavBarRightBtn setHidden:NO];
    }
    
    self.answerAvatarImgView.layer.cornerRadius = self.answerAvatarImgView.frame.size.width/2;
    self.answerAvatarImgView.layer.masksToBounds = YES;
    self.answerAvatarImgView.clipsToBounds = YES;
    self.answerAvatarImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.expertCommentBgImgView.image = [[UIImage imageNamed:@"ask_question_background"] stretchableImageWithLeftCapWidth:60 topCapHeight:30];
    
    [self.answerAvatarImgView sd_setImageWithURL:_expertComment.smallAvatarUrl placeholderImage:[UIImage imageNamed:@"topic_avatar_icon"]];
    self.answerNameLabel.text = _expertComment.userName;
    self.answerHospitalLabel.text = _expertComment.title;
    self.answerTimeLabel.text = [XEUIUtils dateDiscriptionFromNowBk:_expertComment.time];
    
//    self.titleLabel.text = _topicInfo.title;
//    CGSize textSize = [XECommonUtils sizeWithText:_topicInfo.title font:self.titleLabel.font width:SCREEN_WIDTH-13*2];
//    CGRect frame = self.titleContainerView.frame;
//    frame.size.height = (textSize.height + 5 + 5);
//    self.titleContainerView.frame = frame;
    
    //expertAnswer view
    self.answerTitleLabel.text = @"专家未答复：";
    if (_questionInfo.status == 1) {
        self.answerTitleLabel.text = @"专家未答复";
    }else if (_questionInfo.status == 2){
        self.answerTitleLabel.text = @"专家答复：";
    }else if (_questionInfo.status == 3){
        self.answerTitleLabel.text = @"问题被驳回";
    }
    self.answerContentLabel.text = _expertComment.content;
    self.answerContentLabel.hidden = NO;
    if (_expertComment.content.length == 0 || _questionInfo.status != 2) {
        self.answerContentLabel.hidden = YES;
    }
    CGSize textSize = [XECommonUtils sizeWithText:_expertComment.content font:self.answerContentLabel.font width:SCREEN_WIDTH-13*2];
    CGRect frame = self.answerContentLabel.frame;
    frame.size.height = textSize.height;
    self.answerContentLabel.frame = frame;
    
    //图片view
    NSInteger imagesCount = self.expertComment.picIds.count;
    if (imagesCount > 0) {
        self.answerImageGridView.hidden = NO;
        CGRect gridFrame = self.answerImageGridView.frame;
        gridFrame.origin.y = self.answerContentLabel.frame.origin.y + self.answerContentLabel.frame.size.height + 6;
        if (self.answerContentLabel.hidden) {
            gridFrame.origin.y = self.answerContentLabel.frame.origin.y;
        }
        int lines = (int)((imagesCount/3) + (imagesCount%3?1:0));
        CGFloat gvHeight = ANSWER_ONE_IMAGE_HEIGHT*lines + item_spacing*(lines - 1);
        gridFrame.size.height = gvHeight;
        gridFrame.size.width = ANSWER_ONE_IMAGE_HEIGHT*3 + item_spacing*2;
        self.answerImageGridView.itemSpacing = item_spacing;
        
        self.answerImageGridView.frame = gridFrame;
        
    }else{
        self.answerImageGridView.hidden = YES;
    }
    [self.answerImageGridView reloadData];
    
    //content View
    frame = self.answerContentContainerView.frame;
    if (!self.answerImageGridView.hidden) {
        frame.size.height = self.answerImageGridView.frame.origin.y + self.answerImageGridView.frame.size.height;
    }else{
        frame.size.height = self.answerContentLabel.frame.origin.y + self.answerContentLabel.frame.size.height;
    }
    self.answerContentContainerView.frame = frame;
    
    
    
    //question view
    NSString *userName = _questionInfo.userName;
    if (!userName) {
        userName = @"他";
    }
    self.questionNameLabel.text = [NSString stringWithFormat:@"%@的提问：",userName];
    if ([_questionInfo.uId isEqualToString:[XEEngine shareInstance].uid]) {
        self.questionNameLabel.text = @"我的提问：";
    }
    self.questionTitleLabel.text = _questionInfo.title;
    self.questionTimeLabel.text = [XEUIUtils dateDiscriptionFromNowBk:_questionInfo.beginTime];
    
    self.questionContentLabel.text = _questionInfo.content;
    self.questionContentLabel.hidden = NO;
    if (_questionInfo.content.length == 0) {
        self.questionContentLabel.hidden = YES;
    }
    textSize = [XECommonUtils sizeWithText:_questionInfo.content font:self.questionContentLabel.font width:SCREEN_WIDTH-28*2];
    frame = self.questionContentLabel.frame;
    frame.size.height = textSize.height;
    self.questionContentLabel.frame = frame;
    
    //图片view
    imagesCount = self.questionInfo.picIds.count;
    if (imagesCount > 0) {
        self.questionImageGridView.hidden = NO;
        CGRect gridFrame = self.questionImageGridView.frame;
        gridFrame.origin.y = self.questionContentLabel.frame.origin.y + self.questionContentLabel.frame.size.height + 6;
        if (self.questionContentLabel.hidden) {
            gridFrame.origin.y = self.questionContentLabel.frame.origin.y;
        }
        int lines = (int)((imagesCount/3) + (imagesCount%3?1:0));
        CGFloat gvHeight = QUESTION_ONE_IMAGE_HEIGHT*lines + item_spacing*(lines - 1);
        gridFrame.size.height = gvHeight;
        gridFrame.size.width = QUESTION_ONE_IMAGE_HEIGHT*3 + item_spacing*2;
        self.questionImageGridView.itemSpacing = item_spacing;
        
        self.questionImageGridView.frame = gridFrame;
        
    }else{
        self.questionImageGridView.hidden = YES;
    }
    [self.questionImageGridView reloadData];
    
    frame = self.questionContentContainerView.frame;
    frame.origin.y = self.answerContentContainerView.frame.origin.y + self.answerContentContainerView.frame.size.height + 8;
    if (!self.questionImageGridView.hidden) {
        frame.size.height = self.questionImageGridView.frame.origin.y + self.questionImageGridView.frame.size.height + 27;
    }else{
        frame.size.height = self.questionContentLabel.frame.origin.y + self.questionContentLabel.frame.size.height + 27;
    }
    self.questionContentContainerView.frame = frame;
    
    CGFloat headHeight = self.questionContentContainerView.frame.origin.y + self.questionContentContainerView.frame.size.height;
    
    //head view
    frame = self.headView.frame;
    frame.size.height = headHeight;
    self.headView.frame = frame;
    
    self.tableView.tableHeaderView = self.headView;
}

-(void)moreAction:(id)sender{
//    if ([[XEEngine shareInstance] needUserLogin:nil]) {
//        return;
//    }
    _shareAction = [[XEShareActionSheet alloc] init];
    _shareAction.owner = self;
    _shareAction.selectShareType = XEShareType_Qusetion;
    _shareAction.questionInfo = _questionInfo;
    [_shareAction showShareAction];
    
}

- (IBAction)expertAvatarAction:(id)sender {
    if (!_expertComment || !_expertComment.uId) {
        return;
    }
    XEDoctorInfo *doctorInfo = [[XEDoctorInfo alloc] init];
    doctorInfo.doctorId = _expertComment.uId;
    doctorInfo.doctorName = _expertComment.userName;
    doctorInfo.avatar = _expertComment.avatar;
    doctorInfo.title = _expertComment.title;
    ExpertIntroViewController *vc = [[ExpertIntroViewController alloc] init];
    vc.doctorInfo = doctorInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - XEShareActionSheetDelegate
-(void) deleteTopicAction:(id)info{
    
    if ([self.delegate respondsToSelector:@selector(questionDetailViewController:deleteQuestion:)]) {
        [self.delegate questionDetailViewController:self deleteQuestion:info];
        [super backAction:nil];
    }
}

#pragma mark - GMGridViewDataSource
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    if (gridView == _answerImageGridView) {
        return self.expertComment.picIds.count;
    }else if (gridView == _questionImageGridView){
        return self.questionInfo.picIds.count;
    }
    return 0;
    
}
- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (gridView == _answerImageGridView) {
        return CGSizeMake(ANSWER_ONE_IMAGE_HEIGHT, ANSWER_ONE_IMAGE_HEIGHT);
    }else if (gridView == _questionImageGridView){
        return CGSizeMake(QUESTION_ONE_IMAGE_HEIGHT, QUESTION_ONE_IMAGE_HEIGHT);
    }
    return CGSizeMake(0, 0);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        UIImageView* imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        cell.contentView = imageView;
        
    }
    UIImageView* imageView = (UIImageView* )cell.contentView;
    NSString *imgName = @"topic_load_icon";
    if (gridView == _answerImageGridView) {
        [imageView sd_setImageWithURL:[self.expertComment.picURLs objectAtIndex:index] placeholderImage:[UIImage imageNamed:imgName]];
    }else if (gridView == _questionImageGridView){
        [imageView sd_setImageWithURL:[self.questionInfo.picURLs objectAtIndex:index] placeholderImage:[UIImage imageNamed:imgName]];
    }
    return cell;
}
#pragma mark GMGridViewActionDelegate
- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
//    NSLog(@"Did tap at index %d", position);
    NSString *url = nil;
    if (gridView == _answerImageGridView) {
        _isLookExpertPhotoBrowser = YES;
        url = [self.expertComment.picURLs objectAtIndex:position];
    }else if (gridView == _questionImageGridView){
        _isLookExpertPhotoBrowser = NO;
        url = [self.questionInfo.picURLs objectAtIndex:position];
    }
    XELog(@"url===%@",url);
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:position];
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    if (_isLookExpertPhotoBrowser) {
        return self.expertComment.picIds.count;
    }else {
        return self.questionInfo.picIds.count;
    }
    return 0;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSArray* picUrls = self.questionInfo.originalPicURLs;
    if (_isLookExpertPhotoBrowser) {
        picUrls = self.expertComment.originalPicURLs;
    }
    if (index < picUrls.count){
        MWPhoto* mwPhoto = [[MWPhoto alloc] initWithURL:[picUrls objectAtIndex:index]];
        return mwPhoto;
    }
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifierCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
}

@end
